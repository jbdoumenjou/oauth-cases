FROM golang:1.10.2-alpine3.7 as builder

RUN apk --update upgrade \
&& apk --no-cache --no-progress add git make \
&& rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/jbdoumenjou/oauth-cases
COPY . .

RUN go get -u -v gopkg.in/oauth2.v3/...
RUN make build

FROM alpine:3.7
RUN apk --update upgrade \
    && apk --no-cache --no-progress add ca-certificates git \
    && rm -rf /var/cache/apk/*
COPY --from=builder /go/src/github.com/jbdoumenjou/oauth-cases/server .
COPY --from=builder /go/src/github.com/jbdoumenjou/oauth-cases/static/ ./static

CMD ["./server"]
