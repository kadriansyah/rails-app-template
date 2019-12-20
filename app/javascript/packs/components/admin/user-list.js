import { html, css } from 'lit-element';
import { BaseList } from '../base-list.js'
import edit from '../images/edit.svg'
import del from '../images/delete.svg'
import copy from '../images/copy.svg'

class UserList extends BaseList {
    constructor() {
        super();
        this.debug = false;
        this.buttonName = "Add User";
    }

    static get styles() {
        return [
            super.styles, 
            css `
                .row-head {
                    background-color: #2A3F54;
                }
                .row-head th {
                    font-size: 15px;
                    color: #FFFFFF;
                    text-align: left;
                    padding: 5px 5px;
                }
                .row-data-even {
                    background-color: #F2F3F4;
                }
                .row-data-odd {
                    background-color: #FFFFFF;
                }
                .row-data td {
                    border-bottom: 1pt solid #AAB7B8;
                }
                .row-data td {
                    font-size: 14px;
                    text-align: left;
                    padding: 5px 5px;
                }
                .col-1 {
                    width: 10%;
                }
                .col-2 {
                    width: 20%;
                }
                .col-3 {
                    width: 20%;
                }
                .col-4 {
                    width: 20%;
                }
                .col-5 {
                    width: 20%;
                }
                .action {
                    text-align: center !important;
                }
                .action img:hover {
                    cursor: pointer;
                }
            `
        ];
    }

    get headerTemplate() {
        return html`
            <thead>
                <tr class='row-head'>
                    <th class="colnum"> # </th>
                    <th class="firstname">Firstname</th>
                    <th class="lastname">Lastname</th>
                    <th class="username">Username</th>
                    <th class="email">Email</th>
                    <th colspan="3" class="action">Action</th>
                </tr>
            </thead>
        `;
    }

    get dataTemplate() {
        return html`
            <tbody>
                ${this.data.map(
                        (u, idx) =>
                        html `
                            ${idx % 2 == 0?
                            html `
                                <tr class="row-data row-data-even">
                                    <td class="col-1">${idx+1}</td>
                                    <td class="col-2">${u.firstname}</td>
                                    <td class="col-3">${u.lastname}</td>
                                    <td class="col-4">${u.username}</td>
                                    <td class="col-5">${u.email}</td>
                                    <td class="action"><img title="edit" src="${edit}" height="24" width="24" id="${u.id}" @click="${this.edit}"/></td>
                                    <td class="action"><img title="copy" src="${copy}" height="24" width="24" id="${u.id}" @click="${this.copy}"/></td>
                                    <td class="action"><img title="delete" src="${del}" height="24" width="24" id="${u.id}" @click="${this.confirmation}"/></td>
                                </tr>
                            `:
                            html `
                                <tr class="row-data row-data-odd">
                                    <td class="col-1">${idx+1}</td>
                                    <td class="col-2">${u.firstname}</td>
                                    <td class="col-3">${u.lastname}</td>
                                    <td class="col-4">${u.username}</td>
                                    <td class="col-5">${u.email}</td>
                                    <td class="action"><img title="edit" src="${edit}" height="24" width="24" id="${u.id}" @click="${this.edit}"/></td>
                                    <td class="action"><img title="copy" src="${copy}" height="24" width="24" id="${u.id}" @click="${this.copy}"/></td>
                                    <td class="action"><img title="delete" src="${del}" height="24" width="24" id="${u.id}" @click="${this.confirmation}"/></td>
                                </tr>
                            `}
            			`,
					)
				}
            </tbody>
        `;
    }

    get footerTemplate() {
        return html`
            <tfoot>
                <tr><td colspan="8"><h3>Pagination Here</h3></td></tr>
            </tfoot>
        `;
    }

    add(e) {
        this.redirect('/admin/page/user_new');
    }

    edit(e) {
        this.redirect('/admin/page/user_edit/'+ e.target.id);
    }

    copy(e) {
        this.redirect('/admin/page/user_copy/'+ e.target.id);
    }

    async search() {
        let username = this.shadowRoot.getElementById("search").value;
        let data;
		try {
            if (username === '') {
                const response = await fetch(this.dataUrl);
                data = await response.json();
            } else {
                const response = await fetch(this.dataUrl + "/search?username="+ username + "&page=0");
                data = await response.json();
            }
		} catch (error) {
			console.error(error);
        }

        if (this.debug) {
            console.log(data.results);            
        }

		this.data = []
        data.results.forEach(function(item) {
            this.data.push(item);
        }, this);
    }

    confirmation(e) {
        let modal = this.shadowRoot.getElementById('modal');
        let state = {action:'delete', id: e.target.id};
        modal.open(state, 'Delete Confirmation', 'Are you sure to delete this user?');
    }

    handleButtonYesEvent(e) {
        this.delete(e.detail.state.id);
    }

    async delete(id) {
        console.log(id);
        let data;
		try {
			const response = await fetch(this.dataUrl +'/'+ id + '/delete');
			data = await response.json();
		} catch (error) {
			console.error(error);
        }
        console.log(data);            
		this.reload();
    }
}
customElements.define('user-list', UserList);