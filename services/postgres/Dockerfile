FROM postgis/postgis:17-3.5
COPY init/enable-hstore.sql /docker-entrypoint-initdb.d/
COPY postgres.conf /etc/postgresql/postgresql.conf