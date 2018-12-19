#!/bin/sh

read -p "Press any key to Run the MySQL container... " -n1 -s

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting MYSQL..."
docker run --name wordpress-mysql -d \
  -e MYSQL_ROOT_PASSWORD=localhost \
  -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=localhost \
  -p 3306:3306 \
  mysql:5.7

read -p "Press any key to Run the MySQL wait command... " -n1 -s

# Wait for the database service to start up.
echo "Waiting for DB to start up..."
docker exec wordpress-mysql mysqladmin --silent --wait=30 -uroot -plocalhost ping || exit 1

sleep 5

read -p "Press any key to Run the MySQL setup SQL command... " -n1 -s

# Run the setup script.
echo "Setting up initial data..."
docker exec -i wordpress-mysql mysql -uwordpress -plocalhost wordpress < mysql-setup.sql
