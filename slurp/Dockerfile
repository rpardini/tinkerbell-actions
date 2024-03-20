FROM golang:1.21-alpine as slurp
RUN apk add --no-cache git ca-certificates gcc linux-headers musl-dev
COPY . /src
WORKDIR /src/slurp
ENV GO111MODULE=on
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o slurp

FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=slurp /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=slurp /src/slurp/slurp /slurp
ENTRYPOINT ["/slurp"]
