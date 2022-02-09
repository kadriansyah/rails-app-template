FROM  kadriansyah/phusion-passenger
LABEL version="1.0"
LABEL maintainer="Kiagus Arief Adriansyah <kadriansyah@gmail.com>"

COPY #appname.pem /etc/ssl/
COPY #appname.key /etc/ssl/

RUN rm /etc/nginx/sites-enabled/default
COPY #appname.com /etc/nginx/sites-available/#appname.com
RUN ln -s /etc/nginx/sites-available/#appname.com /etc/nginx/sites-enabled/#appname.com

RUN set -ex \
    && mkdir /home/app/#appname.com \
    && chown -R app:app /home/app/#appname.com
WORKDIR /home/app/#appname.com
COPY --chown=app:app . .
RUN chmod +x reload.sh
RUN chmod +x rails_s.sh

# https://github.com/phusion/passenger-docker#selecting_default_ruby
RUN bash -lc 'rvm use 3.0.3@#appname --create --default'
RUN rvm-exec 3.0.3 gem install rails -v 6.1.4.4
RUN rvm-exec 3.0.3 bundle install --jobs 10

RUN set -ex \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn

# make sure we make log and tmp owned by app
RUN set -ex \
    && rm -rf log \
    && mkdir log \
    && rm -rf tmp \
    && mkdir tmp
RUN rvm-exec 3.0.3 rails assets:clobber
RUN rvm-exec 3.0.3 rails assets:precompile
RUN set -ex \
    && chown -R app:app /home/app/#appname.com/public \
    && chown -R app:app tmp \
    && chown -R app:app log;

# You cannot open privileged ports (<=1024) as non-root
EXPOSE 8080 8443 3000
CMD ["/sbin/my_init"]