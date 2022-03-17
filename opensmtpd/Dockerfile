# Inspired by https://github.com/wodby/opensmtpd/blob/master/Dockerfile

FROM alpine:latest

RUN apk add --no-cache \
    opensmtpd \
    opensmtpd-filter-rspamd

VOLUME /etc/mail
VOLUME /home 

EXPOSE [25, 465, 587]

ENTRYPOINT ["smtpd", "-dv"]
