# NGINX

**Notes from setting up NGINX on home server**

## Getting started

1. `brew install nginx` install
2. `brew services start nginx` start and start on login
2. `brew services stop nginx` stop server and remove from login
3. `nginx -s stop` stop the service
4. `nginx -t` get the config path e.g. `/usr/local/etc/nginx/nginx.conf`
5. `brew services restart nginx` restart the service