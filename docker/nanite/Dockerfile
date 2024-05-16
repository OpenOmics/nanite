# Base image for nanite,
# uses Ubuntu Jammy (LTS)
FROM ubuntu:22.04

# Depedencies of nanite:
#  - nanofilt/2.8.0       # from src, installed: 2.8.0
#      @requires: python3
#      @requires: python3-biopython
#      @requires: python3-pandas
#  - minimap2/2.24        # apt-get, installed: 2.24
#  - kronatools/2.8.1     # from src, installed: 2.8.1
#      @requires: curl
# Dependencies of ViralFlye:
#  - bcftools             # apt-get bcftools/1.13-1
#  - blast                # apt-get ncbi-blast+/2.12.0
#  - bwa                  # apt-get bwa/0.7.17-6 
#  - freebayes            # apt-get freebayes/1.3.6-1
#  - minced               # install from Github: https://github.com/ctSkennerton/minced
#  - java                 # apt-get openjdk-8-jdk, dependency of minced
#  - prodigal             # apt-get prodigal/1:2.6.3-5
#  - python>=3.6          # apt-get python3
#      @requires python3-biopython
#      @requires python3-numpy
#      @requires python3-pysam
#      @requires python3-scipy
#  - samtools             # apt-get samtools/1.13-4
#  - seqtk                # apt-get seqtk/1.3-2
#  - tabix                # apt-get tabix/1.13
#  - vcflib               # apt-get libvcflib-tools/1.0.3 libvcflib-dev/1.0.3
#  - viralcomplete        # install from github: https://github.com/ablab/viralComplete
#  - viralverify          # install from github: https://github.com/ablab/viralVerify
#      @requires: hmmer/3.3.2
#  - flye                 # install from github: https://github.com/fenderglass/Flye
#  - viralFlye            # install from github: https://github.com/Dmitry-Antipov/viralFlye
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
        minimap2 \
        # kronatools dependencies
        curl \
        perl \
        cpanminus \
        # nanofilt dependencies
        python3 \
        python3-pip \
        python3-biopython \
        python3-pandas \
        # ViralFlye dependencies
        bcftools \
        ncbi-blast+ \
        bwa \
        freebayes \
        hmmer \
        openjdk-8-jdk \
        prodigal \
        python3-numpy \
        python3-pysam \
        python3-scipy \
        samtools \
        seqtk \
        tabix \
        libvcflib-tools \
        libvcflib-dev \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Make python3 the default interpreter
# and install Python Packages 
# and install nanofilt/2.8.0
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade pip \
	&& pip3 install argparse \
        && pip3 install nanofilt==2.8.0

############### MANUAL ################
# Install kronatools/v2.8.1 manually, 
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied:
# https://github.com/marbl/Krona/releases
WORKDIR /opt2
RUN cd /opt2 && wget https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar \
	    && tar -xvf KronaTools-2.8.1.tar  \
	    && rm KronaTools-2.8.1.tar \ 
	    && cd KronaTools-2.8.1/ \
	    && ./install.pl

# Install minced/v0.4.2 manually, 
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied:
# https://github.com/ctSkennerton/minced/releases/tag/0.4.2
RUN cd /opt2 && wget https://github.com/ctSkennerton/minced/archive/refs/tags/0.4.2.tar.gz \
        && tar -xvf 0.4.2.tar.gz \
        && rm 0.4.2.tar.gz \
        && cd minced-0.4.2 \
        && make \
        && rm -rf /opt2/minced-0.4.2/t/

# Install latest viralComplete manually, 
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied.
# No relases for this program, here 
# is the commit hash of the version: 
# db9ffa7c1beb38c1375a33619388d4bd4d2be59b
RUN cd /opt2 && git clone https://github.com/ablab/viralComplete.git /opt2/viralComplete \
    && cd /opt2/viralComplete \
    && git checkout db9ffa7c1beb38c1375a33619388d4bd4d2be59b \
    && chmod -R a+rX /opt2/viralComplete/bin

# Install latest viralVerify manually,
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied.
# No releases for latest program, here 
# is the commit hash of the version: 
# 4a425c88662a67c9301a3a14e7e4f78a4e115d4d
RUN cd /opt2 && git clone https://github.com/ablab/viralVerify.git /opt2/viralVerify \
    && cd /opt2/viralVerify \
    && git checkout 4a425c88662a67c9301a3a14e7e4f78a4e115d4d \
    && chmod -R a+rX /opt2/viralComplete/bin

# Install flye/2.9.4 manually,
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied.
RUN cd /opt2 && wget https://github.com/fenderglass/Flye/archive/refs/tags/2.9.4.tar.gz \
    && tar -xvf 2.9.4.tar.gz \
    && rm 2.9.4.tar.gz \
    && cd Flye-2.9.4 \
    && python3 setup.py install

# Install viralFlye/0.2 manually,
# not available to apt-get on Ubuntu/22.04.
# Dependencies already satisfied.
RUN cd /opt2 && wget https://github.com/Dmitry-Antipov/viralFlye/archive/refs/tags/v0.2.tar.gz \
    && tar -xvf v0.2.tar.gz \
    && rm v0.2.tar.gz 

################ POST #################
# Add Dockerfile and export environment 
# variables and set java8 as default with links
# to alternative versions
ADD Dockerfile /opt2/nanite.dockerfile
RUN chmod -R a+rX /opt2
ENV PATH="/opt2:/opt2/minced-0.4.2:/opt2/viralComplete/bin:/opt2/viralVerify/bin:/opt2/viralFlye-0.2:$PATH"
WORKDIR /data2