#!/bin/bash
docker run -d --name app -v "$PWD":/var/www/html/#appname.com --link mongo -p 80:8080 -p 443:8443 -p 3000:3000 kadriansyah/#appname