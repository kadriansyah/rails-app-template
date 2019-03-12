## important!
## you must have nodejs installed (https://github.com/creationix/nvm)
## you must have yarn installed (https://yarnpkg.com/lang/en/docs/install/#mac-stable)

## rails app template (kadriansyah@gmail.com)
# rails new [app_name] --skip-active-record --skip-turbolinks -m rails-app-template/app-template.rb

## scaffolding
# rails g markazuna alo/tag --service_name tag_service --fields id name description

# template options: webmag, magnews, videomag
template_name = 'videomag'

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# rvm environment related
copy_file '.ruby-gemset'
gsub_file '.ruby-gemset', /app-template/, "#{@app_name}"
copy_file '.ruby-version'

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
gem 'rails'
gem 'bootsnap'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jbuilder'
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
gem 'webpacker', '~> 3.5'
gem 'figaro' # put environment variable on application.yml
gem 'capistrano'
gem 'rails-controller-testing'

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

run 'bundle install'

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

# prevent Sass::SyntaxError: Invalid CSS when running tests using Rspec
insert_into_file 'config/environments/test.rb', before: "end\n" do <<-RUBY
  config.assets.css_compressor = nil
  RUBY
end

# webpacker
run 'rails webpacker:install'

# copy db:seed
directory 'db', 'db'

# copy assets, services & value_objects, vendor
# images
directory 'app/assets/images/admin', 'app/assets/images/admin'
directory "app/assets/images/#{template_name}/front", 'app/assets/images/front/'

# javascripts
copy_file 'app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
directory 'app/assets/javascripts/admin', 'app/assets/javascripts/admin'
directory 'app/assets/javascripts/channels', 'app/assets/javascripts/channels'
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

# polymer elements needed
run 'yarn add @polymer/polymer'
run 'yarn add @polymer/app-layout'
run 'yarn add @polymer/paper-item'
run 'yarn add @polymer/paper-icon-button'
run 'yarn add @polymer/paper-input'
run 'yarn add @polymer/iron-input'
run 'yarn add @polymer/iron-location'
run 'yarn add @polymer/iron-icons'
run 'yarn add @polymer/iron-ajax'
run 'yarn add @polymer/iron-list'
run 'yarn add @polymer/iron-scroll-threshold'
run 'yarn add @polymer/paper-dialog'
run 'yarn add @polymer/paper-button'
run 'yarn add @polymer/paper-fab'
run 'yarn add @polymer/paper-card'
run 'yarn add @polymer/paper-progress'
run 'yarn add @vaadin/vaadin-grid'
run 'yarn add @polymer/iron-flex-layout'
run 'yarn add purecss'
run 'yarn add tinymce@4.8.5' # please explore version 5.0

# moving folder (somehow polymer can't work if in folder node_modules)
run 'mv node_modules/@polymer/ app/javascript/'
run 'cp node_modules/@webcomponents/webcomponentsjs/custom-elements-es5-adapter.js public/'

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

# # mongoid
inside 'config' do
    remove_file 'database.yml'
    create_file 'mongoid.yml' do <<-EOF
