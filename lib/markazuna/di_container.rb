require 'dry-container'
require 'dry-auto_inject'
require 'markazuna/cache'

module Markazuna
    class DIContainer
        extend Dry::Container::Mixin

        register 'article_service' do
			Core::ArticleService.new
		end

        register 'admin_service' do
            Admin::AdminService.new
        end

        register 'group_service' do
            Admin::GroupService.new
        end

        register 'system_cache' do
            Markazuna::Cache.instance # return singleton object
        end
    end

    # dependency injection
    INJECT = Dry::AutoInject(Markazuna::DIContainer)
end