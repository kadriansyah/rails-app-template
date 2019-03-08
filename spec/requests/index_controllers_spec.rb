require 'rails_helper'

RSpec.describe "IndexControllers", type: :request do
	describe "Index Controller" do
		it "main page" do
			get '/'
			expect(response).to have_http_status(200)
			expect(response).to render_template(:index)
			expect(response.body).to include("Watch a tiny cat taking a bath")
		end

		it "slug" do
			get '/slug'
			expect(response).to have_http_status(200)
			expect(response).to render_template('core/article')
			expect(response.body).to include("Lorem ipsum dolor sit amet")
		end
	end
end
