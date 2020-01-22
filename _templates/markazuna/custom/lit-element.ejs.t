---
to: app/javascript/packs/components/markazuna/<%= h.changeCase.paramCase(name) %>.js
---
import { LitElement, html, css } from 'lit-element';

export class <%= name %> extends LitElement {
    constructor() {
        super();
        this.state = {};
    }

    static get properties() {
		return {
            state: { type: Object },
		};
    }

    firstUpdated() {
        
    }

    static get styles() {
        return css `
            
        `;
    }

    render() {
        return html`
            
        `;
    }
}
customElements.define('<%= h.changeCase.paramCase(name) %>', <%= name %>);