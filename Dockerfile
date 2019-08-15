FROM python:3.7-buster as builder

COPY version /tmp/version

RUN pip install --prefix="/install" --no-warn-script-location matrix-synapse[all]==`cat /tmp/version`


FROM python:3.7-slim-buster as app

RUN mkdir /etc/matrix-synapse/
RUN groupadd -r synapse && useradd --no-log-init -r -g synapse synapse

COPY --from=builder /install/ /usr/local/
COPY log.config /etc/matrix-synapse/

USER synapse

VOLUME ["/var/lib/matrix-synapse"]

EXPOSE 8008/tcp 8009/tcp 8448/tcp

CMD ["python","-m","synapse.app.homeserver","--config-path","/etc/matrix-synapse/homeserver.yaml"]