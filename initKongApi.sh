#!/bin/bash
docker build .
docker run -d -p 9042:9042 --name cassandra mashape/cassandra
sleep 10
docker run -d -p 8000:8000 -p 8001:8001 --name kong --link cassandra:cassandra mashape/kong
sleep 20
curl -i -X POST --url http://192.168.99.100:8001/apis/ --data 'name=cmsapi' --data 'upstream_url=http://172.16.8.220:3000' --data 'request_host=172.16.8.220'
curl -X POST http://192.168.99.100:8001/apis/cmsapi/plugins --data "name=key-auth"
curl -X POST http://192.168.99.100:8001/consumers/ --data "username=appClient"
curl -X POST http://192.168.99.100:8001/consumers/appClient/key-auth --data "key=1hd98FiCt5qJ5vvw2az44BFr9bUFrhEl"
