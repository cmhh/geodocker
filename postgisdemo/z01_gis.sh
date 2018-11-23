# create databases and roles
printf "\n\ncreating database..."
psql -U postgres -c 'create database gis;' > /dev/null 2>&1
psql -U postgres -d gis -c 'CREATE EXTENSION postgis;' > /dev/null 2>&1
psql -U postgres -d gis -c 'CREATE EXTENSION postgis_topology;' > /dev/null 2>&1
psql -U postgres -d gis -c 'create schema statsnz;' > /dev/null 2>&1
printf "\ndone."


# populate from shapefiles
# need to rename columns because names get truncated and mangled in shapefiles
# don't love Stats NZ naming conventions besides.
# would be good to figure out how to load from geopackages using ogr2ogr--threw all kinds of errors when I tried.
printf "\n\npopulating tables..."
printf "\n\tcreating SA12018_V1_00"
cd /tmp/psql_data && \
  shp2pgsql -I -s 2193 statistical-area-1-2018-clipped-generalised.shp statsnz.SA12018_V1_00 | \
    psql -U postgres -d gis > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA12018_V1_00 RENAME COLUMN SA12018_V1 TO SA12018_V1_00;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA12018_V1_00 RENAME COLUMN LANDWATER_ TO LANDWATER_NAME;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA12018_V1_00 RENAME COLUMN LAND_AREA_ TO LAND_AREA_SQ_KM;' > /dev/null 2>&1

printf "\n\tcreating SA22018_V1_00"
cd /tmp/psql_data && \
  shp2pgsql -I -s 2193 statistical-area-2-2018-clipped-generalised.shp statsnz.SA22018_V1_00 | \
    psql -U postgres -d gis > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA22018_V1_00 RENAME COLUMN SA22018_V1 TO SA22018_V1_00;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA22018_V1_00 RENAME COLUMN SA22018__1 TO SA22018_V1_00_NAME;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.SA22018_V1_00 RENAME COLUMN LAND_AREA_ TO LAND_AREA_SQ_KM;' > /dev/null 2>&1

printf "\n\tcreating TA2018_V1_00"
cd /tmp/psql_data && \
  shp2pgsql -I -s 2193 territorial-authority-2018-clipped-generalised.shp statsnz.TA2018_V1_00 | \
    psql -U postgres -d gis > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.TA2018_V1_00 RENAME COLUMN TA2018_V1_ TO TA2018_V1_00;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.TA2018_V1_00 RENAME COLUMN TA2018_V_1 TO TA2018_V1_00_NAME;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.TA2018_V1_00 RENAME COLUMN LAND_AREA_ TO LAND_AREA_SQ_KM;' > /dev/null 2>&1

printf "\n\tcreating REGC2018_V1_00"
cd /tmp/psql_data && \
  shp2pgsql -I -s 2193 regional-council-2018-clipped-generalised.shp statsnz.REGC2018_V1_00 | \
    psql -U postgres -d gis > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.REGC2018_V1_00 RENAME COLUMN REGC2018_V TO REGC2018_V1_00;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.REGC2018_V1_00 RENAME COLUMN REGC2018_1 TO REGC2018_V1_00_NAME;' > /dev/null 2>&1
psql -U postgres -d gis -c 'ALTER TABLE statsnz.REGC2018_V1_00 RENAME COLUMN LAND_AREA_ TO LAND_AREA_SQ_KM;' > /dev/null 2>&1
printf "\ndone."


# set up permissions for user
printf "\n\nset up user..."
psql -U postgres -c 'create user gisuser;' > /dev/null 2>&1
psql -U postgres -c "alter user gisuser with encrypted password 'gisuser';" > /dev/null 2>&1
psql -U postgres -c 'grant all privileges on database gis to gisuser;' > /dev/null 2>&1
psql -U postgres -d gis -c 'grant all privileges on schema statsnz to gisuser;' > /dev/null 2>&1
psql -U postgres -d gis -c 'grant select on all tables in schema statsnz to gisuser;' > /dev/null 2>&1
printf "\ndone."
