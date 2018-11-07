import { html } from '@polymer/polymer/polymer-element.js';
import { BaseList } from '../base-list.js'

import '../markazuna/markazuna-circular-pager.js';
import './group-form.js';

class GroupList extends BaseList {
    static get listTemplate() {
        return html`
            <div class="flex grid-container" width="100%">
                <vaadin-grid theme="row-stripes" aria-label="Users" items="[[data]]">
                    
                    <vaadin-grid-column width="40%" flex-grow="0">
                        <template class="header">
                            <div class="grid-header-left">Name</div>
                        </template>
                        <template>
                            <div class="grid-content-left">[[item.name]]</div>
                        </template>
                    </vaadin-grid-column>
                    
                    <vaadin-grid-column width="40%" flex-grow="0">
                        <template class="header">
                            <div class="grid-header-left">Description</div>
                        </template>
                        <template>
                            <div class="grid-content-left">[[item.description]]</div>
                        </template>
                    </vaadin-grid-column>
                    
                    <vaadin-grid-column width="20%" flex-grow="0">
                        <template class="header"><div class="grid-header">Actions</div></template>
                        <template>
                            <div class="grid-header">
                                <iron-icon icon="icons:create" on-tap="_edit" id="[[item.id]]"></iron-icon>
                                <iron-icon icon="icons:delete" on-tap="_confirmation" id="[[item.id]]"></iron-icon>
                                <iron-icon icon="icons:content-copy" on-tap="_copy" id="[[item.id]]"></iron-icon>
                            </div>
                        </template>
                    </vaadin-grid-column>
                </vaadin-grid>
            </div>
            <div class="flex" width="100%">
                <markazuna-circular-pager page="[[page]]" count="[[count]]" range="10" url="/admin/groups?page=#{page}"></markazuna-circular-pager>
            </div>
        `;
    }

    static get formTemplate() { 
        return html`
            <group-form action-url="[[dataUrl]]" form-authenticity-token="[[formAuthenticityToken]]" id="formData"></group-form>
        `;
    }

    constructor() {
        super();
    }

    ready() {
        super.ready();
    }

    _formTitleNew() {
        return 'Create New Group';
    }

    _formTitleEdit() {
        return 'Edit Group';
    }

    _formTitleCopy() {
        return 'Copy Group';
    }
}
customElements.define('group-list', GroupList);