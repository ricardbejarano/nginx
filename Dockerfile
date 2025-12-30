FROM docker.io/alpine:3 AS fetch-openssl
WORKDIR /tmp/openssl
ARG OPENSSL_VERSION="3.5.4"
ADD --checksum=sha256:967311f84955316969bdb1d8d4b983718ef42338639c621ec4c34fddef355e99 https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
RUN tar -xzvf /tmp/openssl.tar.gz --strip-components=1

FROM docker.io/alpine:3 AS fetch-pcre
WORKDIR /tmp/pcre
ARG PCRE_VERSION="10.47"
ADD --checksum=sha256:c08ae2388ef333e8403e670ad70c0a11f1eed021fd88308d7e02f596fcd9dc16 https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE_VERSION/pcre2-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
RUN tar -xzvf /tmp/pcre.tar.gz --strip-components=1

FROM docker.io/alpine:3 AS fetch-zlib
WORKDIR /tmp/zlib
ARG ZLIB_VERSION="1.3.1"
ADD --checksum=sha256:9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23 https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
RUN tar -xzvf /tmp/zlib.tar.gz --strip-components=1

FROM docker.io/alpine:3 AS build
RUN apk add \
      build-base \
      ca-certificates \
      linux-headers \
      perl-dev
WORKDIR /tmp/nginx
ADD --checksum=sha256:c6b5c6b086c0df9d3ca3ff5e084c1d0ef909e6038279c71c1c3e985f576ff76a https://nginx.org/download/nginx-1.28.0.tar.gz /tmp/nginx.tar.gz
RUN tar -xzvf /tmp/nginx.tar.gz --strip-components=1
COPY --from=fetch-openssl /tmp/openssl ./openssl
COPY --from=fetch-pcre /tmp/pcre ./pcre
COPY --from=fetch-zlib /tmp/zlib ./zlib
RUN ./configure \
      --with-cc-opt='-static' \
      --with-ld-opt='-static' \
      --conf-path='/etc/nginx/nginx.conf' \
      --pid-path='/tmp/nginx.pid' \
      --http-log-path='/dev/stdout' \
      --error-log-path='/dev/stderr' \
      --http-client-body-temp-path='/tmp/client_temp' \
      --http-fastcgi-temp-path='/tmp/fastcgi_temp' \
      --http-proxy-temp-path='/tmp/proxy_temp' \
      --http-scgi-temp-path='/tmp/scgi_temp' \
      --http-uwsgi-temp-path='/tmp/uwsgi_temp' \
      --with-select_module \
      --with-poll_module \
      --with-threads \
      --with-file-aio \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_v3_module \
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
      # --with-google_perftools_module \
      --with-cpp_test_module \
      --with-compat \
      --with-openssl='openssl' \
      --with-pcre='pcre' \
      --with-zlib='zlib' \
    && make -j"$(nproc)"
RUN mkdir /rootfs \
    && mkdir /rootfs/bin \
      && cp /tmp/nginx/objs/nginx /rootfs/bin/ \
    && mkdir /rootfs/etc \
      && echo 'nogroup:*:10000:nobody' > /rootfs/etc/group \
      && echo 'nobody:*:10000:10000:::' > /rootfs/etc/passwd \
    && mkdir -p /rootfs/etc/ssl/certs \
      && cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ \
    && mkdir /rootfs/tmp

FROM scratch
COPY --from=build --chown=10000:10000 /rootfs /
USER 10000:10000
ENTRYPOINT ["/bin/nginx"]
CMD ["-g", "daemon off;"]
