FROM alpine:3 AS build

ARG VERSION="1.23.0"
ARG CHECKSUM="820acaa35b9272be9e9e72f6defa4a5f2921824709f8aa4772c78ab31ed94cd1"

ARG OPENSSL_VERSION="1.1.1o"
ARG OPENSSL_CHECKSUM="9384a2b0570dd80358841464677115df785edb941c71211f75076d72fe6b438f"

ARG ZLIB_VERSION="1.2.12"
ARG ZLIB_CHECKSUM="91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9"

ADD https://nginx.org/download/nginx-$VERSION.tar.gz /tmp/nginx.tar.gz
ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
ADD https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz

RUN [ "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    [ "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" = "$OPENSSL_CHECKSUM" ] && \
    [ "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" = "$ZLIB_CHECKSUM" ] && \
    apk add build-base ca-certificates gcc linux-headers pcre-dev perl && \
    tar -C /tmp -xf /tmp/nginx.tar.gz && \
    tar -C /tmp -xf /tmp/openssl.tar.gz && \
    tar -C /tmp -xf /tmp/zlib.tar.gz && \
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
        --with-openssl="/tmp/openssl-$OPENSSL_VERSION" \
        --with-zlib="/tmp/zlib-$ZLIB_VERSION" && \
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
