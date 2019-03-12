require 'rails_helper'

# https://relishapp.com/rspec/
# https://relishapp.com/rspec/rspec-expectations/v/3-8/docs
RSpec.describe "Users", type: :request do
	describe "Users API" do
		admin_user = Admin::CoreUser.find_by(email: "admin@gmail.com")
		before(:all) {
			@core_user = create(:admin_core_user)
		}

		before(:each) {
			sign_in admin_user
		}

		after(:each) { 
			sign_out admin_user
		}

		after(:all) {
			@core_user.delete
			core_user = Admin::CoreUser.find_by(email: "kadriansyah@gmail.com")
			core_user.delete if core_user.present?
		}

		it "create user" do
			payload = {
				:core_user => {
					:email => 'kadriansyah@gmail.com',
					:username => 'kadriansyah',
					:password => 'password',
					:confirmation_password => 'password',
					:firstname => 'Kiagus Arief',
					:lastname => 'Adriansyah'
				}
			}.to_json
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			post '/admin/users', :params => payload, :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('200')
		end

		it "create user without email" do
			payload = {
				:core_user => {
					:username => 'kadriansyah',
					:password => 'password',
					:confirmation_password => 'password',
					:firstname => 'Kiagus Arief',
					:lastname => 'Adriansyah'
				}
			}.to_json
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			post '/admin/users', :params => payload, :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('404')
		end

		it "create user without password" do
			payload = {
				:core_user => {
					:email => 'kadriansyah@gmail.com',
					:username => 'kadriansyah',
					:confirmation_password => 'password',
					:firstname => 'Kiagus Arief',
					:lastname => 'Adriansyah'
				}
			}.to_json
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			post '/admin/users', :params => payload, :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('404')
		end

		it "create user without confirmation_password" do
			payload = {
				:core_user => {
					:email => 'kadriansyah@gmail.com',
					:username => 'kadriansyah',
					:password => 'password',
					:firstname => 'Kiagus Arief',
					:lastname => 'Adriansyah'
				}
			}.to_json
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			post '/admin/users', :params => payload, :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('404')
		end

		it "update user" do
			core_user = Admin::CoreUser.find_by(email: "kadriansyah@gmail.com")
			payload = {
				:core_user => {
					:id => "#{core_user.id}",
					:email => 'kadriansyah@gmail.com',
					:username => 'kadriansyah',
					:password => 'password',
					:confirmation_password => 'password',
					:firstname => 'Kiagus Arief Ade',
					:lastname => 'Adriansyah'
				}
			}.to_json
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			put "/admin/users/#{core_user.id}", :params => payload, :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('200')
		end

		it "edit user" do
			core_user = Admin::CoreUser.find_by(email: "kadriansyah@gmail.com")
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			get "/admin/users/#{core_user.id}/edit", :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('200')
			expect(json['payload']['email']).to eq('kadriansyah@gmail.com')
		end

		it "delete user" do
			core_user = Admin::CoreUser.find_by(email: "kadriansyah@gmail.com")
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			get "/admin/users/#{core_user.id}/delete", :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['status']).to eq('200')
		end

		it "list of users" do
			headers = {
				"CONTENT_TYPE" => "application/json",
				"HTTP_ACCEPT" => "application/json"
			}
			get '/admin/users', :headers => headers
			json = JSON.parse(response.body)

			expect(response).to have_http_status(200)
			expect(json['results'].length).to be > 0
		end
	end
end
