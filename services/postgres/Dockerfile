FROM postgis/postgis:17-3.4
COPY init/enable-hstore.sql init/disable-jit.sql /docker-entrypoint-initdb.d/
COPY postgres.conf /etc/postgresql/postgresql.conf