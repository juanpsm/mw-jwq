# Run the tests on an old bash:
#   docker build --build-arg BASH_VERSION=3.2 -t mw-jwq-bash tests/docker
#   docker run --rm -v "$PWD":/w -w /w mw-jwq-bash bats tests
ARG BASH_VERSION=3.2
FROM bash:${BASH_VERSION}
RUN apk add --no-cache jq git coreutils util-linux ncurses \
 && git clone --depth 1 --branch v1.14.0 https://github.com/bats-core/bats-core.git /bats \
 && /bats/install.sh /usr/local
