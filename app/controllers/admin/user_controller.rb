require_dependency 'moslemcorners/di_container'

module Admin
    class UserController < ApplicationController
        include MoslemCorners::INJECT['admin_service']

        # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
        wrap_parameters :core_user, include: [:id, :email, :username, :password, :confirmation_password, :firstname, :lastname]

        def index
            respond_to do |format|
                format.json {
                    render :json => { results: [
                        { id: "001", email: "kadriansyah1@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "002", email: "kadriansyah2@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "003", email: "kadriansyah3@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "004", email: "kadriansyah4@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "005", email: "kadriansyah5@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "006", email: "kadriansyah6@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "007", email: "kadriansyah7@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "008", email: "kadriansyah8@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "009", email: "kadriansyah9@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "010", email: "kadriansyah10@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "011", email: "kadriansyah11@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "012", email: "kadriansyah12@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "013", email: "kadriansyah13@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "014", email: "kadriansyah14@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "015", email: "kadriansyah15@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "016", email: "kadriansyah16@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "017", email: "kadriansyah17@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "018", email: "kadriansyah18@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "019", email: "kadriansyah19@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"},
                        { id: "020", email: "kadriansyah20@gmail.com", username: "kadriansyah", firstname: "Kiagus Arief", lastname: "Adriansyah"}
                    ]}
                    # render :json => { results: []}
                }
            end
        end

        def delete
            respond_to do |format|
                format.json { render :json => { status: "200", message: "Success" } }
            end
        end

        def create
            user_form = Admin::UserForm.new(user_form_params)
            if admin_service.create_user(user_form)
                respond_to do |format|
                    format.json { render :json => { status: "200", message: "Success" } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        def edit
            id = params[:id]
            core_user = admin_service.find_user(id)

            # change id as string not oid
            core_user = core_user.as_json(:except => :_id).merge('id' => core_user.id.to_s)
            if core_user
                respond_to do |format|
                    format.json { render :json => { status: "200", payload: core_user } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        def update
            user_form = Admin::UserForm.new(user_form_params)
            if admin_service.update_user(user_form)
                respond_to do |format|
                    format.json { render :json => { status: "200", message: "Success" } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        private

        # Using strong parameters
        def user_form_params
            params.require(:core_user).permit(:id, :email, :username, :password, :confirmation_password, :firstname, :lastname)
            # params.require(:user).permit! # allow all
        end
    end
end
