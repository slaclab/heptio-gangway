FROM golang:1.14.2-stretch
WORKDIR /go/src/github.com/heptiolabs/gangway

RUN GO111MODULE=on go get github.com/mjibson/esc@v0.2.0 golang.org/x/tools@8dcb7bc8c7fe0a895995c76c721cef79419ac98a
COPY . .
RUN esc -o cmd/gangway/bindata.go templates/

ENV GO111MODULE on
RUN go mod verify
RUN CGO_ENABLED=0 GOOS=linux go install -ldflags="-w -s" -v github.com/heptiolabs/gangway/...

FROM debian:12-slim
RUN apt-get update && apt-get install -y ca-certificates
USER 1001:1001
COPY --from=0 /go/bin/gangway /bin/gangway
