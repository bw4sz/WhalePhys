FROM rocker/geospatial
MAINTAINER Ben Weinstein

RUN install2.r -e ggmap chron truncnorm MCMCpack shiny leaflet rmarkdown plyr data.table

RUN apt-get update
RUN apt-get install --assume-yes jags git pandoc

RUN install2.r -e  R2jags jagsUI

ADD DockerJob.sh /mnt/

ENTRYPOINT /mnt/DockerJob.sh