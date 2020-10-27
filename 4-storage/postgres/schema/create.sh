#!/bin/bash

PATH=com.snowplowanalytics.snowplow

PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f atomic-def.sql
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f manifest-def.sql
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f scratch-and-web.sql

PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f $PATH/web_page_1.sql
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f $PATH/ua_parser_context_1.sql
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f $PATH/geolocation_context_1.sql


#for f in ${PATH}/*
#do
#PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow -f $f $PATH/webpage_1.sql
#done
#exit 0
#
