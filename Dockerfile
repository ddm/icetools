FROM alpine:3.6

ARG IVERILOG_TAG=v10_2
ARG VERILATOR_TAG=verilator_3_910

RUN apk --no-cache add --virtual runtime-dependencies \
      libgcc \
      libstdc++ \
      libffi \
      libftdi1 \
      readline \
      graphviz \
      python3 \
      tcl \
      make \
      bash &&\
    apk --no-cache add --virtual build-dependencies \
      git \
      mercurial \
      clang \
      build-base \
      autoconf \
      bison \
      flex \
      gawk \
      tcl-dev \
      python \
      libffi-dev \
      libftdi1-dev \
      readline-dev \
      gperf &&\
    git clone --depth 1 https://github.com/cliffordwolf/icestorm.git /tmp/icestorm && cd /tmp/icestorm &&\
    make && make install &&\
    git clone --depth 1 https://github.com/cseed/arachne-pnr.git /tmp/arachne-pnr && cd /tmp/arachne-pnr &&\
    make && make install &&\
    git clone --depth 1 https://github.com/cliffordwolf/yosys.git /tmp/yosys && cd /tmp/yosys &&\
    make yosys-abc && make && make install &&\
    git clone --depth 1 --branch ${IVERILOG_TAG} https://github.com/steveicarus/iverilog.git /tmp/iverilog && cd /tmp/iverilog &&\
    autoconf && ./configure && make && make install &&\
    git clone --depth 1 --branch ${VERILATOR_TAG} https://github.com/ddm/verilator.git /tmp/verilator && cd /tmp/verilator &&\
    autoconf && ./configure && make && make install &&\
    apk del --purge build-dependencies &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/* &&\
    adduser -D -u 1000 user

USER user
WORKDIR /tmp

