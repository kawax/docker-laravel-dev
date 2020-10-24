FROM php:7.4-fpm

# php
RUN apt-get update \
    && apt-get install -yq libzip-dev zlib1g-dev libgmp-dev unzip \
    && docker-php-ext-configure zip

# Horizonにpcntl。WebPush関連でgmpが必要。
RUN docker-php-ext-install zip pdo_mysql bcmath pcntl gmp

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer self-update --2


# supervisor
RUN apt-get install -yq --fix-missing supervisor

COPY supervisor/supervisord.conf /etc/supervisor/
COPY supervisor/conf/ /etc/supervisor/conf.d/


# cron
RUN apt-get install -yq --fix-missing cron
COPY scheduler/root /var/spool/cron/crontabs/
RUN chmod 0600 /var/spool/cron/crontabs/root


# aws cli
#RUN apt-get install -yq --fix-missing python \
#    && curl "https://bootstrap.pypa.io/get-pip.py"| python \
#    && pip install awscli


# clean
RUN apt-get -yq upgrade
RUN apt-get -yq autoremove
RUN apt-get -yq clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /var/www
