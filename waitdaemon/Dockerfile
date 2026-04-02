FROM golang:1.25 AS builder

WORKDIR /code
COPY waitdaemon/go.mod waitdaemon/go.sum /code/
RUN go mod download

COPY waitdaemon/main.go /code
COPY waitdaemon/runtime /code/runtime

RUN CGO_ENABLED=0 go build -o /waitdaemon main.go

FROM alpine AS nerdctl
ARG TARGETARCH
ARG NERDCTL_VERSION=2.2.1
RUN apk add --no-cache curl tar gzip && \
    curl -fsSL "https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${TARGETARCH}.tar.gz" \
    | tar -xzC /usr/local/bin nerdctl

FROM alpine
RUN apk add --no-cache util-linux
COPY --from=builder /waitdaemon /waitdaemon
COPY --from=nerdctl /usr/local/bin/nerdctl /usr/local/bin/nerdctl

ENTRYPOINT [ "/waitdaemon" ]
