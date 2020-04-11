#!/bin/bash
echo yum update
sudo yum update -y
echo yum install httpd
sudo yum install httpd -y
echo service httpd start
sudo service httpd start
echo yum install docker
sudo yum install docker -y
echo service docker start
sudo service docker start
