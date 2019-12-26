## important!
## you must have nodejs installed (https://github.com/creationix/nvm)
## you must have yarn installed (https://yarnpkg.com/lang/en/docs/install/#mac-stable)

## rails app template (kadriansyah@gmail.com)
# rails new [app_name] --skip-active-record --skip-turbolinks -m rails-app-template/app-template.rb

## scaffolding
# rails g markazuna alo/tag --service_name tag_service --fields id name description

# template options: webmag, magnews, videomag
template_name = 'webmag'

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# _templates generator
directory '_templates'

# rvm environment related
copy_file '.ruby-gemset'
gsub_file '.ruby-gemset', /#appname/, "#{@app_name}"
copy_file '.ruby-version'

# circleci
directory '.circleci'

# travis config
copy_file '.travis.yml'

# empty log
directory 'log'

# docker
copy_file 'build.sh'
gsub_file 'build.sh', /#appname/, "#{@app_name}"
run 'chmod +x build.sh'

copy_file 'network.sh'

copy_file 'run.sh'
gsub_file 'run.sh', /#appname/, "#{@app_name}"
run 'chmod +x run.sh'

copy_file 'docker-compose.yml'
copy_file 'docker-entrypoint.sh'
copy_file 'Dockerfile'
copy_file 'rails_s.sh'
run 'chmod +x rails_s.sh'

copy_file 'reload.sh'
gsub_file 'reload.sh', /#appname/, "#{@app_name}"
run 'chmod +x reload.sh'

copy_file 'init_db.sh'
gsub_file 'init_db.sh', /#appname/, "#{@app_name}"
run 'chmod +x init_db.sh'

copy_file 'production_log.sh'
gsub_file 'production_log.sh', /#appname/, "#{@app_name}"
run 'chmod +x production_log.sh'

gsub_file 'docker-compose.yml', /#appname/, "#{@app_name}"
gsub_file 'Dockerfile', /#appname/, "#{@app_name}"

# nginx virtual host (be carefull with backslash on location, we need to escape it using double backslash)
add_file "#{@app_name}.com"
append_to_file "#{@app_name}.com", <<-EOF
server {
    # Permanent redirect to www
    server_name #{@app_name}.com;
    rewrite ^/(.*)$ https://www.#{@app_name}.com/$1 permanent;
}

