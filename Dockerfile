FROM php:7.3-fpm

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libz-dev \
        less \
        git \
        mysql-client \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libzip-dev \
        libxml2-dev \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        sockets \
        zip \
        gd \
        mysqli \
        dom \ 
        bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug-2.7.0beta1 \
    && pecl install memcached \
    && pecl install opcache \
    && docker-php-ext-enable xdebug memcached \
    && apt-get remove -y build-essential libz-dev libmemcached-dev \
    && apt-get autoremove -y \
    && apt-get clean

RUN curl https://getcomposer.org/download/$(curl -LSs https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | sed -e 's/.*: "//;s/".*//')/composer.phar > composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer
   
EXPOSE 9000

CMD ["php-fpm"]
