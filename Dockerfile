FROM jasonchw/alpine-consul

ARG KIBANA_VER=4.5.4
ARG KIBANA_URL=https://download.elastic.co/kibana/kibana
ARG KIBANA_PLATFORM=linux-x64

ENV LANG=C.UTF-8 

RUN apk update && apk upgrade && \
    apk add nodejs && \
    curl -Lfso /tmp/kibana.tar.gz ${KIBANA_URL}/kibana-${KIBANA_VER}-${KIBANA_PLATFORM}.tar.gz && \
    tar xzf /tmp/kibana.tar.gz -C /opt/ && \
    mv /opt/kibana-${KIBANA_VER}-${KIBANA_PLATFORM} /opt/kibana && \
    rm -rf /opt/kibana/node/ && \
    mkdir -p /opt/kibana/node/bin/ && \
    ln -s $(which node) /opt/kibana/node/bin/node && \
    rm -rf /var/cache/apk/* /tmp/* && \
    rm /etc/consul.d/consul-ui.json && \
    addgroup kibana && \
    adduser -S -G kibana kibana && \
    mkdir -p /var/log/kibana/ 

# consul
COPY etc/consul.d/kibana.json /etc/consul.d/

# logrotate
COPY ./kibana-logrotate       /etc/logrotate.d/kibana

# startup scripts
COPY docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
COPY start-kibana.sh          /usr/local/bin/start-kibana.sh
COPY healthcheck.sh           /usr/local/bin/healthcheck.sh

RUN chown -R kibana:kibana /opt/kibana/ && \
    chown -R kibana:kibana /var/log/kibana/ && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/start-kibana.sh && \
    chmod +x /usr/local/bin/healthcheck.sh && \
    chmod 644 /etc/logrotate.d/kibana

EXPOSE 5601

ENTRYPOINT ["docker-entrypoint.sh"]

HEALTHCHECK --interval=5s --timeout=5s --retries=300 CMD /usr/local/bin/healthcheck.sh

