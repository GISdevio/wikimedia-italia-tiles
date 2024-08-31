FROM scratch AS openstreetmap-carto
ADD https://github.com/osmItalia/openstreetmap-carto.git#name_it_updated /openstreetmap-carto

FROM iboates/osm2pgsql:1.11.0
RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add bash postgresql16-client

WORKDIR /app
COPY entrypoint.sh sync.sh ./
COPY --from=openstreetmap-carto /openstreetmap-carto/openstreetmap-carto.lua ./
COPY --from=openstreetmap-carto /openstreetmap-carto/openstreetmap-carto.style ./

ENV REPLICATION_URL "https://planet.openstreetmap.org/replication/hour/"

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./sync.sh"]
