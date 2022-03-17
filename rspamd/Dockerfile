# Inspired from https://github.com/Mailu/Mailu/blob/master/core/rspamd/Dockerfile
# TODO NEED ENVIRON REDIS ADDRESS

FROM alpine:latest

RUN apk add --no-cache rspamd ca-certificates

VOLUME ["/var/lib/rspamd"]

# COPY ./rspamd.conf /config

EXPOSE 11332/tcp 11334/tcp 11335/tcp

ENTRYPOINT ["rspamd", "-i", "-f"]
