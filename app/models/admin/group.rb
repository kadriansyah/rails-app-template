require 'markazuna/common_model'

class Admin::Group
	include Mongoid::Document
    include Markazuna::CommonModel
    store_in collection: 'groups'

    # kaminari page setting
    paginates_per 25
	
    field :name, type: String, default: ''
    field :description, type: String, default: ''
end
