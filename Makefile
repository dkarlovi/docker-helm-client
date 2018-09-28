ifndef DOCKER_TAG
DOCKER_TAG=2.11.0
endif

build:
	docker build --build-arg "DOCKER_TAG=${DOCKER_TAG}" -t dkarlovi/docker-helm-client:${DOCKER_TAG} .
.PHONY: build