development:
  # Configure available database clients. (required)
  clients:
    # Defines the default client. (required)
    default:
      # Defines the name of the default database that Mongoid can connect to.
      # (required).
      database: #{@app_name}
      # Provides the hosts the default client can connect to. Must be an array
      # of host:port pairs. (required)
      hosts:
        - localhost:27017
      options:
        # Change the default write concern. (default = { w: 1 })
        # write:
        #   w: 1

        # Change the default read preference. Valid options for mode are: :secondary,
        # :secondary_preferred, :primary, :primary_preferred, :nearest
        # (default: primary)
        # read:
        #   mode: :secondary_preferred
        #   tag_sets:
        #     - use: web

        # The name of the user for authentication.
        user: 'admin'

        # The password of the user for authentication.
        password: 'password'

        # The user's database roles.
        # roles:
        #   - 'dbOwner'

        # Change the default authentication mechanism. Valid options are: :scram,
        # :mongodb_cr, :mongodb_x509, and :plain. (default on 3.0 is :scram, default
        # on 2.4 and 2.6 is :plain)
        # auth_mech: :scram

        # The database or source to authenticate the user against.
        # (default: the database specified above or admin)
        # auth_source: admin

        # Force a the driver cluster to behave in a certain manner instead of auto-
        # discovering. Can be one of: :direct, :replica_set, :sharded. Set to :direct
        # when connecting to hidden members of a replica set.
        # connect: :direct

        # Changes the default time in seconds the server monitors refresh their status
        # via ismaster commands. (default: 10)
        # heartbeat_frequency: 10

        # The time in seconds for selecting servers for a near read preference. (default: 5)
        # local_threshold: 5

        # The timeout in seconds for selecting a server for an operation. (default: 30)
        # server_selection_timeout: 30

        # The maximum number of connections in the connection pool. (default: 5)
        # max_pool_size: 5

        # The minimum number of connections in the connection pool. (default: 1)
        # min_pool_size: 1

        # The time to wait, in seconds, in the connection pool for a connection
        # to be checked in before timing out. (default: 5)
        # wait_queue_timeout: 5

        # The time to wait to establish a connection before timing out, in seconds.
        # (default: 5)
        # connect_timeout: 5

        # The timeout to wait to execute operations on a socket before raising an error.
        # (default: 5)
        # socket_timeout: 5

        # The name of the replica set to connect to. Servers provided as seeds that do
        # not belong to this replica set will be ignored.
        # replica_set: name

        # Whether to connect to the servers via ssl. (default: false)
        # ssl: true

        # The certificate file used to identify the connection against MongoDB.
        # ssl_cert: /path/to/my.cert

        # The private keyfile used to identify the connection against MongoDB.
        # Note that even if the key is stored in the same file as the certificate,
        # both need to be explicitly specified.
        # ssl_key: /path/to/my.key

        # A passphrase for the private key.
        # ssl_key_pass_phrase: password

        # Whether or not to do peer certification validation. (default: true)
        # ssl_verify: true

        # The file containing a set of concatenated certification authority certifications
        # used to validate certs passed from the other end of the connection.
        # ssl_ca_cert: /path/to/ca.cert

  # Configure Mongoid specific options. (optional)
  options:
    # Includes the root model name in json serialization. (default: false)
    # include_root_in_json: false

    # Include the _type field in serialization. (default: false)
    # include_type_for_serialization: false

    # Preload all models in development, needed when models use
    # inheritance. (default: false)
    # preload_models: false

    # Raise an error when performing a #find and the document is not found.
    # (default: true)
    raise_not_found_error: false

    # Raise an error when defining a scope with the same name as an
    # existing method. (default: false)
    # scope_overwrite_exception: false

    # Use Active Support's time zone in conversions. (default: true)
    # use_activesupport_time_zone: true

    # Ensure all times are UTC in the app side. (default: false)
    # use_utc: false

    # Set the Mongoid and Ruby driver log levels when not in a Rails
    # environment. The Mongoid logger will be set to the Rails logger
    # otherwise.(default: :info)
    # log_level: :info

