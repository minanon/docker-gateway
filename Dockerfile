FROM alpine

RUN apk update \
    && apk add iptables

COPY add_files/start.sh /
COPY add_files/iptables.sh /

ENTRYPOINT [ "/start.sh" ]
