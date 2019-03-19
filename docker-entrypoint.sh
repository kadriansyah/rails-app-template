#!/bin/bash
set -e
mongo --host #hostname #appname --eval 'db.createUser({user:"admin",pwd:"password",roles:["readWrite"]});'
RAILS_ENV='production' bundle exec rails db:seed
RAILS_ENV='production' bundle exec rails assets:precompile
chown -R app:app /var/www/html/#appname.com/public
chown -R app:app /var/www/html/#appname.com/tmp
chown -R app:app /var/www/html/#appname.com/log
exec "$@"