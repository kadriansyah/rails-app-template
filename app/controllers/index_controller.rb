require_dependency 'markazuna/di_container'

class IndexController < ActionController::Base
    include Markazuna::INJECT['article_service']
    layout 'index'

    def index
        render :index
    end

    def show
        ## uncomment to implement this!
        # @article = article_service.find_article_by_slug(params[:slug])
        @article = Core::Article.new
        @article.content = 'Hello World'
        render layout: 'post', template: 'core/article'
    end
end
