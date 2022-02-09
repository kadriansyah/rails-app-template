#!/bin/bash
set -e
mongosh --host mongo markazuna --eval 'db.createUser({user:"admin",pwd:"mutia.1975@2019",roles:["readWrite"],mechanisms:["SCRAM-SHA-1"]});'
rvm-exec 3.0.3 bundle exec rails db:seed