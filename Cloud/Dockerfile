FROM rocker/r-base
MAINTAINER Ben Weinstein

RUN Rscript -e "install.packages('stringr')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('maptools')"
RUN Rscript -e "install.packages('raster')"
RUN Rscript -e "install.packages('data.table')"
RUN Rscript -e "install.packages('ggmap')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('chron')"
RUN Rscript -e "install.packages('truncnorm')"
RUN Rscript -e "install.packages('MCMCpack')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('boot')"
RUN Rscript -e "install.packages(‘rmarkdown’)”
RUN Rscript -e "install.packages(‘tidyr’)”
RUN Rscript -e "install.packages(‘shiny’)”
RUN Rscript -e "install.packages(‘leaflet’)”

RUN apt-get update
RUN apt-get install --assume-yes jags git pandoc
RUN Rscript -e "install.packages('R2jags')"
