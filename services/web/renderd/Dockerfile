FROM node:22-slim AS cartocss
RUN --mount=type=cache,target=/root/.npm \
    npm install -g carto

FROM cartocss AS style_carto
ADD https://github.com/osmItalia/openstreetmap-carto.git#name_it_updated /openstreetmap-carto
WORKDIR /openstreetmap-carto
RUN carto project.mml > project.xml

FROM cartocss AS style_hiking
ADD https://github.com/osmItalia/openstreetmap-hiking.git#master /openstreetmap-hiking
WORKDIR /openstreetmap-hiking
RUN carto project.mml > project.xml

#FROM nixery.dev/shell/apachehttpdpackages.mod_tile/xmlstarlet # Received request for map layer 'carto' which failed to load
FROM debian:bookworm
RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        renderd \
        fonts-hanazono fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-unifont \
        postgresql-client \
        xmlstarlet
WORKDIR /styles
COPY --from=style_carto /openstreetmap-carto/project.xml ./carto/
COPY --from=style_carto /openstreetmap-carto/symbols ./carto/symbols
COPY --from=style_carto /openstreetmap-carto/patterns ./carto/patterns
COPY --from=style_hiking /openstreetmap-hiking/project.xml ./hiking/
COPY --from=style_hiking /openstreetmap-hiking/symbols ./hiking/symbols/
COPY renderd/entrypoint.sh ./
COPY common/renderd.conf /etc/renderd.conf

ENTRYPOINT ["./entrypoint.sh"]

CMD ["renderd", "-f"]
