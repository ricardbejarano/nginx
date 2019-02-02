<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png width=120px></p>
<h1 align=center>nginx (Docker image)</h1>
<p align=center>Built-from-source container image of the <a href=https://nginx.org/>NGINX HTTP server</a></p>

Available at [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx).


## Features

* Super tiny (only `13MB`)
* Built from source, including libraries
* Based on the official `gcr.io/distroless/base` image
* Included [TLS1.3](https://tools.ietf.org/html/rfc8446) protocol support (with [OpenSSL](https://www.openssl.org/))
* Included [brotli](https://github.com/google/brotli) compression support (with [ngx_brotli](https://github.com/google/ngx_brotli))


## Volumes

Mount your **configuration** on the container's `/etc/nginx` folder.

Mount your **content** on the container's `/etc/nginx/html` folder.


## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
