FROM alpine

RUN apk update \
    && apk add iptables

COPY add_files/start.sh /
COPY add_files/iptables-nat.sh /

RUN chmod u+x /start.sh /iptables-nat.sh

ENTRYPOINT [ "/start.sh" ]
