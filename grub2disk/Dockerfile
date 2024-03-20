FROM golang:1.21-alpine as grub2disk
RUN apk add --no-cache grub git ca-certificates gcc musl-dev
COPY . /src
WORKDIR /src/grub2disk
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o grub2disk

FROM scratch
COPY --from=grub2disk /src/grub2disk/grub2disk /grub2disk
ENTRYPOINT ["/grub2disk"]
