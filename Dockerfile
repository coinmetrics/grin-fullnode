FROM rust as builder

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		build-essential \
		clang \
		cmake \
		git \
		libgit2-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libssl-dev \
		llvm \
		pkg-config \
		zlib1g-dev \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN set -ex; \
	git clone --depth=1 --branch=${VERSION} https://github.com/mimblewimble/grin.git /root/grin; \
	cd /root/grin; \
	cargo build --release; \
	true

FROM ubuntu:18.04

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	; \
	rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/grin/target/release/grin /usr/bin/

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner
WORKDIR /home/runner

COPY grin-server.toml /home/runner/grin-server.toml

ENTRYPOINT ["grin"]
