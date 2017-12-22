#!/bin/bash 

#get git keys
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa ~/.ssh/
gsutil cp -r gs://api-project-773889352370-ml/.ssh/id_rsa.pub ~/.ssh/

chmod 400 ~/.ssh/id_rsa

#run docker container and pass keys
sudo docker run -it -v /home/ben/.ssh/:/root/.ssh/ gcr.io/api-project-773889352370/rwhales bin/bash 

#add git to known hosts?

#clonex
git clone git@github.com:bw4sz/WhalePhys.git --depth 1

cd WhalePhys

#make new branch      
git checkout -b $(hostname)

#render script
Rscript -e "rmarkdown::render('RunModel.Rmd')" &> run.txt

#push results
git config --global user.email "benweinstein2010@gmail.com"
git config --global user.name "bw4sz"

git add --all
git commit -m "Cloud run complete"
git push -u origin $(hostname)

#kill container
exit

#kill host
exit

#delete host
gcloud compute instances delete -q cloudml
