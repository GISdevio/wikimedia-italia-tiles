FROM node:24-slim AS cartocss
RUN --mount=type=cache,target=/root/.npm \
    npm install -g carto

FROM cartocss AS style_carto
COPY styles/osmita-carto /openstreetmap-carto
WORKDIR /openstreetmap-carto
RUN carto project.mml > project.xml

FROM cartocss AS style_hiking
COPY styles/osmita-hiking /openstreetmap-hiking
WORKDIR /openstreetmap-hiking
RUN carto project.mml > project.xml

FROM debian:forky
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
        xmlstarlet \
        libjemalloc2
WORKDIR /styles
COPY --from=style_carto /openstreetmap-carto/project.xml ./carto/
COPY --from=style_carto /openstreetmap-carto/symbols ./carto/symbols
COPY --from=style_carto /openstreetmap-carto/patterns ./carto/patterns
COPY --from=style_hiking /openstreetmap-hiking/project.xml ./hiking/
COPY --from=style_hiking /openstreetmap-hiking/symbols ./hiking/symbols/
COPY web/renderd/entrypoint.sh ./
COPY web/common/renderd.conf /etc/renderd.conf

ENTRYPOINT ["./entrypoint.sh"]

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
CMD ["renderd", "-f"]