server {
    listen 8080;
    server_name #{@app_name}.com;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/html/#{@app_name}.com/public;

    # Prevent (deny) Access to Hidden Files with Nginx
    location ~ /\\. {
        access_log off;
        log_not_found off; 
        deny all;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # set the expire date to max for assets
    location ~ "^/assets/(.*/)*.*-[0-9a-f]{32}.*" {
        gzip_static on;
        expires     max;
        add_header  Cache-Control public;
    }

    error_page  405     =200 $uri;

    location / {
        try_files /page_cache/$request_uri @passenger;
    }

    location @passenger {
        passenger_enabled on;
        passenger_user app;
        passenger_ruby /usr/local/bin/ruby;
        passenger_app_env production;
        passenger_min_instances 100;
    }
}

server {
    listen 8443;

    ssl     on;
    ssl_certificate     /etc/ssl/#{@app_name}.pem;
    ssl_certificate_key     /etc/ssl/#{@app_name}.key;

    server_name www.#{@app_name}.com;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/html/#{@app_name}.com/public;

    # Prevent (deny) Access to Hidden Files with Nginx
    location ~ /\. {
        access_log off;
        log_not_found off; 
        deny all;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # set the expire date to max for assets
    location ~ "^/assets/(.*/)*.*-[0-9a-f]{32}.*" {
        gzip_static on;
        expires     max;
        add_header  Cache-Control public;
    }

    error_page  405     =200 $uri;

    location / {
        try_files /page_cache/$request_uri @passenger;
    }

    location @passenger {
        passenger_enabled on;
        passenger_user app;
        passenger_ruby /usr/local/bin/ruby;
        passenger_app_env production;
        passenger_min_instances 100;
    }
}
EOF

# kubernetes
directory 'kube'

# Remove the gemfile so we can start with a clean slate otherwise Rails groups
# the gems in a very strange way
remove_file "Gemfile"
add_file "Gemfile"

# prepend_to_file "Gemfile" do
# "source \"https://rubygems.org\""
# end

append_to_file "Gemfile", <<-EOF
source "https://rubygems.org"

# gems
gem 'rails', '~> 6.0.1'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'sass-rails', '>= 6'
gem 'uglifier'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.7'
gem 'mongoid'
gem 'dry-container'
gem 'dry-auto_inject'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-rack-cache'
gem 'sidekiq'
gem 'devise'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'webpacker', '~> 4.0'
gem 'figaro' # put environment variable on application.yml
gem 'capistrano'
gem 'rails-controller-testing'
gem 'tzinfo-data'
gem 'execjs'
gem 'puma', '~> 4.1'

group :development do
    gem 'byebug', platform: :mri

    # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
    gem 'web-console'
    gem 'listen'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen'
end

group :development, :test do
    gem 'rspec'
    gem 'rspec-rails'
    gem 'factory_bot'
    gem 'factory_bot_rails'
end
EOF

# bundle
run 'bundle install'

# update bundler using newest version
run 'bundle update --bundler'

# webpacker
run 'rails webpacker:install'

# rspec
run 'rails generate rspec:install'
directory 'spec', 'spec'
insert_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do <<-RUBY
require 'support/factory_bot'
require 'devise'
    RUBY
end
insert_into_file 'spec/rails_helper.rb', after: "config.filter_rails_from_backtrace!\n" do <<-RUBY
	# devise
	config.include Devise::Test::IntegrationHelpers, type: :request
	RUBY
end

# whitelisted_ips on development & disable check_yarn_integrity
insert_into_file 'config/environments/development.rb', after: "config.file_watcher = ActiveSupport::EventedFileUpdateChecker\n" do <<-RUBY
    config.web_console.whitelisted_ips = '172.24.0.1' # change and add ips depends on your needs
    config.webpacker.check_yarn_integrity = false
    RUBY
end

# environment production, fallback to assets pipeline if a precompiled asset is missed.
gsub_file 'config/environments/production.rb', /config.assets.compile = false/, 'config.assets.compile = true'

# prevent Sass::SyntaxError: Invalid CSS
insert_into_file 'config/environments/production.rb', after: "# config.assets.css_compressor = :sass\n" do <<-RUBY
  config.assets.css_compressor = nil
  RUBY
end

# prevent Sass::SyntaxError: Invalid CSS when running tests using Rspec
insert_into_file 'config/environments/test.rb', before: "end\n" do <<-RUBY
  config.assets.css_compressor = nil
  RUBY
end

# copy db:seed
directory 'db', 'db'

# config/manifest.js
directory 'app/assets/config', 'app/assets/config'

# images
directory 'app/assets/images/admin', 'app/assets/images/admin'
directory "app/assets/images/#{template_name}/front", 'app/assets/images/front/'

# javascripts
copy_file 'app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
directory 'app/assets/javascripts/admin', 'app/assets/javascripts/admin'
directory "app/assets/javascripts/#{template_name}/front", 'app/assets/javascripts/front'

# stylesheets
copy_file 'app/assets/stylesheets/application.css', 'app/assets/stylesheets/application.css'
directory 'app/assets/stylesheets/admin', 'app/assets/stylesheets/admin'
directory "app/assets/stylesheets/#{template_name}/front", 'app/assets/stylesheets/front/'

# vendor
directory 'vendor/admin', 'vendor/admin'
directory "vendor/#{template_name}/fonts", 'vendor/fonts'
directory "vendor/#{template_name}/front", 'vendor/front'

# copy models, services, value_objects
directory 'app/models', 'app/models'
directory 'app/services', 'app/services'
directory 'app/value_objects', 'app/value_objects'

# copy views
directory 'app/views/admin', 'app/views/admin'
directory 'app/views/core', 'app/views/core'
directory 'app/views/layouts', 'app/views/layouts'
directory "app/views/#{template_name}/layouts", 'app/views/layouts'
directory "app/views/#{template_name}/shared", 'app/views/shared'
directory "app/views/#{template_name}/index", 'app/views/index'

# copy lib
directory 'lib', 'lib'

# https://yarnpkg.com/en/docs/install#mac-stable
run 'yarn add @webcomponents/webcomponentsjs'

# elements needed
run 'yarn add @babel/polyfill'
run 'yarn add @babel/runtime'
run 'yarn add @babel/plugin-transform-runtime'
run 'yarn add @babel/plugin-syntax-dynamic-import'
run 'yarn add @babel/plugin-transform-async-to-generator'
run 'yarn add @rails/actioncable'
run 'yarn add @rails/activestorage'
run 'yarn add @rails/ujs'
run 'yarn add @rails/webpacker'
run 'yarn add hygen'
run 'yarn add jquery'
run 'yarn add lit-element'
run 'yarn add purecss'
run 'yarn add tinymce@5.1.4'

# moving folder (somehow polymer, lit-element, lit-html can't work if in folder node_modules)
run 'mv node_modules/lit-element/ app/javascript/'
run 'mv node_modules/lit-html/ app/javascript/'
run 'cp node_modules/@webcomponents/webcomponentsjs/custom-elements-es5-adapter.js public/'

# prevent from check_yarn_integrity issue
run 'yarn install --check-files'

# polymer custom components
directory 'app/javascript/packs', 'app/javascript/packs'

application do <<-RUBY
    # autoload_paths
    config.autoload_paths += %W( lib/ )

    # Environment Variables
    config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
            ENV[key.to_s] = value
        end if File.exists?(env_file)
    end

    RUBY
end

# mongoid
remove_file 'config/database.yml'
copy_file 'config/mongoid.yml', 'config/mongoid.yml'
gsub_file 'config/mongoid.yml', /#dbname/, "#{@app_name}"
gsub_file 'config/mongoid.yml', /#hostname/, "mongo"

# devise
generate('devise:install')

# copy devise.rb
copy_file "config/application.yml", "config/application.yml"
directory "config/initializers", "config/initializers"
directory "config/#{template_name}/initializers", "config/initializers"

# prepare devise
generate('devise admin/core_user')
generate('devise:controllers admin/core_user')

# adding dependency
insert_into_file 'app/models/admin/core_user.rb', before: "class Admin::CoreUser\n" do <<-RUBY
    require 'markazuna/common_model'

    RUBY
end

# adding MoslemCorners::CommonModel & collection name
insert_into_file 'app/models/admin/core_user.rb', after: "include Mongoid::Document\n" do <<-RUBY
    include Markazuna::CommonModel
    store_in collection: 'core_users'

    # kaminari page setting
    paginates_per 25

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :firstname
    validates_presence_of :lastname

    RUBY
end

# adding fields to core_user
insert_into_file 'app/models/admin/core_user.rb', before: "end" do <<-RUBY

    # non devise field
    field :username, type: String, default: ''
    field :firstname, type: String, default: ''
    field :lastname, type: String, default: ''

    RUBY
end

# modify devise RegistrationsController
remove_file "app/controllers/admin/core_user/registrations_controller.rb"
add_file "app/controllers/admin/core_user/registrations_controller.rb"

# insert from beginning of file using \A, for end of file using \Z
insert_into_file "app/controllers/admin/core_user/registrations_controller.rb", after: /\A/ do <<-EOF
class Admin::CoreUser::RegistrationsController < Devise::RegistrationsController
    # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
    wrap_parameters :core_user, include: [:email, :username, :password, :confirmation_password, :firstname, :lastname]

    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    layout 'login'
    # respond_to :json

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
        super
        # TODO custom signup
        # build_resource(sign_up_params)
        # resource.save
        # yield resource if block_given?
        # if resource.persisted?
        #     respond_to do |format|
        #         format.json { render :json => {status: {code: "200", message: "Success"}} }
        #     end
        # else
        #     clean_up_passwords resource
        #     set_minimum_password_length
        #     respond_to do |format|
        #         format.json { render :json => {status: {code: "404", message: "Error"}} }
        #     end
        # end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    def update
        super
        # TODO custom update
        # respond_to do |format|
        #     format.json { render :json => {status: {code: "200", message: "Success"}} }
        # end
    end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #     devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # http://www.peoplecancode.com/tutorials/adding-custom-fields-to-devise
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :password, :firstname, :lastname])
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    def configure_account_update_params
        devise_parameter_sanitizer.permit(:account_update, keys: [:email, :username, :password, :firstname, :lastname])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
