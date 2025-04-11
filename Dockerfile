# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libpq-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www

# Copy Laravel app
COPY . .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the proper web root for Apache
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/public|g' /etc/apache2/sites-available/000-default.conf

# Install dependencies
RUN composer install --optimize-autoloader --no-dev

# Set permissions (important for Laravel)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose Apache port
EXPOSE 80
