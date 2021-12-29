FROM alpine:3.15

WORKDIR /tmp/build
COPY versions .

# Install GNU C library compatibility layer
# The prebuilt amd64 webhook binary is dynamically linked against libc. This is
# because the implementation uses the Go 'net' package which by default prevents
# static linking (see [1]). The particular libc implementation that the binary
# is linked against is glibc (GNU libc). However, Alpine doesn't include glibc
# but only musl libc [2], hence, the binary can't run by default on Alpine
# (see [3,4]). The solution is to install the 'gcompat' package [5] which is a
# compatibilty layer for glibc on top of musl libc. With 'gcompat', binaries
# that are dynamically linked against glibc are able to run on Alpine.
# [1] https://www.arp242.net/static-go.html
# [2] https://musl.libc.org/
# [3] https://wiki.alpinelinux.org/wiki/Running_glibc_programs
# [4] https://github.com/gliderlabs/docker-alpine/issues/219
# [5] https://pkgs.alpinelinux.org/package/edge/community/x86/gcompat
RUN apk add gcompat

# Install webhook
# See https://github.com/adnanh/webhook/releases
RUN wget https://github.com/adnanh/webhook/releases/download/$(awk -F = '/^webhook=/ {print $2}' versions)/webhook-linux-amd64.tar.gz; \
    tar -xzf webhook-linux-amd64.tar.gz; \
    chmod +x webhook-linux-amd64/webhook; \
    mv webhook-linux-amd64/webhook /usr/local/bin

# Install kubectl
# See https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN wget https://dl.k8s.io/release/$(awk -F = '/^kubectl=/ {print $2}' versions)/bin/linux/amd64/kubectl; \
    chmod +x kubectl; \
    mv kubectl /usr/local/bin

# Install additional useful tools
RUN apk add jq

RUN rm -rf /tmp/build
WORKDIR /
