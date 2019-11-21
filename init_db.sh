#!/bin/bash
set -e
mongo --host mongo #appname --eval 'db.createUser({user:"admin",pwd:"password",roles:["readWrite"]});'
RAILS_ENV='production' bundle exec rails db:seed