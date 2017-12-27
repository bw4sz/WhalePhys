#!/bin/bash 

#get git keys
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa /home/ben/.ssh/
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa.pub /home/ben/.ssh/

chmod 400 /home/ben/.ssh/id_rsa

#start docker container and pass keys
sudo docker run -v /home/ben/.ssh/:/root/.ssh/ gcr.io/api-project-773889352370/rwhales

#Delete host
sudo shutdown -h
