require_dependency 'markazuna/di_container'

class IndexController < ActionController::Base
    layout 'index'

    def index
        render :index
    end

    def show 
        ## TODO implementation depends on your project need
    end
end
