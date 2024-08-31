FROM scratch AS openstreetmap-carto
ADD https://github.com/osmItalia/openstreetmap-carto.git#name_it_updated /

FROM debian:bookworm
RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        python3 python3-psycopg2 python3-yaml python3-requests \
        gdal-bin \
        postgresql-client
WORKDIR /app
COPY --from=openstreetmap-carto /scripts/get-external-data.py ./
COPY --from=openstreetmap-carto /external-data.yml ./

COPY entrypoint.sh ./
ENTRYPOINT ["./entrypoint.sh"]

# --no-update
CMD exec python3 get-external-data.py --cache --data /data -H postgres -d osm -U osm -w test_password