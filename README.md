<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png width=120px></p>
<h1 align=center>nginx (Docker image)</h1>
<p align=center>Built-from-source container image of the <a href=https://nginx.org/>NGINX HTTP server</a></p>

Available at [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx).


## Tags

[`1.15.9-glibc`, `1.15.9`, `glibc`, `latest` *(glibc/Dockerfile)*](https://github.com/ricardbejarano/nginx/blob/master/glibc/Dockerfile)

[`1.15.9-musl`, `musl` *(musl/Dockerfile)*](https://github.com/ricardbejarano/nginx/blob/master/musl/Dockerfile)


## Features

* Super tiny (`glibc`-based is `~13MB` and `musl`-based is `~15.6MB`)
* Built from source, including libraries
* Built from `scratch`, see the [Filesystem](#Filesystem) section below for an exhaustive list of the image's contents
* Included [TLS1.3](https://tools.ietf.org/html/rfc8446) protocol support (with [OpenSSL](https://www.openssl.org/))
* Reduced attack surface (no `bash`, no UNIX tools, no package manager...)


## Filesystem

The images' contents are:

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`.

```
/
├── etc/
│   ├── group/
│   ├── nginx/
│   │   ├── html/
│   │   │   ├── 50x.html
│   │   │   └── index.html
│   │   ├── mime.types
│   │   └── nginx.conf
│   └── passwd
├── lib/
│   └── x86_64-linux-gnu/
│       ├── libc.so.6
│       ├── libcrypt.so.1
│       ├── libdl.so.2
│       ├── libnss_dns.so.2
│       ├── libnss_files.so.2
│       ├── libpthread.so.0
│       └── libresolv.so.2
├── lib64/
│   └── ld-linux-x86-64.so.2
├── nginx
└── tmp/
    └── .keep
```

### `musl`

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`.

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
│   ├── ld-musl-x86_64.so.1
│   └── libssl.so.1.1
├── nginx
└── tmp/
    └── .keep
```


## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
