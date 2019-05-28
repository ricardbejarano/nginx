FROM alpine AS build

ARG PCRE_VERSION="8.43"
ARG PCRE_CHECKSUM="0b8e7465dc5e98c757cc3650a20a7843ee4c3edf50aaf60bb33fd879690d2c73"

ARG ZLIB_VERSION="1.2.11"
ARG ZLIB_CHECKSUM="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

ARG OPENSSL_VERSION="1.1.1c"
ARG OPENSSL_CHECKSUM="f6fb3079ad15076154eda9413fed42877d668e7069d9b87396d0804fdb3f4c90"

ARG NGINX_VERSION="1.17.0"
ARG NGINX_CHECKSUM="e21b5d06cd53e86afb94f0b3678e0abb0c0f011433471fa3d895cefa65ae0fab"
ARG NGINX_CONFIG="\
    --with-cc-opt='-static' \
    --with-ld-opt='-static' \
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
    --with-file-aio \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads"

ADD https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
ADD https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
ADD https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz /tmp/nginx.tar.gz

RUN cd /tmp && \
    if [ "$PCRE_CHECKSUM" != "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/pcre.tar.gz && \
    if [ "$ZLIB_CHECKSUM" != "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/zlib.tar.gz && \
    if [ "$OPENSSL_CHECKSUM" != "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/openssl.tar.gz && \
    if [ "$NGINX_CHECKSUM" != "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/nginx.tar.gz && \
    mv /tmp/nginx-$NGINX_VERSION /tmp/nginx

RUN cd /tmp/nginx && \
      apk add gcc g++ perl make linux-headers && \
      ./configure $NGINX_CONFIG && \
      make


FROM scratch

COPY --from=build /tmp/nginx/objs/nginx /nginx

COPY rootfs /

USER nginx:nginx
WORKDIR /
EXPOSE 80/tcp
STOPSIGNAL SIGTERM
ENTRYPOINT ["/nginx"]
CMD ["-g", "daemon off;"]
