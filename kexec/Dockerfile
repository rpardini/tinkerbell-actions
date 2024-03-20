FROM golang:1.21-alpine as kexec
RUN apk add --no-cache git ca-certificates gcc linux-headers musl-dev
COPY . /src
WORKDIR /src/kexec
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o kexec

FROM scratch
COPY --from=kexec /src/kexec/kexec /kexec
ENTRYPOINT ["/kexec"]
