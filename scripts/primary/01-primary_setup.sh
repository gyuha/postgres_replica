#!/usr/bin/env bash  
set -e  

# 1. postgresql.conf 수정  
echo "host replication all 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"  

sed -ri "s/^#?wal_level.*/wal_level = replica/" "$PGDATA/postgresql.conf"  
sed -ri "s/^#?max_wal_senders.*/max_wal_senders = 8/" "$PGDATA/postgresql.conf"  
sed -ri "s/^#?max_wal_size.*/max_wal_size = 1GB/" "$PGDATA/postgresql.conf"  
sed -ri "s/^#?wal_keep_size.*/wal_keep_size = 64/" "$PGDATA/postgresql.conf"  

# 2. 복제 유저 생성  
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL  
    CREATE USER $REPLICATION_USER REPLICATION LOGIN ENCRYPTED PASSWORD '$REPLICATION_PASSWORD';  
EOSQL