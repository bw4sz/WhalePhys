#!/bin/bash 

#Local Docker Builds
docker build -t "rwhales:latest" .

#gcloud docker push rwhales:latest gcr.io/api-project-773889352370/rwhales