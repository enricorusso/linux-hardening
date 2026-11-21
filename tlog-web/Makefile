PODMAN := sudo podman

WEB_IMAGE := ghcr.io/enricorusso/tlog-web:latest 
WEB_CONTAINER := tlog-web
UBUNTU_IMAGE := ghcr.io/enricorusso/linux-hardening:ubuntu26.04
UBUNTU_CONTAINER := tlog-ubuntu

ENV_FILE := tlog-web.env

.PHONY: build cretevols up down deletevols delete

build:
	$(PODMAN) build -t $(WEB_IMAGE) .

createvols:
	$(PODMAN) volume create --ignore tlog-logs
	$(PODMAN) volume create --ignore tlog-web-data

up: cretevols
	@test -f "$(ENV_FILE)" || { echo "Missing $(ENV_FILE)"; exit 1; }
	$(PODMAN) run -d \
		--name $(UBUNTU_CONTAINER) \
		--hostname tlog-ubuntu \
		--privileged \
		--systemd=always \
		-v tlog-logs:/var/log/tlog \
		-v "$(CURDIR)/tlog-rec-session.conf:/etc/tlog/tlog-rec-session.conf:ro" \
		$(UBUNTU_IMAGE)
	$(PODMAN) run -d \
		--name $(WEB_CONTAINER) \
		--env-file $(ENV_FILE) \
		-p 8080:8080 \
		-v tlog-logs:/var/log/tlog:ro \
		-v tlog-web-data:/data \
		$(WEB_IMAGE)

down:
	$(PODMAN) stop --ignore $(WEB_CONTAINER) $(UBUNTU_CONTAINER)

delete: down
	$(PODMAN) rm --ignore $(WEB_CONTAINER) $(UBUNTU_CONTAINER)

deletevols: delete
	$(PODMAN) volume rm --ignore tlog-logs tlog-web-data
