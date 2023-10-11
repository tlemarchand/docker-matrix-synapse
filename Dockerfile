FROM python:3.11-bookworm as builder

COPY version /tmp/version

RUN pip install --prefix="/install" --no-warn-script-location matrix-synapse[all]==`cat /tmp/version`


FROM python:3.11-slim-bookworm as app

RUN apt-get update && apt-get install -y libpq5 libicu72 && \
    mkdir /etc/matrix-synapse/ && \
    groupadd -g 600 -r synapse && useradd --no-log-init -u 600 -r -g synapse synapse && \
    rm -rf /var/lib/apt/lists/*
 
COPY --from=builder /install/ /usr/local/
COPY log.config /etc/matrix-synapse/

USER synapse

VOLUME ["/var/lib/matrix-synapse"]

EXPOSE 8008/tcp

CMD ["python","-m","synapse.app.homeserver","--config-path","/etc/matrix-synapse/homeserver.yaml"]