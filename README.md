# PostgreSQL 복제 및 로드밸런싱 설정

Docker Compose를 사용한 PostgreSQL 프라이머리-레플리카 복제 및 PgCat을 이용한 로드밸런싱 설정입니다.

## 목차

- [PostgreSQL 복제 및 로드밸런싱 설정](#postgresql-복제-및-로드밸런싱-설정)
  - [목차](#목차)
  - [요구사항](#요구사항)
  - [디렉토리 구조](#디렉토리-구조)
  - [시작하기](#시작하기)
  - [Task 명령어](#task-명령어)
    - [기본 작업](#기본-작업)
    - [모니터링 및 디버깅](#모니터링-및-디버깅)
  - [구성 상세](#구성-상세)
    - [환경 변수 (.env)](#환경-변수-env)
    - [네트워크 구성](#네트워크-구성)
  - [모니터링](#모니터링)
    - [복제 상태 확인](#복제-상태-확인)
    - [서비스 접속](#서비스-접속)

## 요구사항

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Task](https://taskfile.dev/#/installation)

## 디렉토리 구조

```
.
├── docker-compose.yml     # Docker Compose 설정
├── .env                   # 환경 변수
├── Taskfile.yml          # Task 자동화 스크립트
├── data/                 # 데이터 저장소
│   ├── pg1/             # 프라이머리 데이터
│   ├── pg2/             # 레플리카1 데이터
│   └── pg3/             # 레플리카2 데이터
└── config/              # 설정 파일
    └── pgcat.simple.toml  # PgCat 설정
```

## 시작하기

1. 저장소 복제
```bash
git clone <repository-url>
cd <repository-name>
```

2. 환경 변수 설정
```bash
cp .env.example .env
# 필요에 따라 .env 파일 수정
```

3. 시작
```bash
# 디렉토리 구조 생성 및 권한 설정
task init

# PostgreSQL 클러스터 시작
task start
```

## Task 명령어

### 기본 작업

| 명령어 | 설명 | 예시 |
|---------|-------------|----------|
| `task init` | 디렉토리 구조 생성 및 권한 설정 | `task init` |
| `task start` | PostgreSQL 클러스터 시작 | `task start` |
| `task stop` | PostgreSQL 클러스터 중지 | `task stop` |
| `task restart` | PostgreSQL 클러스터 재시작 | `task restart` |
| `task status` | 복제 상태 확인 | `task status` |

### 모니터링 및 디버깅

| 명령어 | 설명 | 예시 |
|---------|-------------|----------|
| `task logs [서비스명]` | 컨테이너 로그 확인 | `task logs pg1` |
| `task sh [서비스명]` | 컨테이너 쉘 접속 | `task sh pg1` |

## 구성 상세

### 환경 변수 (.env)

```env
# PostgreSQL 설정
TZ=Asia/Seoul
POSTGRESQL_USERNAME=postgres
POSTGRESQL_DATABASE=postgres
POSTGRESQL_PASSWORD=mysecretpassword

# 복제 설정
POSTGRESQL_REPLICATION_USER=repl_user
POSTGRESQL_REPLICATION_PASSWORD=repl_password

# 포트 설정
PGCAT_PORT=6432
PGCAT_ADMIN_PORT=9930
PG1_PORT=5433
PG2_PORT=5434
PG3_PORT=5435
```

### 네트워크 구성

- 모든 서비스는 Docker Compose 네트워크를 통해 통신
- 서비스 호스트명:
  - 프라이머리: `pg1`
  - 레플리카1: `pg2`
  - 레플리카2: `pg3`
  - 로드밸런서: `pgcat`

## 모니터링

### 복제 상태 확인

```bash
# 복제 상태 확인
task status

# 특정 서비스의 로그 확인
task logs pg1
task logs pg2
task logs pg3
task logs pgcat
```

### 서비스 접속

```bash
# 서비스 쉘 접속
task sh pg1    # 프라이머리 접속
task sh pg2    # 레플리카1 접속
task sh pg3    # 레플리카2 접속
task sh pgcat  # PgCat 접속
```