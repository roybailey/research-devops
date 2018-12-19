#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting WORDPRESS..."

docker run -e WORDPRESS_DB_PASSWORD=localhost \
  --name wordpress --link wordpress-mysql:mysql \
  -p 8080:80 \
  -v "$PWD/themes":/var/www/html/wp-content/themes \
  wordpress:latest
