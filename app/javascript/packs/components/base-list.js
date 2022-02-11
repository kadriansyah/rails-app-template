import { LitElement, html, css } from 'lit';
import './markazuna/modal-base.js';

export class BaseList extends LitElement {
    constructor() {
        super();
        this.dataUrl = '';
        this.data = [];
    }

    static get properties() {
		return {
            dataUrl: { type: String },
			data: { type: Array },
		};
	}

    // Don't use connectedCallback() since it can't be async
	async firstUpdated() {
        this.addEventListener('button-yesEvent', this.handleButtonYesEvent);
		let data;
		try {
			const response = await fetch(this.dataUrl);
			data = await response.json();
		} catch (error) {
			console.error(error);
        }

        console.log(data.results);

		this.data = []
        data.results.forEach(function(item) {
            this.data.push(item);
        }, this);
	}

    static get styles() {
        return css `
            .top-menu {
                width: 100%;
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
            }
            .search-bar {
                display: flex;
                align-items: stretch;
            }
            button {
                font-family: 'Roboto Condensed', sans-serif;
                background-color: #2196F3;
                color: white;
                font-size: 14px;
                font-weight: bold;
                border: none;
                border-radius: 3px;
                padding: 10px 40px;
                cursor: pointer;
                outline: none;
            }
            button:hover {
                background-color: #1E88E5;
            }
            .search {
                width: 400px;
                border: 2px solid #DADADA;
                margin-right: 2px;
                font-size: 13px;
            }
            .search:focus { 
                outline: none;
                border-color: #9ECAED;
                box-shadow: 0 0 10px #9ECAED;
            }
            table {
                width: 100%;
                font-family: 'Roboto Condensed', sans-serif;
            }
        `;
    }

    render() {
        return html`
            <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed&display=swap" rel="stylesheet">
            <div class="top-menu">
                <button @click="${this.add}">${this.buttonName}</button>
                <div class="search-bar">
                    <input class="search" type="text" name="search" placeholder="" id="search">
                    <button @click="${this.search}">Search</button>
                </div>
            </div>
            <modal-base id="modal"></modal-base>
            <table cellspacing="0" cellpadding="0">
                ${this.headerTemplate}
                ${this.dataTemplate}
                ${this.footerTemplate}
            </table>
        `;
    }

    redirect(href) {
        window.location.href = href;
    }

    reload() {
        window.location.reload();
    }
}
customElements.define('base-list', BaseList);