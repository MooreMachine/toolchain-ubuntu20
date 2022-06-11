FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --allow-downgrades \
    libdpkg-perl=1.19.7ubuntu3 \
    dpkg-dev=1.19.7ubuntu3 \
    g++-9=9.4.0-1ubuntu1~20.04.1 \
    gcc-9=9.4.0-1ubuntu1~20.04.1 \
    libc6=2.31-0ubuntu9.7 \
    libc-dev-bin=2.31-0ubuntu9.7 \
    libc6-dev=2.31-0ubuntu9.7 \
    make=4.2.1-1.2 \
    cmake=3.16.3-1ubuntu1 \
    gdb=9.2-0ubuntu1~20.04.1
