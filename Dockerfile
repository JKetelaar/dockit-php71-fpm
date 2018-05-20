FROM phpdockerio/php71-fpm:latest

MAINTAINER Jeroen Ketelaar version: 0.1

WORKDIR "/application"

ARG DEBIAN_FRONTEND=noninteractive

ENV LOCALE en_US.UTF-8

ENV TZ=Europe/Amsterdam

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

RUN \
    sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen \
    && echo "LANG=$LOCALE">/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=$LOCALE

RUN \
    apt-get -yqq install \
    apt-utils \
    build-essential \
    debconf-utils \
    debconf \
    mysql-client \
    curl \
    software-properties-common \
    python-software-properties

RUN \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update

RUN \
    apt-get -yqq install \
    php7.1 \
    php7.1-curl \
    php7.1-bcmath \
    php7.1-bz2 \
    php7.1-dev \
    php7.1-gd \
    php7.1-dom \
    php7.1-imap \
    php7.1-imagick \
    php7.1-intl \
    php7.1-json \
    php7.1-ldap \
    php7.1-mbstring	\
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-oauth \
    php7.1-odbc \
    php7.1-uploadprogress \
    php7.1-ssh2 \
    php7.1-xml \
    php7.1-zip \
    php7.1-solr \
    php7.1-apcu \
    php7.1-opcache \
    php7.1-memcache \
    php7.1-memcached \
    php7.1-redis \
    php7.1-xdebug

RUN \
    echo $TZ | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.1/fpm/conf.d/timezone.ini && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.1/cli/conf.d/timezone.ini

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN \
    curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

ENV PATH /usr/local/go/bin:$PATH

RUN \
    go get github.com/mailhog/mhsendmail

RUN \
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
