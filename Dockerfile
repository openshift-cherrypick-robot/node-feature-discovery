FROM registry.svc.ci.openshift.org/ocp/builder:rhel-8-golang-1.15-openshift-4.7 AS builder
WORKDIR /go/node-feature-discovery
COPY . .

ARG VERSION=v0.7.0
ARG HOSTMOUNT_PREFIX=/host-
RUN make install VERSION=${VERSION} HOSTMOUNT_PREFIX=${HOSTMOUNT_PREFIX}

FROM registry.svc.ci.openshift.org/ocp/4.7:base

# Use more verbose logging of gRPC
ENV GRPC_GO_LOG_SEVERITY_LEVEL="INFO"

COPY --from=builder /go/node-feature-discovery/nfd-worker.conf.example /etc/kubernetes/node-feature-discovery/nfd-worker.conf
COPY --from=builder /go/bin/* /usr/bin/
