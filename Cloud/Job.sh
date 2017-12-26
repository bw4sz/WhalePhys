#!/bin/bash 

#get git keys
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa ~/.ssh/
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa.pub ~/.ssh/

chmod 400 ~/.ssh/id_rsa

#start docker container and pass keys
sudo docker run -v /home/ben/.ssh/:/root/.ssh/ gcr.io/api-project-773889352370/rwhales

#delete host
#gcloud compute instances delete -q cloudml
