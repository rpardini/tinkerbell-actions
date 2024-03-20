FROM golang:1.21-alpine as image2disk
RUN apk add --no-cache git ca-certificates gcc linux-headers musl-dev
COPY . /src
WORKDIR /src/image2disk
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o image2disk
RUN ls -la image2disk

FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=image2disk /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=image2disk /src/image2disk/image2disk /image2disk
ENTRYPOINT ["/image2disk"]
