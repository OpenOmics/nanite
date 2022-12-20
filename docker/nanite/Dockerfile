# Base image for metavirs,
# uses Ubuntu Jammy (LTS)
FROM ubuntu:22.04

# Depedencies of metvirs:
#  - nanofilt/2.8.0       # from src, installed: 2.8.0
#      @requires: python3
#      @requires: python3-biopython
#      @requires: python3-pandas
#  - minimap2/2.24        # apt-get, installed: 2.24
#  - kronatools/2.8.1     # from src, installed: 2.8.1
#      @requires: curl
LABEL maintainer=kuhnsa@nih.gov

############### INIT ################
# Create Container filesystem specific 
# working directory and opt directories
# to avoid collisions with the host's
# filesystem, i.e. /opt and /data
RUN mkdir -p /opt2 && mkdir -p /data2
WORKDIR /opt2 

# Set time zone to US east coast 
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

############### SETUP ################
# This section installs system packages 
# required for your project. If you need 
# extra system packages add them here.
RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        gawk \
        git \
        gzip \
        locales \
        make \
        unzip \
        wget \
        zlib1g-dev \
        # kronatools dependencies
        curl \
        perl \
        cpanminus \
        # nanofilt dependencies
        python3 \
        python3-pip \
        python3-biopython \
        python3-pandas \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Make python3 the default interpreter
# and install Python Packages 
# and install nanofilt/2.8.0
RUN ln -sf /usr/bin/python3.8 /usr/bin/python
RUN pip3 install --upgrade pip \
	&& pip3 install argparse \
        && pip3 install nanofilt==2.8.0

############### INSTALL ################
# Install any bioinformatics tools
# available with apt-get on Ubuntu/22.04
RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        # minimap2/2.24
        minimap2 \
        # samtools/1.13
        samtools \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

############### MANUAL ################
# Install kronatools/v2.8.1) manually, 
# not available to apt-get on Ubuntu/20.04.
# Dependencies already satisfied:
# https://github.com/marbl/Krona/releases
RUN wget https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar \
	    && tar -xvf KronaTools-2.8.1.tar  \
	    && rm KronaTools-2.8.1.tar \ 
	    && cd KronaTools-2.8.1/ \
	    && ./install.pl
WORKDIR /opt2

################ POST #################
# Add Dockerfile and export environment 
# variables and set java8 as default with links
# to alternative versions
ADD Dockerfile /opt2/nanite.dockerfile
RUN chmod -R a+rX /opt2
ENV PATH="/opt2:$PATH"
WORKDIR /data2