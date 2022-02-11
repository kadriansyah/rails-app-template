import { LitElement, html, css } from 'lit';

export class ModalBase extends LitElement {
    constructor() {
        super();
        this.state = {};
        this.title = '';
        this.message = '';
    }

    static get properties() {
		return {
            debug: { type: Boolean },
            state: { type: Object },
            title: { type: String },
            message: { type: String },
		};
    }
    
    static get styles() {
        return css `
            /* The Modal (background) */
            .modal {
                display: none; /* Hidden by default */
                position: fixed; /* Stay in place */
                z-index: 1; /* Sit on top */
                left: 0;
                top: 0;
                width: 100%; /* Full width */
                height: 100%; /* Full height */
                overflow: auto; /* Enable scroll if needed */
                background-color: rgb(0,0,0); /* Fallback color */
                background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            }
            /* Modal Content/Box */
            .modal-content {
                display: flex;
                flex-direction: column;
                background-color: #fefefe;
                margin: 15% auto; /* 15% from the top and centered */
                padding: 20px;
                border: 1px solid #888;
                width: 30%; /* Could be more or less, depending on screen size */
                font-family: 'Roboto Condensed', sans-serif;
                font-weight: bold;
                font-size: 14px;
                animation-name: animatetop;
                animation-duration: 0.4s
            }
            /* Add Animation */
            @keyframes animatetop {
                from {top: -300px; opacity: 0}
                to {top: 0; opacity: 1}
            }
            .modal-title {
                display: flex;
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }
            .modal-button {
                display: flex;
                flex-direction: row;
                justify-content: flex-end;
            }
            /* The Close Button */
            .close {
                color: #AAA;
                font-size: 28px;
                font-weight: bold;
            }
            .close:hover,
            .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }
            button.yes {
                font-family: 'Roboto Condensed', sans-serif;
                background-color: #2196F3;
                color: white;
                font-size: 12px;
                font-weight: bold;
                border: none;
                border-radius: 3px;
                padding: 10px 40px;
                cursor: pointer;
                outline: none;
            }
            button.yes:hover {
                background-color: #1E88E5;
            }
            button.no {
                font-family: 'Roboto Condensed', sans-serif;
                background-color: #90A4AE;
                color: white;
                font-size: 12px;
                font-weight: bold;
                border: none;
                border-radius: 3px;
                padding: 10px 40px;
                cursor: pointer;
                outline: none;
                margin-right: 5px;
            }
            button.no:hover {
                background-color: #78909C;
            }
        `;
    }

    render() {
        return html`
            <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed&display=swap" rel="stylesheet">
            <div id="modal-container" class="modal">
                <div class="modal-content">
                    <div class="modal-title">
                        <div>${this.title}</div><span class="close" @click="${this.close}">&times;</span>
                    </div>
                    <p>${this.message}</p>
                    <div class="modal-button">
                        <button class="no" @click="${this.close}">No</button><button class="yes" @click="${this.buttonYes}">Yes</button>
                    </div>
                </div>
            </div>
        `;
    }

    /* state should be object with format: {action:"[action name]", id:"object id"} */
    open(state, title, message) {
        this.state = state;
        this.title = title;
        this.message = message;
        let modal = this.shadowRoot.getElementById('modal-container');
        modal.style.display = "block";
    }

    close() {
        let modal = this.shadowRoot.getElementById('modal-container');
        modal.style.display = "none";
    }

    buttonYes() {
        let event = new CustomEvent('button-yesEvent', { detail: { state: this.state }, bubbles: true, composed: true });
        this.dispatchEvent(event);
    }
}
customElements.define('modal-base', ModalBase);