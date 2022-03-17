# Inspired by https://github.com/wodby/opensmtpd/blob/master/Dockerfile

FROM alpine:latest

RUN apk add --no-cache \
    opensmtpd \
    rspamd \
    opensmtpd-filter-rspamd \
    redis


VOLUME /etc/mail
VOLUME /etc/rsmapd
VOLUME /var/spool/smtpd

ENTRYPOINT ["./docker-entrypoint.sh"]
