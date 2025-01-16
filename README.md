# PostgreSQL Replication Setup

A PostgreSQL Primary-Replica replication setup using Docker Compose with automated task management.

## Table of Contents

- [Requirements](#requirements)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Task Commands](#task-commands)
- [Configuration Details](#configuration-details)
- [Monitoring](#monitoring)
- [Backup and Restore](#backup-and-restore)
- [Troubleshooting](#troubleshooting)

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Task](https://taskfile.dev/#/installation) - A task runner / simpler Make alternative
- [Git](https://git-scm.com/downloads)

## Directory Structure

```
.
├── docker-compose.yml     # Docker Compose configuration
├── .env                   # Environment variables
├── Taskfile.yml          # Task automation scripts
├── data/                 # Data storage
│   ├── primary/         # Primary database data
│   └── replica/         # Replica database data
├── scripts/             # Initialization scripts
│   ├── primary/        # Primary configuration scripts
│   └── replica/        # Replica configuration scripts
└── backups/            # Backup storage
```

## Getting Started

1. Clone the repository
```bash
git clone <repository-url>
cd <repository-name>
```

2. Set up environment variables
```bash
cp .env.example .env
# Modify .env file according to your needs
```

3. Initialize and start
```bash
# Create directory structure and set permissions
task init

# Start PostgreSQL cluster
task start
```

## Task Commands

### Basic Operations

| Command | Description | Example |
|---------|-------------|----------|
| `task init` | Initialize directory structure and set permissions | `task init` |
| `task start` | Start PostgreSQL cluster | `task start` |
| `task stop` | Stop PostgreSQL cluster | `task stop` |
| `task restart` | Restart PostgreSQL cluster | `task restart` |
| `task status` | Check replication status | `task status` |

### Monitoring and Debugging

| Command | Description | Example |
|---------|-------------|----------|
| `task logs` | View container logs | `task logs` |
| `task monitor` | Monitor replication status in real-time | `task monitor` |
| `task validate` | Validate replication setup | `task validate` |
| `task psql-primary` | Connect to Primary DB | `task psql-primary` |
| `task psql-replica` | Connect to Replica DB | `task psql-replica` |

### Backup and Restore

| Command | Description | Example |
|---------|-------------|----------|
| `task backup` | Backup entire database | `task backup` |
| `task restore` | Restore from backup | `task restore ./backups/primary/backup-2024-01-16T10-30-00` |

### Maintenance

| Command | Description | Example |
|---------|-------------|----------|
| `task clean` | Clean all data and containers | `task clean` |
| `task help` | Show available commands | `task help` |

## Configuration Details

### Environment Variables (.env)

```env
# PostgreSQL Basic Settings
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres_password
POSTGRES_DB=mydb

# Port Settings
POSTGRES_PRIMARY_PORT=5432
POSTGRES_REPLICA_PORT=5433

# Replication User Settings
REPLICA_USER=replicator
REPLICA_PASSWORD=replicator_password
```

### Network Configuration

- Primary and Replica communicate through a dedicated bridge network named `postgres_network`
- Services are accessible within the network using hostnames:
  - Primary: `primary`
  - Replica: `replica`

## Monitoring

### Check Replication Status

```bash
# Check replication status
task status

# Real-time monitoring
task monitor
```

### View Logs

```bash
# View all logs
task logs

# View specific service logs
docker-compose logs primary
docker-compose logs replica
```

## Backup and Restore

### Create Backup

```bash
# Perform full backup
task backup
```

Backups are stored in the `./backups` directory with timestamps.

### Restore from Backup

```bash
# Restore from specific backup
task restore ./backups/primary/backup-[TIMESTAMP]
```

## Troubleshooting

### Common Issues

1. **Replication Not Working**
   ```bash
   # Check replication status
   task validate
   
   # Check logs
   task logs
   ```

2. **Containers Not Starting**
   ```bash
   # Check container status
   docker-compose ps
   
   # Check logs
   task logs
   ```

3. **Replication Lag**
   ```bash
   # Monitor replication lag
   task monitor
   ```

### Troubleshooting Steps

1. Check logs
2. Validate replication status
3. Verify network connectivity
4. Restart services if necessary

## Related Documentation

- [Task Documentation](https://taskfile.dev/#/)
- [Task GitHub Repository](https://github.com/go-task/task)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Task Installation

### macOS
```bash
# Using Homebrew
brew install go-task/tap/go-task

# Using MacPorts
sudo port install go-task
```

### Linux
```bash
# Using Snap
sudo snap install task --classic

# Using Homebrew
brew install go-task/tap/go-task

# Direct download
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
```

### Windows
```powershell
# Using Scoop
scoop install task

# Using Chocolatey
choco install go-task
```

## License

[Add License Information]

## Contributing

[Add Contributing Guidelines]

## Acknowledgments

- [Task](https://taskfile.dev) - Task runner / build tool
- [PostgreSQL](https://www.postgresql.org/) - Open source database
- [Docker](https://www.docker.com/) - Container platform

---

For more detailed information about Task usage and features, visit the [Task documentation](https://taskfile.dev/#/).