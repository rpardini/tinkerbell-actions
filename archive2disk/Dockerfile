FROM golang:1.21-alpine as archive2disk
RUN apk add --no-cache git ca-certificates gcc musl-dev
COPY . /src
WORKDIR /src/archive2disk
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o archive2disk

FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=archive2disk /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=archive2disk /src/archive2disk/archive2disk /usr/bin/archive2disk
ENTRYPOINT ["/usr/bin/archive2disk"]
