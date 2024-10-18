FROM golang:1.22-alpine AS build
RUN apk add --no-cache git
WORKDIR /workspace
ENV GO111MODULE=on
COPY go.mod go.sum ./
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 go build -o webhook -ldflags '-w -extldflags "-static"' .

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=build /workspace/webhook /usr/local/bin/webhook
ENTRYPOINT ["webhook"]
