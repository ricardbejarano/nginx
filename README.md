<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/gear_2699.png width=120px></p>
<h1 align=center>nginx (Docker image)</h1>
<p align=center>Built-from-source container image of the <a href=https://nginx.org/>NGINX HTTP server</a></p>

Available at [`ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx).


## Tags

[`1.15.10-glibc`, `1.15.10`, `glibc`, `latest` *(glibc/Dockerfile)*](https://github.com/ricardbejarano/nginx/blob/master/glibc/Dockerfile)

[`1.15.10-musl`, `musl` *(musl/Dockerfile)*](https://github.com/ricardbejarano/nginx/blob/master/musl/Dockerfile)


## Features

* Super tiny (`glibc`-based is `~13.2MB` and `musl`-based is `~12.5MB`)
* Built from source, including libraries
* Built `FROM scratch`, see the [Filesystem](#Filesystem) section below for an exhaustive list of the image's contents
* Included [TLS1.3](https://tools.ietf.org/html/rfc8446) protocol support (with [OpenSSL](https://www.openssl.org/))
* Reduced attack surface (no `bash`, no UNIX tools, no package manager...)
* Built with exploit mitigations enabled (see [Security](#Security))


## Building

To build the `glibc`-based image:

```bash
$ git clone https://github.com/ricardbejarano/nginx
$ cd nginx
$ docker build -t nginx:glibc -f glibc/Dockerfile .
```

To build the `musl`-based image:

```bash
$ git clone https://github.com/ricardbejarano/nginx
$ cd nginx
$ docker build -t nginx:musl -f musl/Dockerfile .
```


## Security

This image attempts to build a secure NGINX Docker image.

It does so by the following ways:

- downloading and verifying the source code of NGINX and every library it is built with,
- packaging the image with only those files required during runtime (see [Filesystem](#Filesystem)),
- by enforcing a series of exploit mitigations (PIE, full RELRO, full SSP, NX and Fortify)

### Verifying the presence of exploit mitigations

To check whether a binary in a Docker image has those mitigations enabled, use [tests/checksec.sh](https://github.com/ricardbejarano/nginx/blob/master/tests/checksec.sh).

#### Usage

```
usage: checksec.sh docker_image executable_path

Docker-based wrapper for checksec.sh.
Requires a running Docker daemon.

Example:

  $ checksec.sh ricardbejarano/nginx:glibc /nginx

  Extracts the '/nginx' binary from the 'ricardbejarano/nginx:glibc' image,
  downloads checksec (github.com/slimm609/checksec.sh) and runs it on the
  binary.
  Everything runs inside Docker containers.
```

#### Example:

Testing the `/nginx` binary in `ricardbejarano/nginx:glibc`:

```
$ bash tests/checksec.sh ricardbejarano/nginx:glibc /nginx
Downloading ricardbejarano/nginx:glibc...Done!
Extracting ricardbejarano/nginx:glibc:/nginx...Done!
Downloading checksec.sh...Done!
Running checksec.sh:
RELRO        STACK CANARY   NX           PIE           RPATH      RUNPATH      Symbols         FORTIFY   Fortified   Fortifiable   FILE
Full RELRO   Canary found   NX enabled   PIE enabled   No RPATH   No RUNPATH   11563 Symbols   Yes       0           34            /tmp/.checksec-ui8eKi3Q
Cleaning up...Done!
```

This wrapper script works with any binary in a Docker image. Feel free to use it with any other image.

Other examples:

- `bash tests/checksec.sh debian /bin/bash`
- `bash tests/checksec.sh alpine /bin/sh`
- `bash tests/checksec.sh nginx /usr/sbin/nginx`


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
├── nginx
└── tmp/
    └── .keep
```


## License

See [LICENSE](https://github.com/ricardbejarano/nginx/blob/master/LICENSE).
