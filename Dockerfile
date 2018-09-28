ARG ALPINE=3.8
FROM alpine:${ALPINE} AS fetcher
RUN apk add  --no-cache \
        bash \
        ca-certificates \
        coreutils \
        git \
        wget
ARG DOCKER_TAG
RUN wget https://storage.googleapis.com/kubernetes-release/release/$(wget -qO - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod 755 kubectl
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${DOCKER_TAG}-linux-amd64.tar.gz \
    && wget https://storage.googleapis.com/kubernetes-helm/helm-v${DOCKER_TAG}-linux-amd64.tar.gz.sha256 \
    && echo $(cat helm-v${DOCKER_TAG}-linux-amd64.tar.gz.sha256) helm-v${DOCKER_TAG}-linux-amd64.tar.gz | sha256sum -c \
    && tar -zxvf helm-v${DOCKER_TAG}-linux-amd64.tar.gz
ENV HELM_HOME /helm
RUN mkdir -p ${HELM_HOME}/plugins && /linux-amd64/helm plugin install https://github.com/databus23/helm-diff --version master

FROM alpine:${ALPINE}
ENV HELM_HOME /helm
COPY --from=fetcher /kubectl /linux-amd64/helm /usr/bin/
COPY --from=fetcher /helm /helm

CMD ["/usr/bin/helm"]
