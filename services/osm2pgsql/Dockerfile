FROM scratch AS openstreetmap-carto
ADD https://github.com/osmItalia/openstreetmap-carto.git#name_it_lua /openstreetmap-carto

FROM iboates/osm2pgsql:2.1.1
RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add bash postgresql17-client

WORKDIR /app
COPY entrypoint.sh sync.sh init.sh ./
COPY --from=openstreetmap-carto /openstreetmap-carto/functions.sql ./
COPY --from=openstreetmap-carto /openstreetmap-carto/openstreetmap-carto-flex.lua ./

ENV REPLICATION_URL "https://planet.openstreetmap.org/replication/hour/"

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./sync.sh"]
