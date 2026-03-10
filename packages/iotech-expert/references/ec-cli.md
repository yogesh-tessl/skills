<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/cli/cli-overview.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-docker-tools.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-configuration-files.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-commands.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-services.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-service-ports.html
    - https://docs.iotechsys.com/edge-central40/cli/cli-environment-variables.html
  Synced: 2026-03-07
-->

# Edge Central CLI Overview

## 目錄

- [Command Format](#command-format)
- [Pull the Latest Images](#pull-the-latest-images)
- [Starting the Services](#starting-the-services)
- [Checking Status](#checking-status)
- [Stopping the Services](#stopping-the-services)
- [Backup (Experimental)](#backup-experimental)
- [Restore (Experimental)](#restore-experimental)
- [Docker Tools](#docker-tools)
- [Using Docker](#using-docker)
- [Using Docker Compose](#using-docker-compose)
  - [Configuration Files](#configuration-files)
  - [Docker Compose Override](#docker-compose-override)
  - [Docker Compose File Precedence](#docker-compose-file-precedence)
  - [Environment Variables](#environment-variables)
- [Generating a Docker Compose File](#generating-a-docker-compose-file)
- [Overview](#overview)
- [Main File Sections](#main-file-sections)
  - [General Settings](#general-settings)
  - [Services Configuration](#services-configuration)
- [Configuration Parameters Reference](#configuration-parameters-reference)
- [Overview](#overview)
- [Command Parameters and Arguments](#command-parameters-and-arguments)
  - [Help and Version Information](#help-and-version-information)
  - [Service Management Commands](#service-management-commands)
  - [Configuration and Licensing](#configuration-and-licensing)
  - [Utility Commands](#utility-commands)
- [Important Notes](#important-notes)
- [Edge Central Services](#edge-central-services)
- [Device Services](#device-services)
- [Overview](#overview)
- [Key Methods for Port Access](#key-methods-for-port-access)
  - [1. Container IP Address (Recommended)](#1-container-ip-address-recommended)
  - [2. Docker Compose Override](#2-docker-compose-override)
  - [3. Configuration Files](#3-configuration-files)
  - [4. Environment Variables](#4-environment-variables)
- [Overview](#overview)
- [EDGECENTRAL_COMPOSE_PATH](#edgecentral_compose_path)
- [EDGECENTRAL_PROJECT](#edgecentral_project)
- [EDGECENTRAL_IMAGE_VERSION](#edgecentral_image_version)


## Command Format

The Edge Central command-line interface uses this general structure:

`edgecentral [--env-file <file>] <command> [<args>]`

Refer to CLI Commands documentation for the full command listing and available services.

## Pull the Latest Images

Update microservice images using the `pull` command:

**Single service:**
```
edgecentral pull device-virtual
```

**All services:**
```
edgecentral pull --all
```

## Starting the Services

Create and start microservices with the `up` command:

**Example - Core Services with UI and Virtual Device:**
```
edgecentral up central-ui device-virtual
```

**Starting only specific services without core:**
```
edgecentral up --no-core nodered
```

The `--no-core` option allows launching individual microservices without the Edge Central Core Services.

## Checking Status

Verify running microservices with the status command:

```
edgecentral status
```

This displays container names, status, creation time, and port mappings for all running services.

## Stopping the Services

Three commands manage service shutdown:

- **`stop`** - Halts services while keeping containers
- **`down`** - Stops services and removes containers
- **`clean`** - Stops services, removes containers, and deletes volumes/networks

**Example:**
```
edgecentral down
```

**Warning:** The `clean` command removes all Edge Central data including configurations. Use with caution.

## Backup (Experimental)

Create backups containing PostgreSQL databases and Docker volumes:

```
edgecentral backup
```

Backups save to `/tmp/edgecentral/backups` by default. If Edge Central is running, the command prompts for confirmation to stop it first. Services remain stopped after backup completion.

## Restore (Experimental)

Restore Edge Central from a backup file:

```
edgecentral restore /path/to/backup-file.tar.gz
```

The restore process recreates networks, volumes, and databases from the backup. Services must be started manually after restoration completes.

---

# Docker Compose Files

## Docker Tools

Docker and Docker Compose manage Edge Central Services infrastructure and deployment.

## Using Docker

Docker containers host Edge Central microservices. For installation details, see the Docker Installation guide. The [Docker CLI documentation](https://docs.docker.com/engine/reference/commandline/cli/) covers available commands.

## Using Docker Compose

Docker Compose obtains images, configures settings, and manages container lifecycle for microservices. The YAML files drive the edgecentral CLI tool.

### Configuration Files

Edge Central installs Docker Compose and Application Service YAML files to `/etc/edgecentral/`. Key files include:

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Default configuration |
| `docker-compose-security.yml` | Security mode overrides |
| `app-service.yml` | Application Services configuration |
| `app-service-security.yml` | Security mode overrides for app services |

IOTech recommends using Docker Compose Override for modifications rather than editing base files directly.

### Docker Compose Override

Create local YAML files to override specific settings without modifying defaults. Example override for log level:

```yaml
services:
  device-virtual:
    environment:
      WRITABLE_LOGLEVEL: DEBUG
```

**Note:** DEBUG logging generates extensive output and should only be used for troubleshooting. Default is INFO.

#### Running with Local Docker Compose Files

Execute edgecentral CLI commands from the directory containing override files. The output message "Overriding configuration with local docker-compose.yml" indicates local files are in use.

### Docker Compose File Precedence

Edge Central applies configuration precedence in this order:

1. Local (current) directory
2. `EDGECENTRAL_COMPOSE_PATH` environment variable
3. Default directory (`/etc/edgecentral`)

This precedence applies to `docker-compose.yml`, `docker-compose-security.yml`, and `docker-compose.<EDGECENTRAL_PROJECT>.yml`.

### Environment Variables

Edge Central supports environment variable substitution from shell or `.env` files. By default, it reads `.env` from `/etc/edgecentral/`. Use the `--env-file` option to specify an alternate location.

## Generating a Docker Compose File

The `config gen` command creates minimal Docker Compose files containing only specified microservices:

```
edgecentral config gen [OPTION] [SERVICES...]
```

Available options:
- `--api-gateway`: Include secret store and API gateway
- `--no-core`: Exclude default services
- `--no-core-data`: Exclude core-data service
- `--no-core-keeper`: Exclude core-keeper service
- `-o, --out`: Specify output filename (default: "docker-compose-edgecentral.yml")
- `--secret`: Include secret store services
- `--timescale`: Use TimescaleDB instead of PostgreSQL

Example command:
```
edgecentral config gen device-virtual central-ui sys-mgmt
```

Start services using generated file:
```
docker compose -f docker-compose-edgecentral.yml up -d
```

---

# Configuration File Content

## Overview

The Docker Compose YAML file serves as the primary configuration mechanism for Edge Central deployment, containing multiple sections that define services, networks, volumes, and environment variables.

## Main File Sections

### General Settings
The initial section of the configuration file establishes foundational infrastructure:

- **Version specification** - Defines the Docker Compose file format version
- **Network configuration** - Sets up Docker networking for inter-service communication
- **Volume definitions** - Declares persistent storage for microservices
- **Environment variables** - Provides default settings and configuration parameters

### Services Configuration

The Services section organizes deployment components into logical groups:

#### Registry Services
Manages service discovery through the Core-Keeper service.

#### Database Services
Provides data persistence using Redis database infrastructure.

#### Core Services
Includes essential Edge Central components:
- `core-metadata` - Metadata management
- `core-data` - Data handling
- `core-command` - Command processing
- `core-keeper` - Registry functionality

#### Application Services
Referenced for pull operations; actual definitions reside in the `app-service.yml` file.

#### Supporting Services
Operational infrastructure components:
- `support-notifications` - Alert and notification handling
- `support-scheduler` - Task scheduling
- `support-provision` - Device provisioning

#### System Management
Manages overall system operations.

#### Management Console
Hosts the Edge Central UI service.

#### Device Services
Handles all device-specific integrations and communications.

#### Tools
Optional utilities and monitoring services:
- portainer, influxdb, grafana, nodered
- mqtt-broker, bacnet-sim, kuiper, timescaledb

## Configuration Parameters Reference

| Parameter | Function |
|-----------|----------|
| `cap_add` | Grants additional container capabilities |
| `command` | Overrides default container command |
| `container_name` | Assigns container identifier |
| `depends_on` | Establishes service dependencies |
| `environment` | Injects environment variables |
| `hostname` | Sets container hostname |
| `image` | Specifies container image source and version |
| `logging` | Configures logging behavior and driver selection |
| `networks` | Specifies network membership |
| `ports` | Exposes container ports to host |
| `priviledged` | Grants elevated container permissions |
| `volumes` | Mounts storage resources |

---

# CLI Commands

## Overview

The Edge Central CLI tool provides command-line interface functionality for managing Edge Central services. Below is the complete command reference:

## Command Parameters and Arguments

### Help and Version Information

| Command | Arguments | Description |
|---------|-----------|-------------|
| `--help` or `-h` | -- | Displays help on the `edgecentral` command |
| `--version` or `-v` | -- | Displays the version, the repository and the Git SHA of the installed Edge Central |
| `--env-file` | -- | Specify an alternate environment file |

### Service Management Commands

#### pull
Downloads latest Edge Central container images.

- `[<options>]` `[<services>]`
- Default: pulls core service images only
- `--all`: pulls updates for all images
- `--secret`: pulls all default services plus security services
- `--timescale`: switches database from PostgreSQL to TimescaleDB
- Specific services: pulls updates for specified services only

#### up
Creates and starts Edge Central services (core services by default).

Options:
- `--no-core`: runs without starting core services
- `--no-core-data`: excludes Core Data service
- `--no-core-keeper`: excludes Core Keeper service
- `--api-gateway`: starts nginx and proxy-auth services (requires `--secret`)
- `--timescale`: uses TimescaleDB instead of PostgreSQL

#### start
Starts the specified Edge Central services. If no services are specified, restarts all running services.

#### run
Creates and executes a one-off service with custom arguments: `[<services>]` `[<args>]`

#### stop
Stops the Edge Central services. If no services are specified, stops all running services.

#### rm (alias: down)
Stops and deletes the running Edge Central containers. If no services are specified, stops and deletes all created services.

#### status
Displays current operational state of created and/or running Edge Central services.

#### ip
Shows internet protocol addresses of running Edge Central services.

#### clean
`--force` or `-f`

Stops and deletes the running Edge Central services and removes all Edge Central volumes except the license volume.

#### logs
`[<services>]` `-o <output_directory>`

Exports the logs from created and/or running Edge Central services to the specified directory. If no services are specified, outputs all logs to the specified directory.

### Configuration and Licensing

#### config
Configuration management: `[<options>]`

- `validate`: validates current docker-compose configuration
- `view`: displays current docker-compose configuration
- `gen`: generates docker-compose configuration for required services
- `--timescale`: uses TimescaleDB as database
- `--em-deploy`: generates deployment configuration for EdgeManager

#### license
License management: `[<options>]`

- `install`: installs specified licenses to license volume
- `uninstall`: removes specified license
- `view`: lists currently installed licenses
- `check`: validates all installed licenses
- `clean`: deletes license volume (must not be mounted)

### Utility Commands

#### image
Displays the versions or Git SHA from which each service was built.

- `version`: version information per service
- `sha`: SHA information per service

#### backup
(Experimental) Creates backup file containing PostgreSQL database and volumes.

- `--backup-dir`: sets backup directory (default: `/tmp/edgecentral/backups`)
- `--pg-container`: PostgreSQL container name (default: `postgres`)
- `--pg-user`: PostgreSQL superuser name (default: `postgres`)

#### restore
(Experimental) Restores Edge Central from backup file.

Usage: `<backup-file>` `[<options>]`

- `--backup-dir`: backup file directory location
- `--pg-container`: PostgreSQL container name
- `--pg-user`: PostgreSQL superuser name

## Important Notes

**Database Switching Limitation**: Once initialized with either PostgreSQL or TimescaleDB, switching databases requires volume removal and recreation. Example process:

```bash
edgecentral down
docker volume rm edgecentral_db-data
edgecentral up
```

---

# CLI Services

## Edge Central Services

Edge Central provides a comprehensive set of services accessible through CLI commands:

| Service | CLI Command | Purpose |
|---------|------------|---------|
| Core Data | `core-data` | Centralized persistence facility for data readings collected by devices and sensors |
| Core Metadata | `core-metadata` | Maintains device service information and configuration |
| Command | `core-command` | Exposes the commands in a common, normalized way to simplify communications with devices |
| Core Keeper | `keeper` | Default configuration provider and registry with health monitoring |
| System Management | `sys-mgmt` | System administration and management capabilities |
| Scheduling | `support-scheduler` | Allows for the creation of schedules to be run at regular intervals |
| Application Service | `app-service` | Data export, manipulation, and analysis functionality |
| Notification | `support-notifications` | Allows for the creation of notifications and subscriptions |
| Provision | `support-provision` | One-off provisioning service for other Edge Central components |
| Portainer | `portainer` | Docker environment management interface |
| Kuiper | `kuiper` | Rules engine for data processing |
| Edge Central UI | `central-ui` | Web-based management and provisioning interface |
| InfluxDB | `influxdb` | Time-series database for metrics storage |
| Grafana | `grafana` | Data visualization and monitoring platform |
| Node-RED | `nodered` | Flow-based programming environment |
| Mosquitto MQTT | `mqtt-broker` | MQTT broker for use with Edge Central |
| Edge Historian | `edge-historian` | Long-term historical data storage service |

## Device Services

Edge Central supports multiple device service integrations:

| Service | CLI Command | Function |
|---------|------------|----------|
| USB-CAMERA | `device-usb-camera` | USB camera integration |
| ONVIF-CAMERA | `device-onvif-camera` | ONVIF camera connectivity |
| Ethernet-IP | `device-ethernet-ip` | Read data from, and issue commands to, Ethernet-IP devices |
| File | `device-file` | File scanning from storage locations |
| BACnet-IP | `device-bacnet-ip` | BACnet-IP device communication |
| BACnet-MSTP | `device-bacnet-mstp` | BACnet-MSTP device support |
| BACnet Sim | `bacnet-sim` | BACnet protocol simulator |
| BLE | `device-ble` | Read data from, and issue commands to, BLE devices |
| CANbus | `device-canbus` | CANbus device integration |
| GPS | `device-gps` | GPS data acquisition |
| Modbus | `device-modbus` | Modbus protocol support |
| MQTT | `device-mqtt` | Subscribe to data from, and issue commands to, MQTT devices |
| OPC UA | `device-opc-ua` | OPC UA device communication |
| REST | `device-rest` | Third-party REST data ingestion |
| S7 | `device-s7` | Siemens S7 device connectivity |
| WebSocket | `device-websocket` | WebSocket-based data pushing |
| Virtual | `device-virtual` | Simple simulation data ingestion ideal for learning, demonstration and testing |

---

# CLI Service Ports

## Overview

Edge Central running in secure mode restricts direct access to microservice ports. Users can expose specific service ports through several methods.

## Key Methods for Port Access

### 1. Container IP Address (Recommended)

After deploying with `edgecentral up --api-gateway`, locate service IP addresses:

**Docker approach:**
```bash
$ edgecentral ip | grep core-data
$ curl http://192.168.96.10:59880/api/v3/ping
```

**Podman approach** (since internal networks don't bridge to host):
```bash
$ podman run --rm -it --network edgecentral_edgex-network curlimages/curl \
  http://core-data:59880/api/v3/ping
```

Service ports can be found in `/etc/edgecentral/docker-compose-port-mapping.yml`.

### 2. Docker Compose Override

Create override file (e.g., `~/local-compose/docker-compose-security.yml`):

```yaml
version: '3.7'
services:
  core-data:
    ports:
      - "59880:59880"
```

Run Edge Central with the override:
```bash
$ edgecentral up --api-gateway
```

### 3. Configuration Files

Modify docker-compose files directly at `/etc/edgecentral`:

```bash
$ sudo vi /etc/edgecentral/docker-compose-security.yml
# Add under service:
#   ports:
#     - "59880:59880"
```

**Caution:** Future Edge Central installations may overwrite custom changes.

### 4. Environment Variables

Use `SERVICE_PORT` to override default ports:

```yaml
services:
  central-ui:
    ports:
      - "9091:9091"
    environment:
      SERVICE_PORT: 9091
```

**Note:** If port conflicts exist (e.g., default 9090 in use), modify the master docker-compose port mapping from "9090:9090" to "9091:9090" instead of changing `SERVICE_PORT`.

---

# CLI Environment Variables

## Overview

The Edge Central CLI uses three primary environment variables to customize deployment and configuration behavior.

## EDGECENTRAL_COMPOSE_PATH

**Purpose:** Specifies a custom directory path for docker-compose files.

**Use Case:** Allows you to maintain and use multiple configurations without changing directories.

**Example:**
```bash
$ export EDGECENTRAL_COMPOSE_PATH=/home/user/debug
$ edgecentral up
Overriding configuration with /home/user/debug/docker-compose.yml ...
```

## EDGECENTRAL_PROJECT

**Purpose:** Overrides the current configuration by specifying an environment-specific docker-compose file.

**Behavior:** The CLI searches for a file named `docker-compose.<env_value>.yml` to override default settings.

**Use Case:** Useful when integrating additional services requiring port exposure or custom configurations.

**Example Workflow:**

1. Create `docker-compose.postgres.yml`:
```yaml
services:
  postgres:
    ports:
      - "5432:5432"
```

2. Export the variable and start Edge Central:
```bash
$ export EDGECENTRAL_PROJECT=postgres
$ edgecentral up
Overriding configuration with local docker-compose.postgres.yml ...
```

Result: Port 5432 becomes accessible on the host machine.

## EDGECENTRAL_IMAGE_VERSION

**Purpose:** Specifies which Edge Central version to deploy.

**Example:** To use version 3.1.1:
```bash
$ export EDGECENTRAL_IMAGE_VERSION=3.1.1
$ edgecentral pull --all
$ edgecentral image version
```

This locks all container images to the specified version across all services.
