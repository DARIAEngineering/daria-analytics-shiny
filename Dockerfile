FROM rocker/shiny
MAINTAINER Colin Fleming <c3flemin@gmail.com>

# configure environment variable
# note: move this to three ARG commands when CircleCI updates their docker
ENV DCAF_DIR=/usr/src/app

# get our gem house in order
RUN mkdir -p ${DCAF_DIR} && cd ${DCAF_DIR}
WORKDIR ${DCAF_DIR}
COPY packages.R ${DCAF_DIR}/packages.R

# install packages
RUN Rscript packages.R

# Move the rest of the app over
COPY . ${DCAF_DIR}

EXPOSE 3838
