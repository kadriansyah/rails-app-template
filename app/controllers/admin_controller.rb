require_dependency 'moslemcorners/di_container'

class AdminController < ApplicationController
    before_action :authenticate_core_user!, except: [:index]

    def index

    end

    def create

    end
end
