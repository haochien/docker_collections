FROM nginx:stable-alpine
 
WORKDIR /etc/nginx/conf.d
 
COPY nginx/nginx.conf .

# rename nginx.conf to the name (efault.conf) required by nginx 
RUN mv nginx.conf default.conf

WORKDIR /var/www/html
 
COPY src .


