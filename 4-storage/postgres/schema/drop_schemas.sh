#!/bin/bash

PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow  -c 'drop schema atomic cascade'
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow  -c 'drop schema web cascade'
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow  -c 'drop schema scratch cascade'
PGPASSWORD=postgres  /usr/bin/psql -U postgres -h 127.0.0.1  -d snowplow  -c 'drop schema scratchpad cascade'