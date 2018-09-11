FROM debian:stretch AS build

ARG PCRE_VERSION="8.42"
ARG PCRE_CHECKSUM="69acbc2fbdefb955d42a4c606dfde800c2885711d2979e356c0636efde9ec3b5"

ARG OPENSSL_VERSION="1.1.1"
ARG OPENSSL_CHECKSUM="2836875a0f89c03d0fdf483941512613a50cfb421d6fd94b9f41d7279d586a3d"

ARG ZLIB_VERSION="1.2.11"
ARG ZLIB_CHECKSUM="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

ARG NGINX_VERSION="1.15.3"
ARG NGINX_CHECKSUM="9391fb91c3e2ebd040a4e3ac2b2f0893deb6232edc30a8e16fcc9c3fa9d6be85"
ARG NGINX_CONFIG="\
    --sbin-path=/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/tmp/nginx.pid \
    --http-log-path=/dev/stdout \
    --error-log-path=/dev/stdout \
    --http-client-body-temp-path=/tmp/client_temp \
    --http-proxy-temp-path=/tmp/proxy_temp \
    --http-fastcgi-temp-path=/tmp/fastcgi_temp \
    --http-uwsgi-temp-path=/tmp/uwsgi_temp \
    --http-scgi-temp-path=/tmp/scgi_temp \
    --with-pcre=/tmp/pcre-$PCRE_VERSION \
    --with-openssl=/tmp/openssl-$OPENSSL_VERSION \
    --with-zlib=/tmp/zlib-$ZLIB_VERSION \
    --without-http_empty_gif_module \
    --without-http_geo_module \
    --without-http_map_module \
    --without-http_referer_module \
    --without-http_ssi_module \
    --without-http_split_clients_module \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    --add-module=/tmp/ngx_brotli"

WORKDIR /tmp

ADD https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
RUN if [ "$PCRE_CHECKSUM" != "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/pcre.tar.gz

ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
RUN if [ "$OPENSSL_CHECKSUM" != "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/openssl.tar.gz

ADD https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
RUN if [ "$ZLIB_CHECKSUM" != "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/zlib.tar.gz

ADD https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz /tmp/nginx.tar.gz
RUN if [ "$NGINX_CHECKSUM" != "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/nginx.tar.gz && \
    mv /tmp/nginx-$NGINX_VERSION /tmp/nginx

RUN apt update && \
    apt install -y git && \
    git clone --recurse-submodules https://github.com/google/ngx_brotli.git /tmp/ngx_brotli

WORKDIR /tmp/nginx
RUN apt install -y gcc g++ make && \
    ./configure $NGINX_CONFIG && \
    make && \
    make install


FROM gcr.io/distroless/base

COPY --from=build /nginx /nginx
COPY --from=build /tmp/nginx/html /etc/nginx/html

COPY conf /etc/nginx

CMD ["/nginx", "-g", "daemon off;"]
