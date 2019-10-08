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
rvm gemset create [project name]
gem install bundler
gem install rails --no-document
```

```
rvm gemset use [project name]
```

```
rails new [app_name] --skip-active-record --skip-turbolinks -m rails-app-template/app-template.rb
```

```
rails db/seeds.rb 
```

define template_name for front end inside app-template.rb, options are webmag, magnews, videomag

* Scaffolding

```
rails g markazuna alo/tag --service_name tag_service --fields id name description
```

## Authors

* **Kiagus Arief Adriansyah** - *Initial work* - [kadriansyah](https://github.com/kadriansyah)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* alodokter team
* etc
