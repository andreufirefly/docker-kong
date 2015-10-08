#!/bin/bash
docker build .
docker run -d -p 9042:9042 --name cassandra mashape/cassandra
docker run -d -p 8000:8000 -p 8001:8001 --name kong --link cassandra:cassandra mashape/kong
curl -i -X POST --url http://localhost:8001/apis/ --data 'name=cmsapi' --data 'upstream_url=http://localhost:3000' --data 'request_host=localhost'
curl -X POST http://localhost:8001/apis/cmsapi/plugins --data "name=key-auth"
curl -X POST http://localhost:8001/consumers/ --data "username=appClient"
curl -X POST http://localhost:8001/consumers/appClient/key-auth --data "key=1hd98FiCt5qJ5vvw2az44BFr9bUFrhEl"
