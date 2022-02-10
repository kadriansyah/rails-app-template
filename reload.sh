#!/bin/bash
set -e
rvm-exec 3.0.3 bundle exec passenger-config restart-app /home/app/html/#appname.com