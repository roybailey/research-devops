#!/bin/bash
echo Running CERT build script

echo ----------------------------------------------------------------------
echo CERTBOT
echo ----------------------------------------------------------------------
certbot certonly \
            --non-interactive \
            -m roybaileybiz@gmail.com \
            --config-dir /Users/roybailey/Coding/www/letsencrypt/ \
            --work-dir /Users/roybailey/Coding/www/letsencrypt/ \
            --logs-dir /Users/roybailey/Coding/www/letsencrypt/ \
            --webroot --webroot-path /Users/roybailey/Coding/www/letsencrypt/ \
            -d roybailey.biz,odinium.com

echo ----------------------------------------------------------------------
echo LOGS /var/log/letsencrypt/letsencrypt.log
echo ----------------------------------------------------------------------
cat /Users/roybailey/Coding/www/letsencrypt/letsencrypt.log
