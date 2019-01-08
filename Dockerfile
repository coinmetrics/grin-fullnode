FROM ubuntu:18.04

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION
ARG VERSION_LONG

RUN curl -L https://github.com/mimblewimble/grin/releases/download/v${VERSION}/grin-v${VERSION_LONG}-linux-amd64.tgz | tar -xz -C /usr/bin/

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

ENTRYPOINT ["grin"]
