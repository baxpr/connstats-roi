FROM containers.mathworks.com/matlab-runtime:r2023a

COPY build /opt/connstats-roi/build
COPY bin /opt/connstats-roi/bin
COPY src /opt/connstats-roi/src
COPY README.md /opt/connstats-roi

#ENV MATLAB_SHELL=/bin/bash
ENV AGREE_TO_MATLAB_RUNTIME_LICENSE=yes
ENV MATLAB_RUNTIME=/opt/matlabruntime/R2023a
ENV MCR_INHIBIT_CTF_LOCK=1
ENV MCR_CACHE_ROOT=/tmp

# Add pipeline to system path
ENV PATH=/opt/connstats-roi/bin:${PATH}

# Extract CTF
RUN run_connstats_roi.sh /opt/matlabruntime/R2023a quit

# Entrypoint
ENTRYPOINT ["run_connstats_roi.sh","/opt/matlabruntime/R2023a"]
