-- Replication 설정
ALTER SYSTEM SET listen_addresses TO '*';
ALTER SYSTEM SET wal_level TO 'replica';
ALTER SYSTEM SET max_wal_senders TO '5';
ALTER SYSTEM SET wal_keep_size TO '1024';
ALTER SYSTEM SET hot_standby TO 'on';

-- Replication 사용자 생성
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_password';

-- pg_hba.conf 설정을 위한 임시 테이블 생성
CREATE TABLE IF NOT EXISTS tmp_table (id serial);

-- Replication 접근 권한 설정
CREATE OR REPLACE FUNCTION create_replication_user_access() RETURNS void AS
$$
BEGIN
    EXECUTE format('
        ALTER SYSTEM SET hba_file TO ''%s'';
        ', current_setting('hba_file'));
END;
$$ LANGUAGE plpgsql;

SELECT create_replication_user_access();