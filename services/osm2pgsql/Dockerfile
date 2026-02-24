FROM docker.io/iboates/osm2pgsql:2.2.0
RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add postgresql18-client gdal-tools gdal-driver-pg
RUN --mount=type=cache,sharing=locked,target=/root/.cache/pip \
    pip install pyyaml

WORKDIR /app
COPY osm2pgsql/entrypoint.sh osm2pgsql/sync.sh osm2pgsql/init.sh osm2pgsql/all_styles.lua ./

COPY styles/osmita-carto/scripts/get-external-data.py \
     styles/osmita-carto/scripts/indexes.py \
     ./osmita-carto/scripts/
COPY styles/osmita-carto/external-data.yml \
     styles/osmita-carto/functions.sql \
     styles/osmita-carto/openstreetmap-carto-flex.lua \
     styles/osmita-carto/indexes.yml \
      ./osmita-carto/

COPY styles/osmita-hiking/scripts/route.lua \
     styles/osmita-hiking/scripts/db_function.sql \
     styles/osmita-hiking/scripts/indexes.sql \
     styles/osmita-hiking/scripts/triggers.sql \
        ./osmita-hiking/scripts/

ENV REPLICATION_URL "https://planet.openstreetmap.org/replication/hour/"

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./sync.sh"]
