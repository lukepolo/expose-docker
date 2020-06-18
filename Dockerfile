FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer global require beyondcode/expose
RUN php ~/.composer/vendor/bin/expose publish

ARG username=username
ARG password=password

RUN sed -i "s|username|${username}|g" /root/.expose/config.php
RUN sed -i "s|password|${password}|g" /root/.expose/config.php

ENV port=8080
ENV domain=localhost

RUN echo $HOME

CMD php ~/.composer/vendor/bin/expose serve ${domain} --port ${port} --validateAuthTokens
