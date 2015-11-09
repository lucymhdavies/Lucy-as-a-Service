# LMHD Sinatra Boilerplate

Boilerplate code for Sinatra Apps.

An ever-evolving hello-world 'em up.

## Docker

### From Repo
For now, it just uses the [Redis Cloud Ruby Sinatra Sample app](https://github.com/RedisLabs/rediscloud-ruby-sinatra-sample).

So steps to run it are as with that.

````
docker-compose up web
````

And the app will be available on your Docker daemon's IP on port 8080.

### From Docker Image

Avaiable on Docker Hub:
https://hub.docker.com/r/lucymhdavies/sinatra-boilerplate

````
docker pull lucymhdavies/sinatra-boilerplate
````

* Grab the docker-compose.yml file
* Replace ````build: .```` with ````image: lucymhdavies/sinatra-boilerplate````
* Run the same ````docker-compose```` command as above
