#!/bin/bash 

#Local Docker Builds
docker build -t "rwhales:latest" .

docker tag rwhales gcr.io/api-project-773889352370/rwhales
gcloud docker -- push  gcr.io/api-project-773889352370/rwhales
