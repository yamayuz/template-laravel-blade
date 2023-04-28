ARG PHP_VERSION=8.1


FROM nginx:1.18.0-alpine AS nginx
RUN apk add --no-cache --update tzdata &&\
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata


FROM php:${PHP_VERSION}-fpm-alpine AS composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY /myapp/composer.json /myapp/composer.lock ./
RUN composer install --no-scripts --no-autoloader --dev
COPY ./myapp/ .
RUN composer dump-autoload --optimize


FROM php:${PHP_VERSION}-fpm-alpine AS myapp
EXPOSE 5173
WORKDIR /var/www/myapp
RUN apk add --no-cache libstdc++ && \
    apk add --no-cache libgcc && \
    apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
    curl zip unzip libjpeg-turbo-dev freetype-dev zlib \
    libwebp-dev libpng-dev libjpeg nodejs npm
COPY docker/php/php.ini /usr/local/etc/php/
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure gd --enable-gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /var/www/html/vendor ./vendor
COPY --from=composer /var/www/html/bootstrap/cache ./bootstrap/cache
