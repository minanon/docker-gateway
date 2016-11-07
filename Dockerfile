FROM alpine

RUN apk update \
    && apk add iptables

COPY add_files/start.sh /

ENTRYPOINT [ "/start.sh" ]
