FROM php:8.1-fpm-alpine
 
WORKDIR /var/www/html
 
COPY src .
 
RUN docker-php-ext-install pdo pdo_mysql
 
# # the original php image restricts the read and write access by the container (thus later laravel cannot create certain files into /var/www/html)
# # no problem when we work together with bind mount
# # but has problem when just work inside the container
# # thus need to give certain folder a proper write access
# RUN chown -R www-data:www-data /var/www/html

# # When using Docker on Linux, you might face permission errors 
# # note that the RUN chown instruction was removed here, instead we now create a user "laravel" 
# # which we use (with the USER instruction) for commands executed inside of this image / container).
# # You also need to edit the composer.dockerfile with such user:

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN chown -R laravel:laravel /var/www/html

USER laravel 
