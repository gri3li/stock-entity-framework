FROM php:8.0.2-cli-alpine

RUN set -ex  && apk --no-cache add  postgresql-dev && docker-php-ext-install pdo pdo_pgsql
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
RUN apk add --no-cache $PHPIZE_DEPS && pecl install xdebug && docker-php-ext-enable xdebug \
    && echo "xdebug.mode = debug" >> "${PHP_INI_DIR}/conf.d/xdebug.ini" \
    && echo "xdebug.start_with_request = yes" >> "${PHP_INI_DIR}/conf.d/xdebug.ini" \
    && echo "xdebug.discover_client_host = yes" >> "${PHP_INI_DIR}/conf.d/xdebug.ini" \
    && echo "xdebug.client_host = host.docker.internal" >> "${PHP_INI_DIR}/conf.d/xdebug.ini"

# install symfony command
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

EXPOSE 8181

CMD php -d display_errors=0 -S 0.0.0.0:8181 -t public/
