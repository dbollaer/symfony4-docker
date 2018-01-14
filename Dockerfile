FROM php:7.1-fpm
MAINTAINER Adil YASSINE <adilyassine.info>

RUN apt-get update && apt-get install --force-yes -y \
    openssl \
    git \
    unzip \
    nodejs \
    openjdk-7-jdk \
    ant \
    devscripts \
    build-essential \
    lintian \
    ruby \
    ruby-dev \
    rubygems \
    gcc \ 
    make

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version
# Install fpm
RUN gem install --no-ri --no-rdoc fpm

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"


RUN apt-get update && apt-get install -y  zlib1g-dev libicu-dev libpq-dev imagemagick git mysql-client\
	&& docker-php-ext-install opcache \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install pdo_mysql \
	&& php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
	&& chmod +sx /usr/local/bin/composer
EXPOSE 9000
