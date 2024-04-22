FROM dunglas/frankenphp:latest-php8.3.4-alpine

ARG UID=1000
ARG GID=1000
ARG USER=php

ENV UID=${UID}
ENV GID=${GID}

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout
RUN addgroup -g ${GID} --system ${USER}
RUN adduser -G ${USER} --system -D -s /bin/sh -u ${UID} ${USER}
RUN \
	# Give write access to /data/caddy and /config/caddy
	chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy; \
	# Add additional capability to bind to port 80 and 443
	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp;

# Install packages

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Node & NPM
RUN apk add --no-cache nodejs npm; \
	npm install -g npm@latest

# Extension
RUN install-php-extensions pdo_mysql gd intl imap bcmath redis curl exif hash iconv \
    json mbstring mysqli mysqlnd pcntl pcre xml libxml zlib zip

# Redis
# RUN mkdir -p /usr/src/php/ext/redis \
#     && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
#     && echo 'redis' >> /usr/src/php-available-exts \
#     && docker-php-ext-install redis

# Supervisor
RUN apk add --no-cache supervisor; \
	mkdir -p /etc/supervisor/conf.d; \
	mkdir -p /var/log/supervisor; \
	touch /var/log/supervisor/supervisord.log; \
	chown ${USER}:${USER} /var/log/supervisor/supervisord.log;

EXPOSE 8000

# USER ${USER}
