#!/bin/bash
set -e

if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "*:*:*:$POSTGRES_REPLICATION_USER:$POSTGRES_REPLICATION_PASSWORD" > ~/.pgpass
    chmod 0600 ~/.pgpass
    until pg_basebackup -h primary -D ${PGDATA} -U ${POSTGRES_REPLICATION_USER} -v -P -R -X stream
    do
        echo "Waiting for primary to connect..."
        sleep 1s
    done
fi 