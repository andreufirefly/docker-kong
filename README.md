# KONG
This document describes how to use Kong. The first part shows how to start a Kong/Cassandra cluster using Docker. The second part contains examples of how to set up APIs using Kong RESTful API.

## 1. Start a Cassandra container

Start a Cassandra container by doing so:
docker run -d -p 9042:9042 --name cassandra mashape/cassandra

## 2. Edit the conf file (kong.yml)
Add the SSL paths
Check that Cassandra's properties are correct
Put the admin port on a firefwall

## 3. Start Kong with a custom configuration file
The configuration file links Kong to the Cassandra container. It also provides the paths for the SSL keys.
docker run -d -v /etc/kong -p 8000:8000 -p 8001:8001 -p 443:8443 --name kong mashape/kong

#### USING KONG ####
Kong has a RESTful API

## 1. Adding APIs to Kong
GET http://[host]:8001/apis --data 'name=[API name]' --data 'upstream_url=[the url to proxy the request]' --data 'request_host=[upstream url host (see examples below)]'

## 2. Enable API key authentication (or any other Kong plugin)
POST http://[host]:8001/apis/[API name]/plugins --data "name=key-auth"

## 3. Adding a consumer to an API
POST http://[host]:8001/apis/consumers --data 'username=[username]'

## 4. Adding a key to an API
POST http://[host]:8001/apis/consumers[consumer username]/key-auth --data 'key=[api key]'

## Make a request to an API
GET http://[host] --header 'Host:request_host' --header 'apikey:[api key]'

# EXAMPLES #

## blobstorageapi
curl -i -X POST --url http://api.firef.ly:8001/apis/ --data 'name=cmsapi' --data 'upstream_url=http://blobstorageapi.firef.ly' --data 'request_host=blobstorageapi.firef.ly'
curl -X POST http://api.firef.ly:8001/apis/cmsapi/plugins --data "name=key-auth"
curl -X POST http://api.firef.ly:8001/consumers/ --data "username=blobstorageapiClient"
curl -X POST http://api.firef.ly:8001/consumers/blobstorageapiClient/key-auth --data "key=1hd98FiCt5qJ5vvw2az44BFr9bUFrhEl"
curl -X POST http://api.firef.ly:8001/consumers/blobstorageapiClient/acls --data 'group=blobstorageAccess'
curl -X POST http://api.firef.ly:8001/apis/cmsapi/plugins --data 'name=acl' --data 'config.whitelist=blobstorageAccess'

#insightvm
curl -i -X POST --url http://api.firef.ly:8001/apis/ --data 'name=insightapi' --data 'upstream_url=http://insightvm.firef.ly' --data 'request_host=insightvm.firef.ly'
curl -X POST http://api.firef.ly:8001/apis/insightapi/plugins --data "name=key-auth"
curl -X POST http://api.firef.ly:8001/consumers/ --data "username=insightapiClient"
curl -X POST http://api.firef.ly:8001/consumers/insightapiClient/key-auth --data "key=9agjSPE8SCjDUvUG8y4kw6vPY6g0z745"
curl -X POST http://api.firef.ly:8001/consumers/insightapiClient/acls --data 'group=insightapiAccess'
curl -X POST http://api.firef.ly:8001/apis/insightapi/plugins --data 'name=acl' --data 'config.whitelist=insightapiAccess'

#factual
curl -i -X POST --url http://api.firef.ly:8001/apis/ --data 'name=factualapi' --data 'upstream_url=http://factual.firef.ly' --data 'request_host=factual.firef.ly'
curl -X POST http://api.firef.ly:8001/apis/factualapi/plugins --data "name=key-auth"
curl -X POST http://api.firef.ly:8001/consumers/ --data "username=factualapiClient"
curl -X POST http://api.firef.ly:8001/consumers/factualapiClient/key-auth --data "key=u0yY8fs847P8iRo3Xp6Ts7XGh99Ey5VW"
curl -X POST http://api.firef.ly:8001/consumers/factualapiClient/acls --data 'group=factualapiAccess'
curl -X POST http://api.firef.ly:8001/apis/factualapi/plugins --data 'name=acl' --data 'config.whitelist=factualapiAccess'

#brains
curl -i -X POST --url http://api.firef.ly:8001/apis/ --data 'name=brainsapi' --data 'upstream_url=http://brains1.firef.ly/api/poisInsight' --data 'request_host=brains1.firef.ly'
curl -X POST http://api.firef.ly:8001/consumers/ --data "username=brainsapiClient"
curl -X POST http://api.firef.ly:8001/consumers/brainsapiClient/key-auth --data "key=5mfTOjRHSXe6US9Orj7nf95jtf065puo"
curl -X POST http://api.firef.ly:8001/consumers/brainsapiClient/acls --data 'group=brainsapiAccess'
curl -X POST http://api.firef.ly:8001/apis/brainsapi/plugins --data 'name=acl' --data 'config.whitelist=brainsapiAccess'
