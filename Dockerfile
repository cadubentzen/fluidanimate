FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y build-essential

ADD . /fluidanimate
WORKDIR /fluidanimate

ENV PATH /fluidanimate/bin:$PATH

RUN parsecmgmt -a build -p fluidanimate -c gcc-pthreads
RUN parsecmgmt -a build -p fluidanimate -c gcc-openmp

RUN parsecmgmt -a run -p fluidanimate -c gcc-pthreads -n 8 -i simlarge
RUN cp pkgs/apps/fluidanimate/run/out.fluid /tmp

RUN parsecmgmt -a run -p fluidanimate -c gcc-openmp -n 8 -i simlarge
RUN ./pkgs/apps/fluidanimate/inst/amd64-linux.gcc-openmp/bin/fluidcmp \
    pkgs/apps/fluidanimate/run/out.fluid \
    /tmp/out.fluid \
    --verbose \
    --ptol 0.1 \
    --vtol 0.1 \
    --bbox 0.1

ENTRYPOINT ["parsecmgmt", "-a", "run", "-p", "fluidanimate", "-c", "gcc-openmp"]