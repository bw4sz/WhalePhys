#!/bin/bash 

docker run -it gcr.io/api-project-773889352370/rwhales bin/bash

#clone
git clone https://github.com/bw4sz/WhalePhys.git --depth 1

cd WhalePhys

#make new branch      
git checkout -b $(hostname)

#render script
Rscript -e "rmarkdown::render('RunModel.Rmd')" &> run.txt

#push results
git add --all
git commit -m "Cloud run complete"
git push -u origin $iid

#kill instance
sudo halt
