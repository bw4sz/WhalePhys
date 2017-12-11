#!/bin/bash     
    
#name it the instance ID
gcloud beta compute instances create-with-container instance-1 --container-image=gcr.io/api-project-773889352370/rwhales 
      
 #--metadata-from-file startup-script=Job.sh