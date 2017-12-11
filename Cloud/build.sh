#!/bin/bash 

gcloud container builds submit --tag gcr.io/api-project-773889352370/rwhales . --timeout 20m
