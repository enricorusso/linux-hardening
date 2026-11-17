.PHONY=build run download

run:
	sudo podman run -d \
	 --name hardlab \
	 --hostname hardlab \
	 --systemd=always \
	 --privileged \
	 linux-hardening-lab:26.04 \
	 /sbin/init

build:
	sudo podman build --layers -t linux-hardening-lab:26.04 .

download:
	wget https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64-root.tar.xz
