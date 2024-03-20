FROM golang:1.21-alpine as writefile
RUN apk add --no-cache git ca-certificates gcc musl-dev
COPY . /src
WORKDIR /src/writefile
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o writefile

FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls
COPY --from=writefile /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=writefile /src/writefile/writefile /writefile
ENTRYPOINT ["/writefile"]
