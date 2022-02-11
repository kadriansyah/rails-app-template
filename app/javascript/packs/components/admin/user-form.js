import { LitElement, html, css } from 'lit';

class UserForm extends LitElement {
    constructor() {
        super();
        this.core_user = {
            'id':'',
            'email':'',
            'username':'',
            'password':'',
            'confirmation_password':'',
            'firstname':'',
            'lastname':'',
        };
        this.copy = 'false';
    }

    static get properties() {
        return {
            formAuthenticityToken: { type: String },
            actionUrl: { type: String },
            objectId: { type: String },
            copy: { type: String },
            core_user: { type: Object },
            title: { type: String },
            icon: { type: String },
        };
    }

	async firstUpdated() {
        if (this.objectId !== undefined) {
            let data;
            try {
                const response = await fetch(this.actionUrl +'/'+ this.objectId +'/edit');
                data = await response.json();
            } catch (error) {
                console.error(error);
            }
            console.log(data.payload);
            this.core_user = data.payload;
        }
	}

    static get styles() {
        return css `
            input[type='text'], input[type='password'], textarea, button {
                outline: none;
            }

            input[type='text']:focus, input[type='password']:focus, textarea:focus {
                box-shadow: 0 0 5px rgba(81, 203, 238, 1);
                padding: 3px 0px 3px 3px;
                margin: 5px 1px 3px 0px;
                border: 1px solid rgba(81, 203, 238, 1);
            }

            .form {
                background-color: #F6F7F8;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 70%;
                padding: 50px;
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

                width: 10%;
                text-align: right;
            }

            .form-row input[type='text'], input[type='password'] {
                background-color: #FFFFFF;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 80%;
                height: initial;

                padding: 7px;
                font-size: 14px;
            }

            .form-row .spacer {
                margin-top: 7px;
                margin-bottom: 15px;
                padding-right: 20px;

                width: 10%;
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
        `;
    }

    render() {
        return html`
            <div class='form'>
                <input id="core_user-id" type="hidden" .value="${this.core_user.id}">
                <div class='form-row'>
                    <label for='core_user-email'>Email</label>
                    <input id='core_user-email' name='core_user-email' type='text' .value="${this.core_user.email}"/>
                </div>
                <div class='form-row'>
                    <label for='core_user-username'>Username</label>
                    <input id='core_user-username' name='core_user-username' type='text' .value="${this.core_user.username}"/>
                </div>
                <div class='form-row'>
                    <label for='core_user-password'>Password</label>
                    <input id='core_user-password' name='core_user-password' type='password' .value="${this.core_user.password}"/>
                </div>
                <div class='form-row'>
                    <label for='core_user-confirmation_password'>Confirmation Password</label>
                    <input id='core_user-confirmation_password' name='core_user-confirmation_password' type='password' .value="${this.core_user.confirmation_password}"/>
                </div>
                <div class='form-row'>
                    <label for='core_user-firstname'>Firstname</label>
                    <input id='core_user-firstname' name='core_user-firstname' type='text' .value="${this.core_user.firstname}"/>
                </div>
                <div class='form-row'>
                    <label for='core_user-lastname'>Lastname</label>
                    <input id='core_user-lastname' name='core_user-lastname' type='text' .value="${this.core_user.lastname}"/>
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
        let objectId = this.shadowRoot.getElementById('core_user-id').value;
        if (objectId === '' || this.copy === 'true') {
            this.core_user.email = this.shadowRoot.getElementById('core_user-email').value;
            this.core_user.username = this.shadowRoot.getElementById('core_user-username').value;
            this.core_user.password = this.shadowRoot.getElementById('core_user-password').value;
            this.core_user.confirmation_password = this.shadowRoot.getElementById('core_user-confirmation_password').value;
            this.core_user.firstname = this.shadowRoot.getElementById('core_user-firstname').value;
            this.core_user.lastname = this.shadowRoot.getElementById('core_user-lastname').value;
            console.log(this.core_user);
            try {
                const data = await this.postData(this.actionUrl, this.core_user);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect('/admin/page/users');
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        } else {
            this.core_user.id = this.shadowRoot.getElementById('core_user-id').value;
            this.core_user.email = this.shadowRoot.getElementById('core_user-email').value;
            this.core_user.username = this.shadowRoot.getElementById('core_user-username').value;
            this.core_user.password = this.shadowRoot.getElementById('core_user-password').value;
            this.core_user.confirmation_password = this.shadowRoot.getElementById('core_user-confirmation_password').value;
            this.core_user.firstname = this.shadowRoot.getElementById('core_user-firstname').value;
            this.core_user.lastname = this.shadowRoot.getElementById('core_user-lastname').value;
            console.log(this.core_user);
            try {
                const data = await this.putData(this.actionUrl +'/'+ this.core_user.id, this.core_user);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect('/admin/page/users');
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        }
    }

    cancel() {
        this.redirect('/admin/page/users');
    }
}
customElements.define('user-form', UserForm);