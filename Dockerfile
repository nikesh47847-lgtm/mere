# PHP-FPM base image
FROM php:8.2-fpm-alpine

# Install system dependencies (FIX: ca-certificates added)
RUN apk add --no-cache \
    nginx \
    curl-dev \
    ca-certificates \
    libzip-dev \
    oniguruma-dev \
    libxml2-dev \
    supervisor

# Update CA certificates (IMPORTANT for SSL)
RUN update-ca-certificates

# Install PHP extensions
RUN docker-php-ext-install curl

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy Supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port (Railway public port)
EXPOSE 8080

# Start Nginx + PHP-FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
