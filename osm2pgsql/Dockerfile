FROM debian:bookworm

RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        osm2pgsql \
        postgresql-client `# pg_isready` \
        wget `# fetch initial data`

WORKDIR /app
COPY entrypoint.sh sync.sh ./
ADD https://raw.githubusercontent.com/osmItalia/openstreetmap-carto/name_it/openstreetmap-carto.lua ./
ADD https://raw.githubusercontent.com/osmItalia/openstreetmap-carto/name_it/openstreetmap-carto.style ./

ENV REPLICATION_URL "https://planet.openstreetmap.org/replication/hour/"

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./sync.sh"]
