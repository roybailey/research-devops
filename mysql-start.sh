#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting DB..."
docker run --name mysql -d \
  -e MYSQL_ROOT_PASSWORD=localhost \
  -e MYSQL_DATABASE=users -e MYSQL_USER=users_service -e MYSQL_PASSWORD=localhost \
  -p 3306:3306 \
  mysql:latest

# Wait for the database service to start up.
echo "Waiting for DB to start up..."
docker exec db mysqladmin --silent --wait=30 -uusers_service -plocalhost ping || exit 1

# Run the setup script.
echo "Setting up initial data..."
docker exec -i db mysql -uusers_service -plocalhost users < mysql-setup.sql
