FROM debian:forky
RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        apache2 libapache2-mod-tile

# LoadTileConfigFile
COPY common/renderd.conf /etc/renderd.conf

COPY apache/carto.conf /etc/apache2/sites-available/000-default.conf
COPY apache/index.html /var/www/html/index.html
COPY apache/entrypoint.sh /entrypoint.sh
RUN a2enmod tile && a2ensite 000-default && \
    a2enmod setenvif headers remoteip && \
    mkdir /var/run/apache2

COPY apache/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]