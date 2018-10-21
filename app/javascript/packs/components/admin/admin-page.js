import { PolymerElement, html } from '@polymer/polymer/polymer-element.js';
import '@polymer/iron-flex-layout/iron-flex-layout.js';
import '@polymer/iron-location/iron-location.js';
import '@polymer/iron-media-query/iron-media-query.js';
import '@polymer/paper-icon-button/paper-icon-button.js';
import '@polymer/iron-icons/iron-icons.js'
import '@polymer/paper-menu-button/paper-menu-button.js';
import '@polymer/paper-item/paper-item.js';
import '@polymer/app-layout/app-layout.js';
import '@polymer/app-layout/app-header-layout/app-header-layout.js';
import '@polymer/app-layout/app-drawer/app-drawer.js';
import '@polymer/app-layout/app-drawer-layout/app-drawer-layout.js';
import '@polymer/app-layout/app-toolbar/app-toolbar.js';
import '@polymer/app-layout/app-scroll-effects/app-scroll-effects.js';

import '../moslemcorner/moslemcorner-shared-styles.js';
import '../moslemcorner/moslemcorner-search-bar.js';

class AdminPage extends PolymerElement {
    static get template() {
        return html`
            <style include="shared-styles">
                :host {
                    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
                }
                /* override highlight */
                :host {
                    --paper-menu-focused-item-after: {
                        background: #FFFFFF !important;
                    };
                }
                /* disable focus rectangle */
                :host {
                    --paper-item-focused: {
                        outline: none !important;
                    };
                }
                :host {
                    --paper-font-subhead: {
                        font-size: 14px;
                        font-weight: normal;
                    }
                }
                :host {
                    --paper-item: {
                    min-height: 30px !important;
                    };
                }
                app-header {
                    background-color: rgba(255, 255, 255, 0.95);
                    --app-header-shadow: {
                        box-shadow: inset 0 5px 6px -3px rgba(0, 0, 0, 0.2);
                        height: 10px;
                        bottom: -10px;
                    };
                }
                app-header:not([shadow]) {
                    border-bottom: 1px solid #ddd;
                }
                paper-icon-button {
                    color: #000;
                    --paper-icon-button-ink-color: #31f0ef;
                }
                paper-item:hover {
                    cursor: pointer;
                }
                .sublist paper-item {
                    padding-left: 30px;
                }
                .pannel {
                    width: 100%;
                    height: 100%;
                    padding: 0;
                    margin: 0;
                }
                .title {
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }
                .search {
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    text-align: right;
                }
                #toolbar {
                    height: 64px;
                }
                #drawerTitleContainer {
                    width: 100%;
                    height: 64px;
                    display: table;
                    background-color: #f3f3f3;
                    border-bottom: 1px solid #e0e0e0;
                }
                #drawerTitle {
                    display: table-cell;
                    vertical-align: middle;
                    text-align: center;
                    font-weight: bold;
                }
                paper-menu, paper-item {
                    display: block;
                    padding: 5px;
                    font-size: 15px;
                }
            </style>

            <iron-media-query query="max-width: 400px" query-matches="{{smallScreen}}"></iron-media-query>

            <iron-location id="location" path="{{path}}" hash="{{hash}}" query="{{query}}" dwell-time="{{dwellTime}}"></iron-location>

            <app-header-layout>
                <app-header reveals>
                    <app-toolbar id="toolbar">
                        <paper-icon-button icon="menu" onclick="drawer.toggle()"></paper-icon-button>
                        <div main-title></div>
                        <div class="mdc-layout-grid pannel">
                            <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-5"></div>
                            <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-2 title">[[title]]</div>
                            <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-5 search"><moslemcorner-search-bar on-tap="_openSearch" id="search"></moslemcorner-search-bar></div>
                        </div>
                    </app-toolbar>
                </app-header>
            </app-header-layout>

            <app-drawer-layout drawer-width="288px" force-narrow>
                <app-drawer id="drawer" swipe-open>
                    <div id="drawerTitleContainer"><div id="drawerTitle">markazunaa</div></div>
                    <paper-menu-button tabindex="-1" multi>
                        <paper-item class="menu-trigger">Content</paper-item>
                        <paper-item class="menu-trigger">Access</paper-item>
                        <!--
                        <paper-submenu id="contentSubmenu">
                            <paper-item class="menu-trigger">Content</paper-item>
                            <paper-menu class="menu-content sublist" id="contentItems">
                                <paper-item on-tap="_openUrl" id="articles">Articles</paper-item>
                                <paper-item on-tap="_openUrl" id="tags">Tags</paper-item>
                            </paper-menu>
                        </paper-submenu>
                        <paper-submenu id="accessSubmenu">
                            <paper-item class="menu-trigger">Access</paper-item>
                            <paper-menu class="menu-content sublist"  id="accessItems">
                                <paper-item on-tap="_openUrl" id="groups">Groups</paper-item>
                                <paper-item on-tap="_openUrl" id="users">Users</paper-item>
                            </paper-menu>
                        </paper-submenu>
                        -->
                    </paper-menu-button>
                </app-drawer>
                <div>Manage Articles</div>
            </app-drawer-layout>
        `;
    }

    static get properties() {
        return {
            formAuthenticityToken: {
                type: String
            },
            title: {
                type: String,
                value: ''
            },
            page: {
                type: String,
                value: ''
            },
            sections: {
                type: Array,
                value: function() {
                    return [
                        ''
                    ];
                }
            }
        };
    }

    constructor() {
        super();
    }

    ready() {
        super.ready();
        self = this;
        this.title = 'Title';
        // this.async(function() {
        //     this.title = 'Manage Articles';
        //     this.$.contentSubmenu.open();
        //     this.$.accessSubmenu.open();
        // });
    }

    _shouldShowTabs(smallScreen) {
        return !smallScreen;
    }

    _removeFocus(currentSelectedElementId) {
        // remove current selected paper-item
        if (currentSelectedElementId == 'groups' || currentSelectedElementId == 'users') {
            this.$.contentItems.selectIndex(-1);
        }
        else {
            this.$.accessItems.selectIndex(-1);
        }
    }

    _openUrl(e) {
        this._removeFocus(e.target.id);
        this.$.location.path = this.$.location.path +'/page/'+ e.target.id;
        window.location.reload(true);
    }
}
customElements.define('admin-page', AdminPage);