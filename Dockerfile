FROM alpine:3.18 as build

ARG QEMU_VERSION=8.1.0

WORKDIR /build

RUN apk add --no-cache python3 py3-pip gcc make samurai perl libc-dev pkgconf \
       linux-headers glib-dev glib-static zlib-dev zlib-static bash curl \
       git patch pixman-dev pixman-static bzip2-static ncurses-static && \
    pip install ninja sphinx>=1.6.0 sphinx-rtd-theme>=0.5.0

RUN curl -L https://download.qemu.org/qemu-${QEMU_VERSION}.tar.xz | tar xfJ - && \
    cd qemu-${QEMU_VERSION} && \
    ./configure --prefix=/usr/local --static --cpu=x86_64 --target-list=x86_64-softmmu && \
    make -j$(grep -c processor /proc/cpuinfo) && \
    make install && \
    strip -s /usr/local/bin/qemu*

FROM alpine:3.18 as deploy

COPY --from=build /usr/local /usr/local
ENTRYPOINT [ "/usr/local/bin/qemu-system-x86_64" ]
