FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y build-essential

ADD . /fluidanimate
WORKDIR /fluidanimate

ENV PATH /fluidanimate/bin:$PATH
RUN parsecmgmt -a build -p fluidanimate -c gcc-openmp

ENTRYPOINT ["parsecmgmt", "-a", "run", "-p", "fluidanimate", "-c", "gcc-openmp", "-n", "8", "-i"]