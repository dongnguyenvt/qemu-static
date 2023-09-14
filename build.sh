#!/bin/sh

set -xe

docker run --rm -it -v $(pwd):/build alpine:3.18 sh


./configure --prefix=/opt --static --cpu=x86_64 --target-list=x86_64-linux-user
apk add python3 py3-pip gcc make samurai perl libc-dev pkgconf \
    linux-headers glib-dev glib-static zlib-dev zlib-static bash \
    git patch pixman-dev pixman-static bzip2-static ncurses-static
pip install ninja sphinx>=1.6.0 sphinx-rtd-theme>=0.5.0

