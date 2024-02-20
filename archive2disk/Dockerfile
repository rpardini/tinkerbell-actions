# syntax=docker/dockerfile:experimental


# Build stream
FROM golang:1.21-alpine as archive2disk
RUN apk add --no-cache git ca-certificates gcc musl-dev
COPY . /src/archive2disk
WORKDIR /src/archive2disk
ENV GO111MODULE=on
RUN --mount=type=cache,sharing=locked,id=gomod,target=/go/pkg/mod/cache \
    --mount=type=cache,sharing=locked,id=goroot,target=/root/.cache/go-build \
    CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o archive2disk

# Build final image
FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=archive2disk /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=archive2disk /src/archive2disk/archive2disk .
ENTRYPOINT ["/archive2disk"]