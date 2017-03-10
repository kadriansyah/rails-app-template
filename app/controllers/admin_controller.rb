require_dependency 'moslemcorners/di_container'

class AdminController < ApplicationController
    before_action :authenticate_core_user!, except: [:index, :page]

    def index

    end

    def page
        case params[:name]
            when 'articles'
                render template: 'admin/articles'

            when 'tags'
                render template: 'admin/tags'

            when 'groups'
                render template: 'admin/groups'

            when 'users'
                render template: 'admin/users'
        end
    end
end
