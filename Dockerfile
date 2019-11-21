# image name: kadriansyah/nginx
FROM  kadriansyah/nginx
LABEL version="1.0"
LABEL maintainer="Kiagus Arief Adriansyah <kadriansyah@gmail.com>"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r app && useradd -r -m app -g app

RUN mkdir /var/www/html/#appname.com
RUN chown -R app:app /var/www/html/#appname.com
WORKDIR /var/www/html/#appname.com
COPY --chown=app:app . .
RUN chmod +x reload.sh

ENV RAILS_ENV='production'
RUN set -ex \
        \
        && bundle config build.nokogiri --use-system-libraries \
        && gem install pkg-config -v "~> 1.1" \
        && bundle install --jobs 20 --retry 5 \
        && yarn install --check-files \
        && bundle exec rails assets:precompile \
        && chown -R app:app /var/www/html/#appname.com/public \
        && chown -R app:app /var/www/html/#appname.com/tmp \
        && chown -R app:app /var/www/html/#appname.com/log

COPY #appname.com /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/#appname.com /etc/nginx/sites-enabled/#appname.com

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/www/html/#appname.com/log/production.log

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]