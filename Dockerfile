FROM alpine:3 AS build

ARG VERSION="1.19.6"
ARG CHECKSUM="b11195a02b1d3285ddf2987e02c6b6d28df41bb1b1dd25f33542848ef4fc33b5"

ARG OPENSSL_VERSION="1.1.1i"
ARG OPENSSL_CHECKSUM="e8be6a35fe41d10603c3cc635e93289ed00bf34b79671a3a4de64fcee00d5242"

ARG PCRE_VERSION="8.44"
ARG PCRE_CHECKSUM="aecafd4af3bd0f3935721af77b889d9024b2e01d96b58471bd91a3063fb47728"

ARG ZLIB_VERSION="1.2.11"
ARG ZLIB_CHECKSUM="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

ADD https://nginx.org/download/nginx-$VERSION.tar.gz /tmp/nginx.tar.gz
ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
ADD https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
ADD https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz

RUN [ "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" = "$OPENSSL_CHECKSUM" ] && \
    [ "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" = "$PCRE_CHECKSUM" ] && \
    [ "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" = "$ZLIB_CHECKSUM" ] && \
    [ "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add build-base ca-certificates linux-headers perl && \
    tar -C /tmp -xf /tmp/openssl.tar.gz && \
    tar -C /tmp -xf /tmp/pcre.tar.gz && \
    tar -C /tmp -xf /tmp/zlib.tar.gz && \
    tar -C /tmp -xf /tmp/nginx.tar.gz && \
    cd /tmp/nginx-$VERSION && \
      ./configure \
        --with-cc-opt="-static" \
        --with-ld-opt="-static" \
        --with-cpu-opt="generic" \
        --sbin-path="/bin/nginx" \
        --conf-path="/etc/nginx/nginx.conf" \
        --pid-path="/tmp/nginx.pid" \
        --http-log-path="/dev/stdout" \
        --error-log-path="/dev/stderr" \
        --http-client-body-temp-path="/tmp/client_temp" \
        --http-fastcgi-temp-path="/tmp/fastcgi_temp" \
        --http-proxy-temp-path="/tmp/proxy_temp" \
        --http-scgi-temp-path="/tmp/scgi_temp" \
        --http-uwsgi-temp-path="/tmp/uwsgi_temp" \
        --with-select_module \
        --with-poll_module \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        # --with-http_xslt_module \
        # --with-http_image_filter_module \
        # --with-http_geoip_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        # --with-http_perl_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        # --with-stream_geoip_module \
        --with-stream_ssl_preread_module \
        --with-compat \
        --with-pcre="/tmp/pcre-$PCRE_VERSION" \
        --with-zlib="/tmp/zlib-$ZLIB_VERSION" \
        --with-openssl="/tmp/openssl-$OPENSSL_VERSION" && \
      make

RUN mkdir -p /rootfs/bin && \
      cp /tmp/nginx-$VERSION/objs/nginx /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/nginx && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ && \
    mkdir -p /rootfs/tmp


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
ENTRYPOINT ["/bin/nginx"]
CMD ["-g", "daemon off;"]
