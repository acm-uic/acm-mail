# Inspired by https://github.com/wodby/opensmtpd/blob/master/Dockerfile

FROM alpine:latest

RUN apk add --no-cache \
    opensmtpd \
    opensmtpd-filter-rspamd

VOLUME /etc/mail
VOLUME /home 

COPY smtpd.conf /etc/mail/smtpd.conf

#EXPOSE 25
EXPOSE 465
EXPOSE 587

ENTRYPOINT ["smtpd", "-dv"]
