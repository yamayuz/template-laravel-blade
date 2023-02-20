ARG PHP_VERSION=8.1


FROM nginx:1.18.0-alpine AS nginx
RUN apk add --no-cache --update tzdata &&\
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata


FROM php:${PHP_VERSION}-fpm-alpine AS composer
RUN docker-php-ext-install pdo_mysql
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY /myapp/composer.json /myapp/composer.lock ./
COPY /myapp/vendor /var/www/myapp/vendor
COPY /myapp/bootstrap/cache /var/www/myapp/bootstrap/cache


FROM php:${PHP_VERSION}-fpm-alpine AS myapp
EXPOSE 5173
WORKDIR /var/www/myapp
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /var/www/myapp/vendor ./vendor
COPY --from=composer /var/www/myapp/bootstrap/cache ./bootstrap/cache
COPY docker/php/php.ini /usr/local/etc/php/
RUN apk add --no-cache libstdc++ && apk add --no-cache libgcc
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
    curl \
    zip \
    unzip \
    libjpeg-turbo-dev \
    freetype-dev \
    zlib \
    libwebp-dev \
    libpng-dev \
    libjpeg \
    nodejs \
    npm
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure gd --enable-gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd
