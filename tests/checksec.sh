#!/bin/bash

usage() {
	echo "usage: checksec.sh docker_image executable_path"
	echo ""
	echo "Container-based wrapper for checksec.sh."
	echo "Requires a running Docker daemon."
	echo ""
	echo "Example:"
	echo ""
	echo "  $ checksec.sh ricardbejarano/nginx:glibc /nginx"
	echo ""
	echo "  Extracts the '/nginx' binary from the 'ricardbejarano/nginx:glibc' image,"
	echo "  downloads checksec (github.com/slimm609/checksec.sh) and runs it on the"
	echo "  binary."
	echo "  Everything runs inside containers."
	exit 1
}

checksec() {
	printf "Downloading %s..." "$1"
	docker pull "$1" >/dev/null
	echo "Done!"

	printf "Extracting %s:%s..." "$1" "$2"
	image_container="$(docker create "$1")"
	executable_file="$(mktemp .checksec-XXXXXXXX)"
	docker cp "$image_container":"$2" "$executable_file"
	docker rm "$image_container" >/dev/null
	echo "Done!"

	printf "Downloading checksec.sh..."
	docker run \
		--interactive \
		--tty \
		--rm \
		--volume "$PWD/$executable_file:/tmp/$executable_file" \
		debian \
			bash \
				-c "\
					apt update &>/dev/null && \
					apt install -y curl file procps binutils openssl &>/dev/null && \
					curl \
						--silent \
						--show-error \
						--output /bin/checksec \
						https://raw.githubusercontent.com/slimm609/checksec.sh/master/checksec && \
					chmod +x /bin/checksec && \
					echo 'Done!' && \
					echo 'Running checksec.sh:' && \
					checksec -f /tmp/$executable_file"

	printf "Cleaning up..."
	rm -f "$executable_file"
	echo "Done!"

	exit 0
}

if [ -z "$2" ]; then usage; fi
checksec "$1" "$2"
