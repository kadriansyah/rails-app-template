# image name: kadriansyah/markazuna_app:v1
FROM  kadriansyah/ubuntu_16_04_nginx:v1
LABEL version="1.0"
LABEL maintainer="Kiagus Arief Adriansyah <kadriansyah@gmail.com>"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r app && useradd -r -m app -g app

RUN mkdir /var/www/html/markazuna.com
RUN chown -R app:app /var/www/html/markazuna.com
WORKDIR /var/www/html/markazuna.com
COPY --chown=app:app . .
RUN chmod +x reload.sh
RUN chmod +x docker-entrypoint.sh

ENV RAILS_ENV='production'
RUN set -ex \
        \
        && bundle config build.nokogiri --use-system-libraries \
        && gem install pkg-config -v "~> 1.1" \
        && bundle install --jobs 20 --retry 5 \
        && yarn install --check-files

COPY markazuna.com /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/markazuna.com /etc/nginx/sites-enabled/markazuna.com

EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]