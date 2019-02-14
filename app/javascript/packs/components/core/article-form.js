import { PolymerElement, html } from '@polymer/polymer/polymer-element.js';
import '@polymer/iron-icon/iron-icon.js';
import '@polymer/paper-input/paper-input.js';
import '@polymer/paper-input/paper-input-container.js';
import '@polymer/paper-card/paper-card.js';
import '@polymer/iron-ajax/iron-ajax.js';
import '@polymer/iron-input/iron-input.js';
import '@polymer/paper-progress/paper-progress.js';

import '../markazuna/markazuna-shared-styles.js';

class ArticleForm extends PolymerElement {
    static get template() {
        return html`
            <style include="shared-styles">
                :host {
                    display: block;
                    margin-top: 10px;
                }
                .wrapper-btns {
                    margin-top: 15px;
                    text-align: right;
                }
                paper-button {
                    margin-top: 10px;
                }
                paper-button.indigo {
                    background-color: var(--paper-indigo-500);
                    color: white;
                    --paper-button-raised-keyboard-focus: {
                        background-color: var(--paper-pink-a200) !important;
                        color: white !important;
                    };
                }
                paper-button.green {
                    background-color: var(--paper-green-500);
                    color: white;
                }
                paper-button.green[active] {
                    background-color: var(--paper-red-500);
                }
                paper-progress {
                    width: 100%;
                }
                #formContainer {
                    width: var(--user-form-width, 100%);
                    margin: 0 auto;
                    @apply(--user-form);
                }
                .title {
                    margin-bottom: 10px;
                }
                .title > div {
                    display: flex;
                    flex-direction: row;
                    justify-content: flex-start;
                    align-items: center;

                    padding: 5px 0 5px 0;
                    border-bottom: 2px solid #757575;
                    font-size: 16px;
                    font-weight: bold;
                }
                .title iron-icon {
                    padding: 0;
                    padding-right: 2px;
                }
                #id_wrapper {
                    display: none;
                }
                iframe {
                    width: 100%;
                    height: 600px;
                    border: 1px solid #757575;
                }
            </style>

            <iron-ajax
                id="saveAjax"
                method="post"
                url="[[actionUrl]]"
                content-type="application/json"
                handle-as="json"
                on-response="_onSaveResponse"
                on-error="_onSaveError">
            </iron-ajax>

            <iron-ajax
                    id="updateAjax"
                    method="put"
                    content-type="application/json"
                    handle-as="json"
                    on-response="_onUpdateResponse"
                    on-error="_onUpdateError">
            </iron-ajax>

            <iron-ajax
                    id="editAjax"
                    method="get"
                    content-type="application/json"
                    handle-as="json"
                    on-response="_onEditResponse"
                    on-error="_onEditError">
            </iron-ajax>

            <div class="title">
                <div><iron-icon icon="[[icon]]"></iron-icon>[[title]]</div>
                <paper-progress id="progress" hidden indeterminate></paper-progress>
            </div>

            <div id="formContainer">
                <template is="dom-if" if="[[_error]]">
                    <p class="alert-error">[[_error]]</p>
                </template>

                <iron-input id="id_wrapper" slot="input" bind-value="{{article.id}}">
                    <input id="id" type="hidden" value="{{article.id}}">
                </iron-input>
                
                <paper-input-container>
                    <label slot="label">Title</label>
                    <iron-input slot="input" bind-value="{{article.title}}">
                        <input id="title" type="text" value="{{article.title}}">
                    </iron-input>
                </paper-input-container>

                <iframe id="rich_editor" src="/tinymce" frameBorder="0" scrolling="no"></iframe>

                <paper-input-container>
                    <label slot="label">Slug</label>
                    <iron-input slot="input" bind-value="{{article.slug}}">
                        <input id="slug" type="text" value="{{article.slug}}">
                    </iron-input>
                </paper-input-container>
                
                <div class="wrapper-btns">
                    <paper-button class="link" on-tap="_cancel">Cancel</paper-button>
                    <paper-button raised class="indigo" on-tap="_save">Save</paper-button>
                </div>
            </div>
        `;
    }

    static get properties() {
        return {
            formAuthenticityToken: String,
            actionUrl: {
                type: String,
                value: ''
            },
            rich_editor: {
                type: Object
            },
            article: {
                type: Object,
                value: {},
                notify: true
            },
            title: {
                type: String,
                value: ''
            },
            icon: {
                type: String,
                value: ''
            },
            _mode: {
                type: String,
                value: 'new'
            },
            _error: String
        };
    }

    constructor() {
        super();
    }

    ready() {
        super.ready();
        this.rich_editor = this.$.rich_editor.contentWindow;
    }

    edit(id) {
        this.$.editAjax.url = this.actionUrl +'/'+ id +'/edit';
        this.$.editAjax.generateRequest();
        this._mode = 'edit';
    }

    copy(id) {
        this.$.editAjax.url = this.actionUrl +'/'+ id +'/edit';
        this.$.editAjax.generateRequest();
        this._mode = 'copy';
    }

    _clear() {
        this.article = {};
        this.rich_editor.clearContent();
    }

    _onEditResponse(data) {
        var response = data.detail.response;
        this.article = response.payload;
        if (this._mode === 'copy') {
            this.article.id = ''; // nullify id, we will save it as new document
        }
        this.rich_editor.setContents(this.article.content);
        this.dispatchEvent(new CustomEvent('editSuccess', {bubbles: true, composed: true}));
    }

    _onEditError() {
        this._error = 'Edit Article Error';
    }

    _onSaveResponse(e) {
        var response = e.detail.response;
        if (response.status == '200') {
            this._error = '';
            this._mode = 'new';
            this._clear();
            this.dispatchEvent(new CustomEvent('saveSuccess', {bubbles: true, composed: true}));
        }
        else {
            this._error = 'Creating Article Error';
        }
        this.$.progress.hidden = true;
    }

    _onSaveError() {
        this._error = 'Creating Article Error';
        this.$.progress.hidden = true;
    }

    _onUpdateResponse(data) {
        var response = data.detail.response;
        if (response.status == '200') {
            this._error = '';
            this._mode = 'new';
            this._clear();
            this.dispatchEvent(new CustomEvent('saveSuccess', {bubbles: true, composed: true}));
        }
        else {
            this._error = 'Updating Article Error';
        }
        this.$.progress.hidden = true;
    }

    _onUpdateError() {
        this._error = 'Creating Article Error';
        this.$.progress.hidden = true;
    }

    _save() {
        this.article.content = this.rich_editor.getContents();
        if (this._mode === 'new' || this._mode === 'copy') {
            this.$.saveAjax.headers['X-CSRF-Token'] = this.formAuthenticityToken;
            this.$.saveAjax.body = this.article;
            this.$.saveAjax.generateRequest();
            this.$.progress.hidden = false;
        }
        else {
            this.$.updateAjax.headers['X-CSRF-Token'] = this.formAuthenticityToken;
            this.$.updateAjax.body = this.article;
            this.$.updateAjax.url = this.actionUrl +'/'+ this.article.id;
            this.$.updateAjax.generateRequest();
            this.$.progress.hidden = false;
        }
    }

    _cancel() {
        this._error = '';
        this._mode = 'new';
        this._clear();
        this.dispatchEvent(new CustomEvent('cancel', {bubbles: true, composed: true}));
    }
}
customElements.define('article-form', ArticleForm);
