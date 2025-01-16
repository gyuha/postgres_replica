#!/usr/bin/env bash
set -e

# 이미 설정이 완료되었는지 확인(마커 파일)
if [ -f "/tmp/replica_setup.complete" ]; then
    echo "Replica setup already done. Skipping."
    exit 0
fi

echo "Starting replica setup..."

# Primary가 준비될 때까지 대기
sleep 5 # 실제 환경에선 healthcheck 등이 더 안전

# pg_basebackup 이전에 PGDATA 비워주기(초기 1회만)
rm -rf "$PGDATA"/*

pg_basebackup -h "$PRIMARY_HOST" -D "$PGDATA" -U "$REPLICATION_USER" -P -X stream -C -S replica_slot || {
    echo "Base backup failed"
    exit 1
}

# standby.signal 생성
touch "$PGDATA/standby.signal"

# primary_conninfo 설정
echo "primary_conninfo = 'host=$PRIMARY_HOST port=5432 user=$REPLICATION_USER password=$REPLICATION_PASSWORD'" >>"$PGDATA/postgresql.conf"

chown -R postgres:postgres "$PGDATA"
chmod 700 "$PGDATA"

# 마커 파일 생성 → 다음부터는 재실행 안 함
touch /tmp/replica_setup.complete

echo "Replica setup complete."
