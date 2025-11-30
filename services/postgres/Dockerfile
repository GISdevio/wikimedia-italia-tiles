FROM postgis/postgis:18-3.6
COPY init/enable-hstore.sql /docker-entrypoint-initdb.d/
COPY postgres.conf /etc/postgresql/postgresql.conf