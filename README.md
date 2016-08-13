research-docker
===============

Docker samples and scripts (`eval "$(docker-machine env default)"`\)

###### Neo4j

> `docker run --publish=8484:7474 --publish=8688:7687 --volume=$HOME/neo4j/data:/data neo4j:3.0`

-	neo4j.web.port=`8484`
-	neo4j.bolt.port=`8688`

###### Elastic Search

> `docker run elasticsearch`

-	elastic.http.port=`9200`
-	elastic.transport.port=`9300`

###### Redis

> `docker run --name local-redis redis`

-	redis.port=`6379`

###### Cassandra

> `docker run --name local-cassandra cassandra:latest`

-	cassandra.cql.port=`9042`
-	cassandra.jmx.port=`7199`

###### MongoDB

> `docker run --name some-mongo mongo`

-	mongo.port=`27017`

###### MySQL `https://hub.docker.com/_/mysql/`

> `docker run --name wordpress-mysql -e MYSQL_ROOT_PASSWORD=localhost -d mysql:5.7.14`

-	`docker run -it --link wordpress-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`

###### WordPress `https://hub.docker.com/_/wordpress/`

> `docker run --name 4.5.3-apache --link wordpress-mysql:mysql -d wordpress`
>
> `docker run -e WORDPRESS_DB_PASSWORD=localhost -d --name wordpress --link wordpress-mysql:mysql wordpress:4.5.3-apache`
>
> `docker run -e WORDPRESS_DB_PASSWORD=localhost -d --name wordpress --link wordpress-mysql:mysql -p 127.0.0.2:8080:80 -v "$PWD/":/var/www/html wordpress`

---

docker commands
===============

> `docker-machine help`

Help guide

> `docker-machine ls`

List all docker machines

> `docker-machine env default`

Get the environment commands for your new VM.

> `eval "$(docker-machine env default)"`

Connect your shell to the default machine.

> `docker-machine rm <machine-name>`

Removing a VM machine

> `docker run -d -P --name <image-container-name> <docker-image>`

Normally, the docker run commands starts a container, runs it, and then exits. The `-d` flag keeps the container running in the background after the docker run command completes. The `-P` flag publishes exposed ports from the container to your local host; this lets you access them from your Mac.

Display your running container with `docker ps` command

> `docker port <image-container-name>`

View just the container’s ports.

> `docker-machine ip <machine-name>`

Get the IP address for docker machine.

> `docker stop <image-container-name>` `docker rm <image-container-name>`

Stop and Remove running docker container.

> `docker run -d -P -v $HOME/site:/usr/share/nginx/html --name mysite nginx`

Start a new instance with folder mapped to local drive location.

> `~/.docker/machine/machines`

Location of docker machines on disk.

> `Dockerfile`

For defining Docker image on existing folder (e.g. node server)

```
# Use Node v4 as the base image.
FROM node:4

# Run node
CMD ["node","--version"]
```

> `docker build -t <tag-name> .`

Builds a new docker image container from current folder

> `docker run -it <tag-name>`

Run a container with this image, interactive

> `docker ps -a`

Lists all containers

> docker rm `docker ps -aq`

Removes all dead containers
