import { LitElement, html, css } from 'lit-element';

class ArticleForm extends LitElement {
    constructor() {
        super();
        this.rich_editor = {};
        this.article = {'id':'', 'title':'', 'slug':'', 'content':''};
        this.copy = 'false';
    }

    static get properties() {
        return {
            formAuthenticityToken: { type: String },
            actionUrl: { type: String },
            objectId: { type: String },
            copy: { type: String },
            rich_editor: { type: Object },
            article: { type: Object },
            title: { type: String },
            icon: { type: String },
        };
    }

    async firstUpdated() {
        // make sure iframe content is loaded
        let _self = this;
        this.shadowRoot.getElementById('rich_editor').contentWindow.onload = function() {
            _self.rich_editor = _self.shadowRoot.getElementById('rich_editor').contentWindow;
            _self.rich_editor.register(_self);
        };

        if (this.objectId !== undefined) {
            let data;
            try {
                const response = await fetch(this.actionUrl +'/'+ this.objectId +'/edit');
                data = await response.json();
            } catch (error) {
                console.error(error);
            }
            console.log(data.payload);
            this.article = data.payload;
        }
    }

    // using callback to make sure tinymce is ready
    setContentsCallback() {
        this.rich_editor.setContents(this.article.content);
    }

    static get styles() {
        return css `
            input[type=text], textarea, button {
                outline: none;
            }

            input[type=text]:focus, textarea:focus {
                box-shadow: 0 0 5px rgba(81, 203, 238, 1);
                padding: 3px 0px 3px 3px;
                margin: 5px 1px 3px 0px;
                border: 1px solid rgba(81, 203, 238, 1);
            }

            .form {
                background-color: #F6F7F8;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 90%;
                padding: 40px;
                margin: 0 0 40px 0;
            }

            .form-row {
                margin-bottom: 10px;

                display: flex;
                flex-direction: row;
                flex-wrap: nowrap;
                justify-content: flex-start;
                align-items: center;
            }

            .form-row label {
                margin-top: 7px;
                margin-bottom: 15px;
                padding-right: 20px;

                width: 1%;
                text-align: right;
            }

            .form-row input[type='text'] {
                background-color: #FFFFFF;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 50%;
                height: initial;

                padding: 7px;
                font-size: 14px;
            }

            .form-row .spacer {
                margin-top: 7px;
                margin-bottom: 15px;
                padding-right: 20px;

                width: 1%;
                text-align: right;
            }

            .form-row button {
                font-size: 14px;
                font-weight: bold;

                border: none;
                border-radius: 3px;

                padding: 10px 40px;
                cursor: pointer;

                margin-right: 5px;
            }

            .form-row button.submit {
                color: #FFFFFF;
                background-color: #2196F3;
            }

            .form-row button.cancel {
                color: #CFD8DC;
                background-color: #90A4AE;
            }

            .form-row button.submit:hover {
                background-color: #1E88E5;
            }

            .form-row button.cancel:hover {
                background-color: #78909C;
            }

            .form-row button:active {
                background-color: #407FC7;
            }

            .form-row iframe {
                width: 85%;
                height: 600px;
                border: 1px solid #757575;
            }
        `;
    }

    render() {
        return html`
            <div class='form'>
                <input id="article-id" type="hidden" .value="${this.article.id}">
                <div class='form-row'>
                    <label for='article-title'>Title</label>
                    <input id='article-title' name='article-title' type='text' .value="${this.article.title}"/>
                </div>
                <div class='form-row'>
                    <label for='article-slug'>Slug</label>
                    <input id='article-slug' name='article-slug' type='text' .value="${this.article.slug}" @focus="${this.string_to_slug}"/>
                </div>
                <div class='form-row'>
                    <label for='rich_editor'></label>
                    <iframe id="rich_editor" src="/tinymce" frameBorder="0" scrolling="no"></iframe>
                </div>
                <div class='form-row'>
                    <div class="spacer"></div>
                    <button class="submit" @click="${this.submit}">Submit</button>
                    <button class="cancel" @click="${this.cancel}">Cancel</button>
                </div>
            </div>
        `;
    }

    redirect(href) {
        window.location.href = href;
    }

    string_to_slug() {
        if (this.shadowRoot.getElementById('article-slug').value === '') {
            let str = this.shadowRoot.getElementById('article-title').value;
            str = str.trim();
            str = str.toLowerCase();

            // remove accents, swap ñ for n, etc
            const from = "åàáãäâèéëêìíïîòóöôùúüûñç·/_,:;";
            const to = "aaaaaaeeeeiiiioooouuuunc------";

            for (let i = 0, l = from.length; i < l; i++) {
                str = str.replace(new RegExp(from.charAt(i), "g"), to.charAt(i));
            }

            this.shadowRoot.getElementById('article-slug').value = str
                .replace(/[^a-z0-9 -]/g, "") // remove invalid chars
                .replace(/\s+/g, "-") // collapse whitespace and replace by -
                .replace(/-+/g, "-") // collapse dashes
                .replace(/^-+/, "") // trim - from start of text
                .replace(/-+$/, "") // trim - from end of text
                .replace(/-/g, '-');
        }
    }

    async postData(url = '', data = {}) {
        // Default options are marked with *
        const response = await fetch(url, {
            method: 'POST', // *GET, POST, PUT, DELETE, etc.
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.formAuthenticityToken
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer', // no-referrer, *client
            body: JSON.stringify(data) // body data type must match "Content-Type" header
        });
        return await response.json(); // parses JSON response into native JavaScript objects
    }

    async putData(url = '', data = {}) {
        // Default options are marked with *
        const response = await fetch(url, {
            method: 'PUT', // *GET, POST, PUT, DELETE, etc.
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.formAuthenticityToken
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer', // no-referrer, *client
            body: JSON.stringify(data) // body data type must match "Content-Type" header
        });
        return await response.json(); // parses JSON response into native JavaScript objects
    }

    async submit() {
        let objectId = this.shadowRoot.getElementById('article-id').value;
        if (objectId === '' || this.copy === 'true') {
            this.article.title = this.shadowRoot.getElementById('article-title').value;
            this.article.slug = this.shadowRoot.getElementById('article-slug').value;
            this.article.content = this.rich_editor.getContents();
            console.log(this.article);
            try {
                const data = await this.postData(this.actionUrl, this.article);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect('/admin/page/articles');
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        } else {
            this.article.id = this.shadowRoot.getElementById('article-id').value;
            this.article.title = this.shadowRoot.getElementById('article-title').value;
            this.article.slug = this.shadowRoot.getElementById('article-slug').value;
            this.article.content = this.rich_editor.getContents();
            console.log(this.article);
            try {
                const data = await this.putData(this.actionUrl +'/'+ this.article.id, this.article);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect('/admin/page/articles');
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        }
    }

    cancel() {
        this.redirect('/admin/page/articles');
    }
}
customElements.define('article-form', ArticleForm);