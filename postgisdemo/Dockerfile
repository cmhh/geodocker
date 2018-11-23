FROM postgis

RUN mkdir -p /tmp/psql_data

COPY shp /tmp/psql_data

COPY ./z01_gis.sh /docker-entrypoint-initdb.d/

EXPOSE 5432
