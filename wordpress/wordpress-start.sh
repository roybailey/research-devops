#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting WORDPRESS..."
cd wordpress
docker run -e WORDPRESS_DB_PASSWORD=localhost -d \
  --name wordpress --link wordpress-mysql:mysql \
  -p 127.0.0.1:8080:80 \
  -v "$PWD/":/var/www/html \
  wordpress:latest
