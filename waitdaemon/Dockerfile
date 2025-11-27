FROM golang:1.23-alpine AS waitdaemon
WORKDIR /src
COPY waitdaemon/go.mod waitdaemon/go.sum /src/
RUN go mod download
COPY waitdaemon/main.go /src/
RUN ls -la
RUN go build -a -o waitdaemon

FROM scratch
COPY --from=waitdaemon /src/waitdaemon /waitdaemon
ENTRYPOINT ["/waitdaemon"]
