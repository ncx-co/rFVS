FROM ubuntu:16.04
LABEL maintainer="henry@silviaterra.com"

# Copy over auth credentials
# /root
# |-- .aws
# |   |-- config
# |   |-- credentials
# |-- .boto
# |-- .box
# |   |-- box_api_unsecure_private_key.pem
# |-- .s3cfg
# |-- .ssh
#     |-- ec2-keypair.pem
#     |-- id_rsa
COPY auth/ /root/

# Add CRAN repo to sources.list and add key
# From - https://cran.r-project.org/bin/linux/ubuntu/README
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial-cran35/" >> \
    /etc/apt/sources.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# Install ubuntu packages
# -- Python --
# cryptography: libffi-dev libssl-dev python-dev
# fiona: libgdal-dev
# rasterio: libgdal-dev
# osgeo: python-gdal
# Rtree: libspatialindex-dev
# -- R --
# rgdal: libproj-dev
# Rglpk: libglpk-dev
# sf: libjq-dev libprotobuf-dev libv8-dev protobuf-compiler
# rmarkdown: pandoc
RUN apt-get update && \
    # we have to add the ubuntugis repo for newer version of gdal
    apt-get update &&
    apt-get install -y --allow-unauthenticated \
    build-essential \
    cmake \
    gfortran \
    git \
    r-base-core \
    subversion \
    sudo \
    unixodbc-dev \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install important/heavy R packages
# RUN Rscript -e "install.packages('tidyverse')"

# clone SilviaTerra rFVS
WORKDIR /opt
RUN git clone git@github.com:SilviaTerra/rFVS.git

# clone FVS repo
RUN svn checkout https://svn.code.sf.net/p/open-fvs/code/trunk/ /opt/open-fvs

WORKDIR /opt/open-fvs/bin
RUN make

# set sensitive env vars from --build-args
# check for existence at build time
ARG AZURE_STORAGE_KEY
ARG AZURE_STORAGE_ACCOUNT

# note these are for the 'docker' iam
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN if [ -z "$AZURE_STORAGE_KEY" ];\
  then echo 'AZURE_STORAGE_KEY not provided in --build-dir' && exit 1;\
fi && if [ -z "$AZURE_STORAGE_ACCOUNT" ];\
  then echo 'AZURE_STORAGE_ACCOUNT not provided in --build-dir' && exit 1;\
fi && if [ -z "$AWS_ACCESS_KEY_ID" ];\
  then echo 'AWS_ACCESS_KEY_ID not provided in --build-dir' && exit 1;\
fi && if [ -z "$AWS_SECRET_ACCESS_KEY" ];\
  then echo 'AWS_SECRET_ACCESS_KEY not provided in --build-dir' && exit 1;\
fi

ENV AZURE_STORAGE_KEY ${AZURE_STORAGE_KEY}
ENV AZURE_STORAGE_ACCOUNT ${AZURE_STORAGE_ACCOUNT}
ENV AWS_ACCESS_KEY_ID ${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY ${AWS_SECRET_ACCESS_KEY}

WORKDIR /