end
EOF
end

# modify devise SessionsController
remove_file "app/controllers/admin/core_user/sessions_controller.rb"
add_file "app/controllers/admin/core_user/sessions_controller.rb"

# insert from beginning of file using \A, for end of file using \Z
insert_into_file "app/controllers/admin/core_user/sessions_controller.rb", after: /\A/ do <<-EOF
class Admin::CoreUser::SessionsController < Devise::SessionsController
    layout 'login'
    # respond_to :json

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
end
EOF
end

# configure routing
insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-RUBY

    devise_for :core_user,
                class_name: 'Admin::CoreUser',
                module: :devise,
                path: 'admin',
                path_names: { sign_in: 'login', sign_out: 'logout' },
               :controllers => {
                   sessions: 'admin/core_user/sessions',
                   registrations: 'admin/core_user/registrations',
                   passwords: 'admin/core_user/passwords'
               }

    root to: 'index#index'
    scope :admin do
        root to: 'admin#index', :as => "admin"
        get 'page/:name', to: 'admin#page'
        get 'page/:name/:id', to: 'admin#page'

        # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
        resources :users, controller: 'admin/users', except: :destroy do
            get 'delete', on: :member
            get 'search', on: :collection
        end

        resources :groups, controller: 'admin/groups', except: :destroy do
            get 'delete', on: :member
            get 'search', on: :collection
        end

        resources :articles, controller: 'core/articles', except: :destroy do
            get 'delete', on: :member
            get 'search', on: :collection
        end
    end

    get 'tinymce',  to: 'core/articles#tinymce'
    resources :articles, param: :slug, controller: 'index', path: '/', only: :show
    RUBY
