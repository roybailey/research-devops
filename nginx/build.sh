#!/bin/bash
echo Running NGINX build script

cp /usr/local/etc/nginx/nginx.conf ./nginx.conf.bak
cp nginx.conf /usr/local/etc/nginx/nginx.conf

brew services restart nginx
