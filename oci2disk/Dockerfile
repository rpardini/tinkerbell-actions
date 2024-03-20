FROM golang:1.21-alpine as oci2disk
RUN apk add --no-cache git ca-certificates gcc linux-headers musl-dev
COPY . /src
WORKDIR /src/oci2disk
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o oci2disk

FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=oci2disk /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=oci2disk /src/oci2disk/oci2disk /oci2disk
ENTRYPOINT ["/oci2disk"]
