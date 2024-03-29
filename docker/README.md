research-docker
===============

Docker samples and scripts (`eval "$(docker-machine env default)"`\)

## Docker Commands

`docker logs -f <container>` follow a log


## Docker Compose

`docker-compose up`

`docker-compose -d up` run in daemon background mode

`docker-compose -f [docker-compose.yml] up` run using custom docker-compose file config


###### MySQL `https://hub.docker.com/_/mysql/`

> `docker run --name wordpress-mysql -e MYSQL_ROOT_PASSWORD=localhost -d mysql:5.7.14`

-	`docker run -it --link wordpress-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`


###### WordPress `https://hub.docker.com/_/wordpress/`

> `docker run --name 4.5.3-apache --link wordpress-mysql:mysql -d wordpress`
>
> `docker run -e WORDPRESS_DB_PASSWORD=localhost -d --name wordpress --link wordpress-mysql:mysql wordpress:4.5.3-apache`
>
> `docker run -e WORDPRESS_DB_PASSWORD=localhost -d --name wordpress --link wordpress-mysql:mysql -p 127.0.0.2:8080:80 -v "$PWD/":/var/www/html wordpress`
>
> `docker exec CONTAINER_NAME chown -R www-data:www-data /var/www/html` e.g. `docker exec 1499fbd7fd7b chown -R www-data:www-data /var/www/html`

---

*All-In-One WP Migration* plugin seems simplest and reliable option for cloning a wordpress site, content and database.
https://help.servmask.com/2018/10/27/how-to-increase-maximum-upload-file-size-in-wordpress/

*Getting wordpress to run under different port* requires changing the Site URL under General Settings
using the working port (80 or 8080), then restarting wordpress under new port number.


###### Neo4j

> `docker run --publish=8484:7474 --publish=8688:7687 --volume=$HOME/neo4j/data:/data neo4j:3.0`

-	neo4j.web.port=`8484`
-	neo4j.bolt.port=`8688`


###### Elastic Search

> `docker run elasticsearch`

-	elastic.http.port=`9200`
-	elastic.transport.port=`9300`

> `docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch`
>
> `docker run -d -v "$PWD/esdata":/usr/share/elasticsearch/data elasticsearch`


###### Redis

> `docker run --name local-redis redis`

-	redis.port=`6379`


###### Cassandra

> `docker run --name local-cassandra cassandra:latest`

-	cassandra.cql.port=`9042`
-	cassandra.jmx.port=`7199`


###### Kafka

```
docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=`docker-machine ip \`docker-machine active\`` --env ADVERTISED_PORT=9092 spotify/kafka
export KAFKA=`docker-machine ip \`docker-machine active\``:9092
export ZOOKEEPER=`docker-machine ip \`docker-machine active\``:2181
kafka-console-producer.sh --broker-list $KAFKA --topic test
kafka-console-consumer.sh --zookeeper $ZOOKEEPER --topic test
```

Use `0.0.0.0` with Docker for Mac as it doesn't use `docker-machine`
 

###### MongoDB

> `docker run --name some-mongo mongo`

-	mongo.port=`27017`


###### Postgres

> `docker run --name test-postgres -e POSTGRES_PASSWORD=localhost -d postgres`


###### Jira

> `docker run -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 3456:8080 atlassian/jira-software`

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

> `docker run -it <tag-name> sh`

Run a container with this image, interactive and into shell

> `docker ps -a`

Lists all containers

> docker rm `docker ps -aq`

Removes all dead containers

> docker volume ls

List all volumes
