#!/bin/bash
set -e

# PostgreSQL 서비스 시작을 기다림
until pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Replication 사용자 생성
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = '${REPLICATION_USER}') THEN
      CREATE USER ${REPLICATION_USER} WITH REPLICATION ENCRYPTED PASSWORD '${REPLICATION_PASSWORD}';
    END IF;
  END
  \$\$;
EOSQL

echo "Primary initialization completed"