#!/bin/bash
set -e

if [ ! -s "${PGDATA}/PG_VERSION" ]; then
    echo "Initializing replica from primary..."
    
    # 기존 데이터 디렉토리 삭제
    rm -rf ${PGDATA}/*
    
    # Primary 서버가 시작될 때까지 대기
    until pg_isready -h postgres_primary -U ${REPLICATION_USER} -d ${POSTGRES_DB}; do
        echo "Waiting for primary to start..."
        sleep 2
    done
    
    # Base backup 수행
    pg_basebackup -h postgres_primary \
                 -D ${PGDATA} \
                 -U ${REPLICATION_USER} \
                 -v -P \
                 --wal-method=stream
    
    # Standby 설정 파일 생성
    cat > ${PGDATA}/standby.signal << EOF
# standby mode
EOF
    
    # Recovery 설정 추가
    cat >> ${PGDATA}/postgresql.auto.conf << EOF
primary_conninfo = 'host=postgres_primary port=5432 user=${REPLICATION_USER} password=${REPLICATION_PASSWORD} application_name=replica1'
EOF
fi

echo "Replica initialization completed"
exec postgres