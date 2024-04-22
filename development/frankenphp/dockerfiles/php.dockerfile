FROM php:8.3-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Install packages

# Setup mirror repositories (https://mirrors.alpinelinux.org/)
# Alpine version of this image is v3.19
RUN apk --no-cache \
#    -X https://ftp.udx.icscoe.jp/Linux/alpine/v3.19/main -X https://ftp.udx.icscoe.jp/Linux/alpine/v3.19/community \
    -X https://mirror.jingk.ai/alpine/v3.19/main -X https://mirror.jingk.ai/alpine/v3.19/community \
    add icu-dev postgresql-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install -j$(nproc) gd

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

USER laravel

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
