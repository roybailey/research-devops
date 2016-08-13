#!/bin/sh

# Stop the db and remove the container.
docker stop wordpress-mysql && docker rm wordpress-mysql
