<div align="center">
	<p><img src="https://em-content.zobj.net/thumbs/160/apple/391/eagle_1f985.png" width="100px"></p>
	<h1>nginx</h1>
	<p>Built-from-source container image of <a href="https://nginx.org/">NGINX</a></p>
	<code>docker pull quay.io/ricardbejarano/nginx</code>
</div>


## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Tags

### Docker Hub

Available on Docker Hub as [`docker.io/ricardbejarano/nginx`](https://hub.docker.com/r/ricardbejarano/nginx):

- [`1.27.3`, `latest` *(Dockerfile)*](Dockerfile)

### RedHat Quay

Available on RedHat Quay as [`quay.io/ricardbejarano/nginx`](https://quay.io/repository/ricardbejarano/nginx):

- [`1.27.3`, `latest` *(Dockerfile)*](Dockerfile)


## Configuration

### Volumes

- Mount your **configuration** at `/etc/nginx/nginx.conf`.
