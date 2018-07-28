
ARG IMAGE_ARG_IMAGE_TAG

FROM postgres:${IMAGE_ARG_IMAGE_TAG:-9.6.9-alpine} as base

# see https://github.com/docker-library/postgres/blob/34689e2a5ba1841fb09fd5a9c29ef47a022d48dc/9.6/alpine/Dockerfile


FROM scratch

ARG IMAGE_ARG_ALPINE_MIRROR

COPY --from=base / /

RUN set -ex \
  && if [ -f /etc/alpine-release ]; then \
       sed -E -i "s#[0-9a-z-]+\.alpinelinux\.org#${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}#g" /etc/apk/repositories; \
       apk upgrade --update; \
       apk add --no-cache shadow; \
       rm -rf /tmp/* /var/cache/apk/*; \
     fi \
  && usermod -u 1000  postgres \
  && groupmod -g 1000 postgres \
  && chown -hR postgres:postgres /var/lib/postgresql \
  && rm -rf /tmp/* /var/cache/apk/*

COPY ./init_database_for_sonarqube.sh /docker-entrypoint-initdb.d/init_database_for_sonarqube.sh
RUN chmod 755 /docker-entrypoint-initdb.d/init_database_for_sonarqube.sh

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]