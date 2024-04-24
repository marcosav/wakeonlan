FROM golang:1.13.15-alpine3.12 as builder

WORKDIR /go/src/github.com/mpolden/wakeup
RUN apk --no-cache add bash make gcc libc-dev git

ENV GO111MODULE=on

RUN go get github.com/jessevdk/go-flags@v1.4.0
COPY . /go/src/github.com/mpolden/wakeup

RUN make install

FROM alpine:3.19.1

COPY --from=builder /go/src/github.com/mpolden/wakeup/static /opt/wakeup/static
COPY --from=builder /go/bin /opt/wakeup

RUN touch /opt/wakeup/wakeup-cache

EXPOSE 8080

CMD ["-c" ,"/opt/wakeup/wakeup-cache","-s","/opt/wakeup/static"]
ENTRYPOINT [ "/opt/wakeup/wakeup" ]
