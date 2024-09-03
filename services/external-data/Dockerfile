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
COPY --from=openstreetmap-carto /scripts/get-external-data.py /scripts/indexes.py ./scripts/
COPY --from=openstreetmap-carto /external-data.yml /indexes.yml ./

COPY entrypoint.sh run.sh ./
ENTRYPOINT ["./entrypoint.sh"]

# --no-update
CMD ["./run.sh"]