end

# remove default routing generated by devise
gsub_file 'config/routes.rb', /devise_for :core_users, class_name: "Admin::CoreUser"/, ''

# copy controllers
copy_file 'app/controllers/index_controller.rb', 'app/controllers/index_controller.rb'
copy_file 'app/controllers/admin_controller.rb', 'app/controllers/admin_controller.rb'
copy_file 'app/controllers/admin/users_controller.rb', 'app/controllers/admin/users_controller.rb'
copy_file 'app/controllers/admin/groups_controller.rb', 'app/controllers/admin/groups_controller.rb'
copy_file 'app/controllers/core/articles_controller.rb', 'app/controllers/core/articles_controller.rb'

# adding devise sign_in sign_out redirect path method
insert_into_file 'app/controllers/application_controller.rb', before: "end" do <<-RUBY
    include ActionController::MimeResponds
    before_action :authenticate_core_user!

    # Overwriting the sign_in redirect path method
    def after_sign_in_path_for(resource)
        Rails.application.routes.url_helpers.admin_path
    end

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
        Rails.application.routes.url_helpers.admin_path
    end
    RUBY
end

# kaminari config
generate('kaminari:config')

# capistrano
run 'bundle exec cap install'
gsub_file 'config/deploy.rb', /set :application.*$/, ""
gsub_file 'config/deploy.rb', /set :repo_url.*$/, ""
gsub_file 'config/deploy.rb', /#.*$/, ""
insert_into_file 'config/deploy.rb', after: /lock.*$/ do <<-EOF

set :application, '#{@app_name}'
set :rvm_ruby_version, '2.5.1@#{@app_name}'

set :repo_url, 'git@github.com:kadriansyah/#{@app_name}.git'
set :branch, 'master'

set :user,  '<ssh user>'
set :use_sudo,  false
set :ssh_options,   { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

# for staging, use development environment
if fetch(:stage) == 'staging'
  set :rails_env, :development
else
  set :rails_env, fetch(:stage)
end

set :deploy_to, "/var/www/html/\#{fetch(:application)}"

# how many old releases do we want to keep
set :keep_releases, 3

# # There is a known bug that prevents sidekiq from starting when pty is true on Capistrano 3.
# set :pty, false

# files we want symlinking to specific entries in shared
set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/mongoid.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Passenger
set :passenger_roles, :app
set :passenger_restart_runner, :sequence
set :passenger_restart_wait, 5
set :passenger_restart_limit, 2
set :passenger_restart_with_sudo, false
# set :passenger_environment_variables, {}
set :passenger_restart_command, 'passenger-config restart-app'
set :passenger_restart_options, -> { "\#{deploy_to} --ignore-app-not-running" }

# # Sidekiq
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
    EOF
end

# production.rb
insert_into_file 'config/deploy/production.rb', after: /# server "db.example.com".*$\n/ do <<-EOF

set :stage, :production
server '<ip address production>', port: '<ssh port for production>', user: '<ssh user for production>', roles: %w{app db web}, primary: true

    EOF
end

# staging.rb
insert_into_file 'config/deploy/staging.rb', after: /# server "db.example.com".*$\n/ do <<-EOF

set :stage, :staging
server '<ip address staging>', port: '<ssh port for staging>', user: '<ssh user for staging>', roles: %w{app db web}, primary: true

    EOF
end

# Registers a callback to be executed after bundle and spring binstubs have run.
after_bundle do
  # babel.config.js
	insert_into_file 'babel.config.js', after: "plugins: [\n" do <<-RUBY
		'@babel/plugin-transform-async-to-generator',
		RUBY
	end

	run 'rails assets:precompile'

  git :init
  run 'echo node_modules >> .gitignore'
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end