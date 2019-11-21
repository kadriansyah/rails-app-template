# Markazuna Rails Application Template

Application Template for Rails Application

## Getting Started

TODO

### Prerequisites

* you must have rvm installed https://rvm.io/
* you must have nodejs installed (https://github.com/creationix/nvm)
* you must have yarn installed (https://yarnpkg.com/lang/en/docs/install/#mac-stable)

### Installing

* Install Ruby using RVM

```
https://rvm.io/rvm/install
```

* Creating gemset for the project

```
https://rvm.io/rvm/install
```

* Use gemset

```
https://rvm.io/gemsets/using
```

* Cloning the project

```
git clone git@github.com:kadriansyah/rails-app-template.git
```

* Creating project

```
rvm use 2.5.1@[app_name] --create
gem install rails --no-document

rails new [app_name] --skip-active-record --skip-turbolinks -m rails-app-template/app-template.rb

create database [app_name] on MongoDB
docker exec -it app /bin/bash
./init_db.sh
```

define template_name for front end inside app-template.rb, options are webmag, magnews, videomag

* Scaffolding

```
rails g markazuna alo/tag --service_name tag_service --fields id name description
```
* Running Container

```
docker-compose up -d
```

* Stoping and Removing Container

```
docker-compose down
```

* Starting Container

```
docker-compose start
```

* Stoping Container

```
docker-compose stop
```

* Seeding Database for first time

```
docker exec -it app /bin/bash
RAILS_ENV='production' rails db:seed
```

* Restart Passenger on Docker Container

```
docker exec -it app /bin/bash
passenger-config restart-app
```

* Compile WebPacker

```
docker exec -it app /bin/bash
rails webpacker:compile
```

* Running Development

```
docker exec -it app /bin/bash
RAILS_ENV='development' rails s -b 0.0.0.0

add IPs to be whitelisted on config/environments/development.rb
config.web_console.whitelisted_ips = '172.24.0.1'
```
## Authors

* **Kiagus Arief Adriansyah** - *Initial work* - [kadriansyah](https://github.com/kadriansyah)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc