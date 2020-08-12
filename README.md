<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png" width="120px"></p>
<h1 align="center">nginx (container image)</h1>
<p align="center">Built-from-source container image of the <a href="https://nginx.org/">NGINX HTTP server</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx):

- [`1.19.2-glibc`, `1.19.2`, `glibc`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.glibc) (about `14MB`)
- [`1.19.2-musl`, `musl` *(Dockerfile.musl)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.musl) (about `12.3MB`)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/nginx`](https://quay.io/repository/ricardbejarano/nginx), [`quay.io/ricardbejarano/nginx-glibc`](https://quay.io/repository/ricardbejarano/nginx-glibc), tags: [`1.19.2`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.glibc) (about `14MB`)
- [`quay.io/ricardbejarano/nginx-musl`](https://quay.io/repository/ricardbejarano/nginx-musl), tags: [`1.19.2`, `master`, `latest` *(Dockerfile.musl)*](https://github.com/ricardbejarano/nginx/blob/master/Dockerfile.musl) (about `12.3MB`)


## Features

* Super tiny (see [Tags](#tags))
* Compiled from source (with binary exploit mitigations) during build time
* Built `FROM scratch`, with zero bloat (see [Filesystem](#filesystem))
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Configuration

### Volumes

- Mount your **configuration** at `/etc/nginx/nginx.conf`.


## Building

- To build the `glibc`-based image: `$ docker build -t nginx:glibc -f Dockerfile.glibc .`
- To build the `musl`-based image: `$ docker build -t nginx:musl -f Dockerfile.musl .`


## Filesystem

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

```
/
├── etc/
│   ├── group
│   ├── passwd
│   └── ssl/
│       └── certs/
│           └── ca-certificates.crt
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
```

### `musl`

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Statically linked.

```
/
├── etc/
│   ├── group
│   ├── passwd
│   └── ssl/
│       └── certs/
│           └── ca-certificates.crt
├── nginx
└── tmp/
```


## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
