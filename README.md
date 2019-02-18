<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png width=120px></p>
<h1 align=center>nginx (Docker image)</h1>
<p align=center>Built-from-source container image of the <a href=https://nginx.org/>NGINX HTTP server</a></p>

Available at [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx).


## Features

* Super tiny (only `18MB`)
* Built from source, including libraries
* Based on `scratch`, see [Filesystem](#Filesystem) for an exhaustive list of the image's contents
* Included [TLS1.3](https://tools.ietf.org/html/rfc8446) protocol support (with [OpenSSL](https://www.openssl.org/))
* Included [brotli](https://github.com/google/brotli) compression support (with [ngx_brotli](https://github.com/google/ngx_brotli))


## Volumes

Mount your **configuration** on the container's `/etc/nginx` folder.

Mount your **web content** on the container's `/etc/nginx/html` folder.


## Filesystem

The image's contents are:

```
/
├── etc/
│   ├── group
│   ├── nginx/
│   │   ├── html/
│   │   │   ├── 50x.html
│   │   │   └── index.html
│   │   ├── mime.types
│   │   └── nginx.conf
│   └── passwd
├── lib/
│   └── x86_64-linux-gnu/
│       ├── ld-2.24.so
│       ├── ld-linux-x86-64.so.2 → ld-2.24.so
│       ├── libc-2.24.so
│       ├── libc.so.6 → libc-2.24.so
│       ├── libnss_files-2.24.so
│       └── libnss_files.so.2 → libnss_files-2.24.so
├── nginx
└── tmp/
```

## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
