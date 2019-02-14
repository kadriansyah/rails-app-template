import { html } from '@polymer/polymer/polymer-element.js';
import { BaseList } from '../base-list.js'

import '../markazuna/markazuna-circular-pager.js';
import './article-form.js';

class ArticleList extends BaseList {
    static get listTemplate() {
        return html`
            <div class="flex" width="100%">
                <vaadin-grid theme="row-stripes" aria-label="Users" items="[[data]]">

                    <vaadin-grid-column width="50%" flex-grow="0">
                        <template class="header">
                            <div class="grid-header-left">Title</div>
                        </template>
                        <template>
                            <div class="grid-content-left">[[item.title]]</div>
                        </template>
                    </vaadin-grid-column>
                    
                    <vaadin-grid-column width="30%" flex-grow="0">
                        <template class="header">
                            <div class="grid-header-left">Slug</div>
                        </template>
                        <template>
                            <div class="grid-content-left">[[item.slug]]</div>
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
                <markazuna-circular-pager page="[[page]]" count="[[count]]" range="10" url="/admin/articles?page=#{page}"></markazuna-circular-pager>
            </div>
        `;
    }

    static get formTemplate() { 
        return html`
            <article-form action-url="[[dataUrl]]" form-authenticity-token="[[formAuthenticityToken]]" id="formData"></article-form>
        `;
    }

    constructor() {
        super();
    }

    ready() {
        super.ready();
    }

    _formTitleNew() {
        return 'Create New Article';
    }

    _formTitleEdit() {
        return 'Edit Article';
    }

    _formTitleCopy() {
        return 'Copy Article';
    }
}
customElements.define('article-list', ArticleList);