#!/usr/bin/env bash
set -e

export GOPATH=/libpostal/workspace

go install $LIBPOSTAL_REST_PKG
