#!/bin/bash     
    
#name it the instance ID
gcloud compute instances create cloudml \
    --image-family=container-vm \
    --image-project=google-containers \
    --metadata-from-file startup-script=Job.sh
    
#--machine-type=n1-highmem-8 \
