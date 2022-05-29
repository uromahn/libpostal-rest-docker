FROM golang:1.17.8-buster

ARG COMMIT
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    autoconf automake build-essential curl git libsnappy-dev libtool pkg-config

WORKDIR /
RUN git clone https://github.com/openvenues/libpostal -b $COMMIT

WORKDIR /libpostal

COPY build_libpostal.sh .
RUN ./build_libpostal.sh

COPY build_libpostal_rest.sh .
RUN ./build_libpostal_rest.sh

EXPOSE 8080

CMD /libpostal/workspace/bin/libpostal-rest
