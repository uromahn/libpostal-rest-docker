#!/usr/bin/env bash

# ===============================
# IMPORTANT:
# This file is no longer being used. The commands here have been
# directly added to the Dockerfile as a single RUN command to minimize
# the number of layers being created.
# It is only kept here for reference!
./bootstrap.sh
mkdir -p /opt/libpostal_data
./configure --datadir=/opt/libpostal_data
make -j4
make install
ldconfig
pkg-config --cflags libpostal
