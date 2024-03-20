FROM alpine:3 as builder
RUN apk add --no-cache qemu-img ca-certificates
RUN cp -v /usr/bin/qemu-img /bin/qemu-img

FROM golang:1.21-alpine as qemuimg2disk
COPY . /src
WORKDIR /src/qemuimg2disk
RUN go mod tidy
RUN go build -o qemuimg2disk .

# Collect all the files we need into a scratch image.
FROM scratch as collect
COPY --from=builder /bin/qemu-img /bin/qemu-img
COPY --from=builder /bin/sh /bin/sh
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /lib/ld-musl*  /lib/
COPY --from=qemuimg2disk /src/qemuimg2disk/qemuimg2disk /usr/bin/qemuimg2disk
COPY --from=qemuimg2disk /src/qemuimg2disk/entrypoint.sh /usr/bin/entrypoint.sh

# Flatten the collection into a minimal layer set.
FROM scratch
COPY --from=collect / /
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
