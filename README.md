<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png width=120px></p>
<h1 align=center>nginx (container image)</h1>
<p align=center>Built-from-source container image of the <a href=https://nginx.org/>NGINX HTTP server</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx):

- [`1.17.0-glibc`, `1.17.0`, `glibc`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.glibc)
- [`1.17.0-musl`, `musl` *(Dockerfile.musl)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.musl)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/nginx-glibc`](https://quay.io/repository/ricardbejarano/nginx-glibc), tags: [`1.17.0`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.glibc)
- [`quay.io/ricardbejarano/nginx-musl`](https://quay.io/repository/ricardbejarano/nginx-musl), tags: [`1.17.0`, `master`, `latest` *(Dockerfile.musl)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.musl)


## Features

* Super tiny (`glibc`-based is `~13.2MB` and `musl`-based is `~12.5MB`)
* Compiled from source during build time
* Built `FROM scratch`, see [Filesystem](#filesystem) for an exhaustive list of the image's contents
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Built with binary exploit mitigations enabled


## Configuration

### Volumes

- Bind your **configuration** at `/etc/nginx/nginx.conf`.


## Building

- To build the `glibc`-based image: `$ docker build -t nginx:glibc -f Dockerfile.glibc .`
- To build the `musl`-based image: `$ docker build -t nginx:musl -f Dockerfile.musl .`


## Filesystem

The images' contents are:

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

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

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Statically linked.

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
├── nginx
└── tmp/
    └── .keep
```


## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
