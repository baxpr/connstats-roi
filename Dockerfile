FROM centos:7

# Initial system
# java-1.8.0-openjdk                                 for MCR
RUN yum -y update && \
    yum -y install wget tar zip unzip && \
    yum -y install java-1.8.0-openjdk libXt && \
    yum clean all

# Install the MCR
RUN wget -nv https://ssd.mathworks.com/supportfiles/downloads/R2023a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2023a_Update_5_glnxa64.zip \
    -O /opt/mcr_installer.zip && \
    unzip /opt/mcr_installer.zip -d /opt/mcr_installer && \
    /opt/mcr_installer/install -mode silent -agreeToLicense yes && \
    rm -r /opt/mcr_installer /opt/mcr_installer.zip

# Matlab env
ENV MATLAB_SHELL=/bin/bash
ENV MATLAB_RUNTIME=/usr/local/MATLAB/MATLAB_Runtime/R2023a

# Copy the pipeline code. Matlab must be compiled before building. 
COPY build /opt/connstats-roi/build
COPY bin /opt/connstats-roi/bin
COPY src /opt/connstats-roi/src
COPY README.md /opt/connstats-roi

# Add pipeline to system path
ENV PATH=/opt/connstats-roi/src:/opt/connstats-roi/bin:${PATH}

# Matlab executable must be run at build to extract the CTF archive
RUN run_connstats_roi.sh ${MATLAB_RUNTIME} quit

# Entrypoint
ENTRYPOINT ["run_connstats_roi.sh","/usr/local/MATLAB/MATLAB_Runtime/R2023a"]
