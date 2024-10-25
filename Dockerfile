FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl

ARG KUBECTL_VERSION=v1.26.0
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then \
        curl -LO https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/arm64/kubectl; \
    else \
        curl -LO https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl; \
    fi && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ENTRYPOINT []
