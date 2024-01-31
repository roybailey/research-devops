# NGINX

**Notes from setting up NGINX on home server**

## Getting started

1. `brew install nginx` install
2. `brew services start nginx` start and start on login
3. `brew services stop nginx` stop server and remove from login
4. `nginx -s stop` stop the service
5. `nginx -t` get the config path e.g. `/usr/local/etc/nginx/nginx.conf`
6. `brew services restart nginx` restart the service

IP Address
```text
89.242.5.222
```

## Installing certificates

* See [LetsEncrypt](https://letsencrypt.org/getting-started/)
* See [certbot for nginx on MacOS](https://certbot.eff.org/instructions?ws=nginx&os=osx)

* Install `brew install certbot`
* Create file `echo hi > /var/www/letsencrypt/.well-known/acme-challenge/hi`
* Config nginx
```yaml
location ^~ /.well-known/acme-challenge/ {
  default_type "text/plain";
  rewrite /.well-known/acme-challenge/(.*) /$1 break;
  root /var/www/letsencrypt;
}
```
