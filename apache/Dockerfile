FROM debian:bookworm
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        apache2 libapache2-mod-tile

# LoadTileConfigFile
COPY renderd.conf /etc/renderd.conf

COPY carto.conf /etc/apache2/sites-available/
COPY carto.html /usr/share/renderd/carto/index.html
RUN a2enmod tile && a2ensite carto && \
    mkdir /var/run/apache2 && \
    mkdir -p /var/cache/renderd/tiles

CMD bash -c "source /etc/apache2/envvars && exec apachectl -D FOREGROUND"
