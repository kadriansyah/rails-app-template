require 'markazuna/di_container'

class AdminController < ApplicationController
    def index

    end

    def page
        case params[:name]
            ####### articles #######
            when 'articles'
                render template: 'core/articles'

            when 'article_new'
                render template: 'core/article_form', :locals => { :_id => nil }
            
            when 'article_edit'
                render template: 'core/article_form', :locals => { :_id => params[:id], :_copy => 'false' }

            when 'article_copy'
                render template: 'core/article_form', :locals => { :_id => params[:id], :_copy => 'true' }

            ####### groups #######
            when 'groups'
                render template: 'admin/groups'
            
            when 'group_new'
                render template: 'admin/group_form', :locals => { :_id => nil }

            when 'group_edit'
                render template: 'admin/group_form', :locals => { :_id => params[:id], :_copy => 'false' }

            when 'group_copy'
                render template: 'admin/group_form', :locals => { :_id => params[:id], :_copy => 'true' }

            ####### users #######
            when 'users'
                render template: 'admin/users'
            
            when 'user_new'
                render template: 'admin/user_form', :locals => { :_id => nil }

            when 'user_edit'
                render template: 'admin/user_form', :locals => { :_id => params[:id], :_copy => 'false' }

            when 'user_copy'
                render template: 'admin/user_form', :locals => { :_id => params[:id], :_copy => 'true' }
        end
    end
end
