FROM debian:forky
RUN --mount=type=cache,sharing=locked,target=/var/lib/apt/lists \
    --mount=type=cache,sharing=locked,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
    apache2 libapache2-mod-tile
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN --mount=type=cache,target=/root/.cache/uv \
    uv venv /opt/venv && uv pip install --link-mode=copy --python /opt/venv/bin/python morecantile

# LoadTileConfigFile
COPY web/common/renderd.conf /etc/renderd.conf

COPY web/apache/carto.conf /etc/apache2/sites-available/000-default.conf
COPY web/apache/index.html web/apache/empty.png /var/www/html/
COPY web/apache/check_bounds.py /usr/local/bin/check_bounds.py
COPY web/apache/entrypoint.sh /entrypoint.sh
RUN a2enmod tile && a2ensite 000-default && \
    a2enmod setenvif headers remoteip rewrite && \
    mkdir /var/run/apache2

COPY web/apache/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]