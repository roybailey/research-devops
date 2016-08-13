#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting DB..."
docker run --name wordpress-mysql -d \
  -e MYSQL_ROOT_PASSWORD=localhost \
  -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=localhost \
  -p 3306:3306 \
  mysql:latest

# Wait for the database service to start up.
echo "Waiting for DB to start up..."
docker exec wordpress-mysql mysqladmin --silent --wait=30 -uroot -plocalhost ping || exit 1

sleep 5

# Run the setup script.
echo "Setting up initial data..."
docker exec -i wordpress-mysql mysql -uwordpress -plocalhost wordpress < mysql-setup.sql
