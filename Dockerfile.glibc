FROM debian:10 AS build

ARG PCRE_VERSION="8.43"
ARG PCRE_CHECKSUM="0b8e7465dc5e98c757cc3650a20a7843ee4c3edf50aaf60bb33fd879690d2c73"

ARG ZLIB_VERSION="1.2.11"
ARG ZLIB_CHECKSUM="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

ARG OPENSSL_VERSION="1.1.1d"
ARG OPENSSL_CHECKSUM="1e3a91bc1f9dfce01af26026f856e064eab4c8ee0a8f457b5ae30b40b8b711f2"

ARG NGINX_VERSION="1.17.7"
ARG NGINX_CHECKSUM="b62756842807e5693b794e5d0ae289bd8ae5b098e66538b2a91eb80f25c591ff"
ARG NGINX_CONFIG="\
    --with-cc-opt='-fstack-protector-all' \
    --with-ld-opt='-Wl,-z,relro,-z,now' \
    --sbin-path=/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/tmp/nginx.pid \
    --http-log-path=/dev/stdout \
    --error-log-path=/dev/stderr \
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

RUN [ "$PCRE_CHECKSUM" = "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" ] && \
    [ "$ZLIB_CHECKSUM" = "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" ] && \
    [ "$OPENSSL_CHECKSUM" = "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" ] && \
    [ "$NGINX_CHECKSUM" = "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" ] && \
    tar -C /tmp -xf /tmp/pcre.tar.gz && \
    tar -C /tmp -xf /tmp/zlib.tar.gz && \
    tar -C /tmp -xf /tmp/openssl.tar.gz && \
    tar -C /tmp -xf /tmp/nginx.tar.gz && \
    mv /tmp/nginx-$NGINX_VERSION /tmp/nginx

RUN cd /tmp/nginx && \
      apt update && \
      apt install -y gcc g++ perl make && \
      ./configure $NGINX_CONFIG && \
      make && \
    echo "nogroup:*:100:nobody" > /tmp/group && \
    echo "nobody:*:100:100:::" > /tmp/passwd && \
    mkdir -p /tmp/tmp


FROM scratch

COPY --from=build --chown=100:100 /tmp/nginx/objs/nginx /
COPY --from=build --chown=100:100 /tmp/tmp /tmp
COPY --from=build --chown=100:100 /lib/x86_64-linux-gnu/libc.so.6 \
                                  /lib/x86_64-linux-gnu/libcrypt.so.1 \
                                  /lib/x86_64-linux-gnu/libdl.so.2 \
                                  /lib/x86_64-linux-gnu/libnss_files.so.2 \
                                  /lib/x86_64-linux-gnu/libnss_dns.so.2 \
                                  /lib/x86_64-linux-gnu/libpthread.so.0 \
                                  /lib/x86_64-linux-gnu/libresolv.so.2 \
                                  /lib/x86_64-linux-gnu/
COPY --from=build --chown=100:100 /lib64/ld-linux-x86-64.so.2 /lib64/
COPY --from=build --chown=100:100 /tmp/group \
                                  /tmp/passwd \
                                  /etc/

USER 100:100
ENTRYPOINT ["/nginx"]
CMD ["-g", "daemon off;"]
