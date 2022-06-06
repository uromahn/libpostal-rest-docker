FROM docker.io/library/golang:1.18-bullseye as libpostal-dev

ARG COMMIT
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive
# update the following to the location and tag for the libpostal-rest package
# to be used in the build_libpostal_rest.sh script
ENV LIBPOSTAL_REST_PKG "github.com/uromahn/libpostal-rest@prod-test"

RUN apt-get update && apt-get install -y \
    autoconf automake build-essential curl git libsnappy-dev libtool pkg-config

WORKDIR /
RUN git clone https://github.com/openvenues/libpostal -b $COMMIT

WORKDIR /libpostal

# Copy the commands from build_libpostal.sh here
# and execute them as a single RUN commnad.
# This reduces the number of layers in the Docker image
RUN ./bootstrap.sh \
  && mkdir -p /opt/libpostal_data \
  && ./configure --datadir=/opt/libpostal_data \
  && make -j4 \
  && make install \
  && ldconfig \
  && pkg-config --cflags libpostal \
  && useradd -m srvcuser

FROM libpostal-dev as libpostal-rest

COPY build_libpostal_rest.sh .
RUN ./build_libpostal_rest.sh

USER srvcuser
EXPOSE 8080

CMD /libpostal/workspace/bin/libpostal-rest
