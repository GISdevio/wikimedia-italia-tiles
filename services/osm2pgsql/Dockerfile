FROM scratch AS openstreetmap-carto
ADD https://github.com/osmItalia/openstreetmap-carto.git#name_it_lua /openstreetmap-carto
ADD https://github.com/osmItalia/openstreetmap-hiking.git#master /openstreetmap-hiking

FROM iboates/osm2pgsql:2.2.0
RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add postgresql17-client

WORKDIR /app
COPY entrypoint.sh sync.sh init.sh all_styles.lua ./
COPY --from=openstreetmap-carto /openstreetmap-carto/functions.sql ./
COPY --from=openstreetmap-carto /openstreetmap-carto/openstreetmap-carto-flex.lua ./
COPY --from=openstreetmap-carto /openstreetmap-hiking/scripts/route.lua ./

ENV REPLICATION_URL "https://planet.openstreetmap.org/replication/hour/"

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./sync.sh"]
