#!/bin/sh

# Stop the db and remove the container.
docker stop wordpress && docker rm wordpress