test:
    # Configure available database clients. (required)
    clients:
      # Defines the default client. (required)
      default:
        # Defines the name of the default database that Mongoid can connect to.
        # (required).
        database: #{@app_name}
        # Provides the hosts the default client can connect to. Must be an array
        # of host:port pairs. (required)
        hosts:
          - localhost:27017
        options:
          # Change the default write concern. (default = { w: 1 })
          # write:
          #   w: 1
  
          # Change the default read preference. Valid options for mode are: :secondary,
          # :secondary_preferred, :primary, :primary_preferred, :nearest
          # (default: primary)
          # read:
          #   mode: :secondary_preferred
          #   tag_sets:
          #     - use: web
  
          # The name of the user for authentication.
          user: 'admin'
  
          # The password of the user for authentication.
          password: 'password'
  
          # The user's database roles.
          # roles:
          #   - 'dbOwner'
  
          # Change the default authentication mechanism. Valid options are: :scram,
          # :mongodb_cr, :mongodb_x509, and :plain. (default on 3.0 is :scram, default
          # on 2.4 and 2.6 is :plain)
          # auth_mech: :scram
  
          # The database or source to authenticate the user against.
          # (default: the database specified above or admin)
          # auth_source: admin
  
          # Force a the driver cluster to behave in a certain manner instead of auto-
          # discovering. Can be one of: :direct, :replica_set, :sharded. Set to :direct
          # when connecting to hidden members of a replica set.
          # connect: :direct
  
          # Changes the default time in seconds the server monitors refresh their status
          # via ismaster commands. (default: 10)
          # heartbeat_frequency: 10
  
          # The time in seconds for selecting servers for a near read preference. (default: 5)
          # local_threshold: 5
  
          # The timeout in seconds for selecting a server for an operation. (default: 30)
          # server_selection_timeout: 30
  
          # The maximum number of connections in the connection pool. (default: 5)
          # max_pool_size: 5
  
          # The minimum number of connections in the connection pool. (default: 1)
          # min_pool_size: 1
  
          # The time to wait, in seconds, in the connection pool for a connection
          # to be checked in before timing out. (default: 5)
          # wait_queue_timeout: 5
  
          # The time to wait to establish a connection before timing out, in seconds.
          # (default: 5)
          # connect_timeout: 5
  
          # The timeout to wait to execute operations on a socket before raising an error.
          # (default: 5)
          # socket_timeout: 5
  
          # The name of the replica set to connect to. Servers provided as seeds that do
          # not belong to this replica set will be ignored.
          # replica_set: name
  
          # Whether to connect to the servers via ssl. (default: false)
          # ssl: true
  
          # The certificate file used to identify the connection against MongoDB.
          # ssl_cert: /path/to/my.cert
  
          # The private keyfile used to identify the connection against MongoDB.
          # Note that even if the key is stored in the same file as the certificate,
          # both need to be explicitly specified.
          # ssl_key: /path/to/my.key
  
          # A passphrase for the private key.
          # ssl_key_pass_phrase: password
  
          # Whether or not to do peer certification validation. (default: true)
          # ssl_verify: true
  
          # The file containing a set of concatenated certification authority certifications
          # used to validate certs passed from the other end of the connection.
          # ssl_ca_cert: /path/to/ca.cert
  
    # Configure Mongoid specific options. (optional)
    options:
      # Includes the root model name in json serialization. (default: false)
      # include_root_in_json: false
  
      # Include the _type field in serialization. (default: false)
      # include_type_for_serialization: false
  
      # Preload all models in development, needed when models use
      # inheritance. (default: false)
      # preload_models: false
  
      # Raise an error when performing a #find and the document is not found.
      # (default: true)
      raise_not_found_error: false
  
      # Raise an error when defining a scope with the same name as an
      # existing method. (default: false)
      # scope_overwrite_exception: false
  
      # Use Active Support's time zone in conversions. (default: true)
      # use_activesupport_time_zone: true
  
      # Ensure all times are UTC in the app side. (default: false)
      # use_utc: false
  
      # Set the Mongoid and Ruby driver log levels when not in a Rails
      # environment. The Mongoid logger will be set to the Rails logger
      # otherwise.(default: :info)
      # log_level: :info

        EOF
    end
end

#
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

        # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
        resources :users, controller: 'admin/users', except: :destroy do
            get 'delete', on: :member
        end

        resources :groups, controller: 'admin/groups', except: :destroy do
            get 'delete', on: :member
        end

        resources :articles, controller: 'core/articles', except: :destroy do
            get 'delete', on: :member
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

insert_into_file 'package.json', before: /"devDependencies": {/ do <<-EOF
"scripts": {
    "postinstall": "rsync -av node_modules/@polymer app/javascript/; rm -rf node_modules/@polymer"
  },
  EOF
end

after_bundle do
  git :init
  run 'echo node_modules >> .gitignore'
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

# optional: run this if you already created database
run 'rails db:seed'