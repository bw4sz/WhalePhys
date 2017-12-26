#!/bin/bash

#add git to known hosts?
ssh-keyscan github.com >> ~/.ssh/known_hosts

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