<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/system-management/sys-mgmt/overview.html
    - https://docs.iotechsys.com/edge-central40/system-management/sys-mgmt/executor.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/overview.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/device-service.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/app-service.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/support-sparkplug.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/edge-historian.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/alarm-service.html
    - https://docs.iotechsys.com/edge-central40/edgex-integration/opcua-server.html
  Synced: 2026-03-07
-->

# Edge Central System Management & EdgeX Integration

## 目錄

- [Table of Contents](#table-of-contents)
- [System Management Overview](#system-management-overview)
  - [Getting Started](#getting-started)
  - [API Examples](#api-examples)
- [Executor](#executor)
  - [Overview](#overview)
  - [Key Functions](#key-functions)
  - [Implementation Flexibility](#implementation-flexibility)
  - [Configuration](#configuration)
- [EdgeX Integration Overview](#edgex-integration-overview)
  - [Installation](#installation)
  - [Licensing](#licensing)
  - [Integration Scope](#integration-scope)
- [Device Service Integration](#device-service-integration)
  - [Overview](#overview)
  - [Configuration Setup](#configuration-setup)
  - [Deployment](#deployment)
- [Application Service Integration](#application-service-integration)
  - [Overview](#overview)
  - [Configuration Setup](#configuration-setup)
  - [Docker Volumes Configuration](#docker-volumes-configuration)
  - [Running the Services](#running-the-services)
- [Support Sparkplug Integration](#support-sparkplug-integration)
  - [Overview](#overview)
  - [Configuration Steps](#configuration-steps)
  - [Critical Requirements](#critical-requirements)
  - [Service Startup](#service-startup)
- [Edge Historian Integration](#edge-historian-integration)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Configuration](#configuration)
  - [Deployment Modes](#deployment-modes)
  - [Launch Configuration](#launch-configuration)
  - [Running Services](#running-services)
- [Alarm Service Integration](#alarm-service-integration)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Non-Secure Mode Setup](#non-secure-mode-setup)
  - [Secure Mode Setup (Default)](#secure-mode-setup-default)
  - [Volume Configuration](#volume-configuration)
  - [Deployment](#deployment)
- [OPC UA Server Integration (EdgeX)](#opc-ua-server-integration-edgex)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Add OPC UA Server Configuration](#add-opc-ua-server-configuration)
  - [Accessing the OPC UA Browser](#accessing-the-opc-ua-browser)
  - [Volumes](#volumes)
  - [Running the Services](#running-the-services)


## Table of Contents

- [System Management Overview](#system-management-overview)
- [Executor](#executor)
- [EdgeX Integration Overview](#edgex-integration-overview)
- [Device Service Integration](#device-service-integration)
- [Application Service Integration](#application-service-integration)
- [Support Sparkplug Integration](#support-sparkplug-integration)
- [Edge Historian Integration](#edge-historian-integration)
- [Alarm Service Integration](#alarm-service-integration)
- [OPC UA Server Integration (EdgeX)](#opc-ua-server-integration-edgex)

## System Management Overview

The System Management service functions as a central hub for external management systems and other microservices to perform administrative operations on Edge Central. Its core responsibilities include:

- Starting Edge Central services
- Stopping Edge Central services
- Restarting Edge Central services
- Removing Edge Central services
- Obtaining service metrics
- Obtaining service configurations
- Performing health checks on services

The service exposes REST APIs to manage deployment, orchestration, and administration of Edge Central microservices.

### Getting Started

To use the System Management service, start it with:

```bash
edgecentral up sys-mgmt
```

**Note:** For secure mode deployments, replace localhost with the service IP address. Refer to CLI Service Ports documentation for details.

### API Examples

#### Service Metrics

**Request:**
```bash
curl http://localhost:58890/api/v3/system/metrics?services=core-data,core-command
```

**Response Structure:**
Returns an array of service metrics including CPU percentage, memory usage, and raw system statistics (block I/O, network I/O, process IDs).

#### Service Configuration

**Request:**
```bash
curl http://localhost:58890/api/v3/system/config?services=core-data
```

**Response Structure:**
Provides complete service configuration details including database settings, message bus configuration, registry information, and retention policies.

#### Service Operations

**Request:**
```bash
curl -X POST http://localhost:58890/api/v3/system/operation \
  -H 'Content-Type: application/json' \
  -d '[{"apiVersion":"v3","action":"start","serviceName":"core-data"}]'
```

Supported actions: start, stop, restart, remove

#### Service Health Check

**Request:**
```bash
curl http://localhost:58890/api/v3/system/health?services=core-data
```

**Note:** Health check requires Registry service to be up and running.

---

## Executor

### Overview

The Executor is a component within Edge Central's System Management that handles executable applications for management operations. The System Management Agent calls on executable applications to make management requests; the executable applications are known as the executors.

### Key Functions

Executors are responsible for:

- **Service Operations**: Starting, stopping, restarting, and removing services
- **Metrics Collection**: Gathering service performance data including CPU and memory usage

### Implementation Flexibility

The executor design supports multiple orchestration and runtime environments:

- Docker container runtime (reference implementation provided)
- Kubernetes
- Swarm
- OS-specific technologies (SAPS, SYSD)
- Custom scripting solutions

This modular approach enables scalability without requiring modifications to the System Management agent itself.

### Configuration

The System Management configuration specifies:

1. Which executor to use for metrics and operations
2. The location of the executable to be invoked

This separation of concerns allows organizations to deploy executors appropriate to their specific infrastructure and operational requirements.

---

## EdgeX Integration Overview

Edge Central is built using the Linux Foundation's open-source EdgeX Foundry platform and remains compatible with the base open-source EdgeX APIs. Version alignment follows matching major version numbers -- for instance, Edge Central 4.0 works with all EdgeX 4.0 editions.

### Installation

Standard Edge Central installation procedures apply, which automatically deploys Device Service docker-compose entries and example files to the host machine.

### Licensing

Edge Central services require valid license files. While the `edgecentral` command-line utility handles licensing, administrators may alternatively install licenses through native Docker commands:

```bash
docker volume create license-data
docker create -v license-data:/lic --name license-add alpine:3.17
docker cp <license name> license-add:/lic
docker rm license-add
```

### Integration Scope

Edge Central enables optional deployment of these components alongside EdgeX Foundry:
- Device Services
- Application Services
- Support Sparkplug
- Edge Historian services

---

## Device Service Integration

### Overview

This guide explains how to integrate and operate Edge Central Device Services alongside open source EdgeX Foundry services.

### Configuration Setup

#### Prerequisites

Start by obtaining a base EdgeX Foundry docker-compose file:

```bash
git clone --branch odessa https://github.com/edgexfoundry/edgex-compose.git
```

#### Non-Secure Configuration

For deployments without security enabled, generate the foundation compose file using:

```bash
cd edgex-compose/compose-builder
make gen no-secty
```

Then incorporate individual device service definitions from the example file located at `/usr/share/edgecentral/examples/edgex/device-services/non-secure/docker-compose.yml` into your generated configuration.

#### Secure Configuration

When security is required, use:

```bash
cd edgex-compose/compose-builder
make gen
```

Device service entries should be sourced from `/usr/share/edgecentral/examples/edgex/device-services/secure/docker-compose.yml`.

**Security Requirements:**
- Edge Central requires that the EdgeX Foundry internal message bus is MQTT
- Add device tokens to `EDGEX_ADD_SECRETSTORE_TOKENS`
- Add message bus secrets to `EDGEX_ADD_KNOWN_SECRETS`

Example for Modbus, BACnet, and OPC UA:

```yaml
services:
  security-secretstore-setup:
    environment:
      EDGEX_ADD_SECRETSTORE_TOKENS: device-modbus,device-bacnet-ip,device-opc-ua
      EDGEX_ADD_KNOWN_SECRETS: message-bus[device-modbus],message-bus[device-bacnet-ip],message-bus[device-opc-ua]
```

#### API Gateway Configuration

When enabling the proxy gateway, add device routes to the proxy-setup service:

```yaml
services:
  security-proxy-setup:
    environment:
      EDGEX_ADD_PROXY_ROUTE: >-
        device-modbus.http://device-modbus:59901,
        device-bacnet-ip.http://device-bacnet-ip:59980,
        device-opc-ua.http://device-opc-ua:59953
```

**Note:** Only alphanumeric characters and hyphens are permitted in proxy route naming conventions.

#### Docker Volume Configuration

Add named volumes at the end of your compose file for each service and licensing:

```yaml
volumes:
  device-modbus-data:
  device-bacnet-ip-data:
  device-opc-ua-data:
  license-data:
    external: true
```

### Deployment

Launch all services using:

```bash
docker compose up -d
```

---

## Application Service Integration

### Overview

This section provides guidance for integrating Edge Central Application Services with open source EdgeX Foundry services.

### Configuration Setup

#### Non-Secure Mode

To generate a basic EdgeX docker-compose file without security:

```bash
cd edgex-compose/compose-builder
make gen no-secty
```

For each Application Service, copy the relevant service entry from `/usr/share/edgecentral/examples/edgex/app-services/non-secure/docker-compose.yml` into your docker-compose file. Replace all instances of `${EDGEX_PROFILE}` with a unique name for your service.

#### Secure Mode

Generate EdgeX with security enabled:

```bash
cd edgex-compose/compose-builder
make gen
```

Copy service entries from `/usr/share/edgecentral/examples/edgex/app-services/secure/docker-compose.yml` into your docker-compose file.

**Important Requirements:**
- Edge Central requires that the EdgeX Foundry internal message bus is MQTT
- Update the secretstore-setup environment variables with Application Service entries:

```yaml
services:
  security-secretstore-setup:
    environment:
      EDGEX_ADD_SECRETSTORE_TOKENS: app-${EDGEX_PROFILE}
      EDGEX_ADD_KNOWN_SECRETS: message-bus[app-${EDGEX_PROFILE}]
```

**Multiple Services Example:**

```yaml
EDGEX_ADD_SECRETSTORE_TOKENS: app-awsiotcore-mqtt-export, azureiothub-mqtt-export
EDGEX_ADD_KNOWN_SECRETS: message-bus[awsiotcore-mqtt-export], message-bus[azureiothub-mqtt-export]
```

### Docker Volumes Configuration

#### Configuration Volume

1. Create a `configuration.yaml` file with Application Service configuration
2. Place the file in a local `app-configurable/{EDGEX_PROFILE}` directory
3. Mount the volume in the docker-compose file:

```yaml
services:
  app-${EDGEX_PROFILE}:
    volumes:
      - $PWD/app-configurable:/res
```

#### License Volume

Add to the volumes section:

```yaml
volumes:
  license-data:
    external: true
```

### Running the Services

Start EdgeX and Application Services:

```bash
docker compose up -d
```

#### Adding Secrets to Secret Store

For secure mode deployments, add client certificates and keys to the EdgeX secret store.

**Example Script for AWS IoT Core Secrets:**

```bash
#!/bin/sh
set -x

EDGEX_PROFILE=${1-}
CLIENTCERT=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' ./device.pem.crt)
CLIENTKEY=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' ./private.pem.key)

PAYLOAD='{ "apiVersion": "v3", "secretName":"aws",
"secretData": [{"key":"clientcert", "value":"'$CLIENTCERT'"},
{"key":"clientkey", "value":"'$CLIENTKEY'"}]}'

cd edgex-compose/compose-builder
TOKEN=$(make get-token)

CONTAINER_NAME='secretposter'
NETWORK_ID=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}'
edgex-security-secretstore-setup)

docker run -it --network="$NETWORK_ID" --name "$CONTAINER_NAME" curlimages/curl:latest \
-H "Authorization: Bearer $TOKEN" \
-X POST http://app-$EDGEX_PROFILE:59700/api/v3/secret -d "$PAYLOAD"

docker rm "$CONTAINER_NAME"
```

Execute the script:

```bash
./addAWSSecrets.sh $EDGEX_PROFILE
```

---

## Support Sparkplug Integration

### Overview

This documentation covers integrating Edge Central's support-sparkplug service with open source EdgeX Foundry services. The guide addresses both secure and non-secure deployment modes.

### Configuration Steps

#### Prerequisites

Begin by cloning the EdgeX Compose repository for your target version:

```bash
git clone --branch odessa https://github.com/edgexfoundry/edgex-compose.git
```

#### Non-Secure Deployment

For environments without security services:

1. Generate the base docker-compose file:
```bash
cd edgex-compose/compose-builder
make gen no-secty
```

2. Integrate the sparkplug service by copying configuration from `/usr/share/edgecentral/examples/edgex/support-services/non-secure/docker-compose.yml`

3. Adjust sparkplug settings as needed for your environment

#### Secure Deployment

For production environments with security enabled:

1. Generate the secured docker-compose file:
```bash
cd edgex-compose/compose-builder
make gen
```

2. Copy sparkplug configuration from `/usr/share/edgecentral/examples/edgex/support-services/secure/docker-compose.yml`

3. Update the `security-secretstore-setup` service with:
```yaml
EDGEX_ADD_SECRETSTORE_TOKENS: "support-sparkplug"
EDGEX_ADD_KNOWN_SECRETS: message-bus[support-sparkplug]
```

4. Configure API Gateway routing by adding to `security-proxy-setup`:
```yaml
EDGEX_ADD_PROXY_ROUTE: "support-sparkplug.http://support-sparkplug:59996"
```

**Important:** Only alphanumeric characters and hyphens are permitted in proxy route definitions.

#### Docker Volume Configuration

Add license volume support to the docker-compose file:

```yaml
volumes:
  license-data:
    external: true
```

### Critical Requirements

- Edge Central requires that the EdgeX Foundry internal message bus is MQTT
- Secure mode deployments must include secretstore configuration
- MQTT credentials (username, password, cacert) must be stored in the secret store

### Service Startup

Execute from the directory containing your docker-compose file:

```bash
docker compose up -d
```

---

## Edge Historian Integration

### Overview

Edge Historian is an Edge Central service designed to integrate with open source EdgeX Foundry for time series data storage and management.

### Prerequisites

- EdgeX Foundry base installation (version 4.0/Odessa or compatible)
- Docker and Docker Compose
- TimescaleDB database (replaces default EdgeX database)
- Valid Edge Central license

To obtain a base EdgeX installation:
```bash
git clone --branch odessa https://github.com/edgexfoundry/edgex-compose.git
```

### Configuration

The following environment variables control Edge Historian behavior:

| Variable | Default | Purpose |
|----------|---------|---------|
| SUBSCRIBETOPICS | Empty string | MQTT topics to subscribe to; use comma separation for multiple topics |
| RETENTION_INTERVAL | 10m | How frequently the system removes old readings |
| RETENTION_DEFAULTMAXCAP | -1 | Upper threshold for reading purging |
| RETENTION_DEFAULTMINCAP | 1 | Lower threshold returning readings to during purging |
| TIMESCALEDB_EVENT_CHUNKTIMEINTERVAL | 168h | Hypertable chunk duration |
| TIMESCALEDB_EVENT_COMPRESSINTERVAL | 0s | Data compression schedule interval |
| TIMESCALEDB_EVENT_COMPRESSAFTER | 168h | Age threshold before compressing chunks |
| TIMESCALEDB_READING_CHUNKTIMEINTERVAL | 168h | Hypertable chunk duration |
| TIMESCALEDB_READING_COMPRESSINTERVAL | 0s | Data compression schedule interval |
| TIMESCALEDB_READING_COMPRESSAFTER | 168h | Age threshold before compressing chunks |

### Deployment Modes

#### Non-Secure Deployment

Generate base composition:
```bash
cd edgex-compose/compose-builder
make gen no-secty
```

Replace the default database with TimescaleDB:
```yaml
database:
  image: timescale/timescaledb:2.19.0-pg16
  tmpfs:
    - /run
    - /tmp
```

Add the Edge Historian service configuration with appropriate environment variables for your subscription topics and retention policies.

#### Secure Deployment

Generate with security enabled:
```bash
cd edgex-compose/compose-builder
make gen
```

Secure mode requires:
- Security bootstrapper and secret store dependencies
- Additional environment variables for Vault integration (SECRETSTORE_HOST, SECRETSTORE_PORT)
- Stage gate configuration for startup orchestration
- TLS certificate volume mounts
- Entries in `security-secretstore-setup` for `EDGEX_ADD_SECRETSTORE_TOKENS` and `EDGEX_ADD_KNOWN_SECRETS`

For API Gateway integration, add proxy route configuration:
```
EDGEX_ADD_PROXY_ROUTE: "edge-historian.http://edge-historian:59926"
```

**Note:** Proxy routes only support alphanumeric characters and hyphens in hostnames.

### Launch Configuration

Essential settings:
- **Image:** iotechsys/edge-historian:4.0
- **Port:** 59926
- **User:** 2002:2001 (non-root)
- **Registry:** Uses keeper.http://edgex-core-keeper:59890
- **Message Bus:** MQTT (required for Edge Central)

### Running Services

Start all configured services:
```bash
docker compose up -d
```

---

## Alarm Service Integration

### Overview

The Alarm Service integrates with Edge Central and EdgeX Foundry services. This guide covers deployment in both secure and non-secure modes using Docker Compose.

### Prerequisites

Base EdgeX Foundry setup requires the edgex-compose repository:

```bash
git clone --branch odessa https://github.com/edgexfoundry/edgex-compose.git
```

### Non-Secure Mode Setup

#### Docker Compose Generation

```bash
cd edgex-compose/compose-builder
make gen no-secty
```

#### Service Configuration

Add this service definition to your docker-compose file:

```yaml
alarm-service:
  image: iotechsys/alarm-service:latest
  hostname: alarms-service
  container_name: alarms-service
  ports:
    - 59893:59893
    - 4840:4840
  restart: always
  depends_on:
    - database
  networks:
    - edgex-network
  volumes:
    - alarm-service-data:/data/
    - ${PWD}/deployment/:/deployment
  environment:
    - ALARM_CONFIGS_DIR=/deployment/alarms
    - MESSAGEBUS_SOURCES_DIR=/deployment/sources
    - WRITABLE_LOGLEVEL=INFO
    - MESSAGEBUS_SUB_TOPICS="xrt/mqtt/input"
```

#### Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `ALARM_CONFIGS_DIR` | No | Directory path for alarm configuration files |
| `MESSAGEBUS_SOURCES_DIR` | No | Directory path for message bus source configurations |
| `WRITABLE_LOGLEVEL` | No | Log level (INFO, DEBUG, ERROR); defaults to INFO |
| `MESSAGEBUS_SUB_TOPICS` | No | Comma-separated MQTT topic subscriptions |
| `DISABLE_API` | No | Set to 1 to disable API server |
| `DISABLE_ALARM_SERVER` | No | Set to 1 to disable alarm server logic |

### Secure Mode Setup (Default)

#### Docker Compose Generation

```bash
cd edgex-compose/compose-builder
make gen
```

#### Service Configuration

```yaml
alarm-service:
  image: iotechsys/alarm-service:latest
  container_name: alarm-service
  hostname: alarm-service
  entrypoint: /edgex-init/ready_to_run_wait_install.sh
  command: /entrypoint.sh
  restart: always
  depends_on:
    - database
  networks:
    - edgex-network
  ports:
    - 59893:59893
    - 4840:4840
  volumes:
    - alarm-service-data:/data/
    - ${PWD}/deployment/:/deployment
    - /etc/localtime:/etc/localtime:ro
    - edgex-init:/edgex-init:ro
    - /tmp/edgex/secrets/alarm-service:/tmp/edgex/secrets/alarm-service:ro
  environment:
    ALARM_CONFIGS_DIR: /deployment/alarms
    MESSAGEBUS_SOURCES_DIR: /deployment/sources
    WRITABLE_LOGLEVEL: INFO
    MESSAGEBUS_SUB_TOPICS: "xrt/mqtt/input"
    EDGEX_SECURITY_SECRET_STORE: "true"
    PROXY_SETUP_HOST: edgex-security-proxy-setup
    SECRETSTORE_HOST: edgex-secret-store
    SERVICE_HOST: edgex-app-rules-engine
    STAGEGATE_BOOTSTRAPPER_HOST: edgex-security-bootstrapper
    STAGEGATE_BOOTSTRAPPER_STARTPORT: "54321"
    STAGEGATE_DATABASE_HOST: edgex-postgres
    STAGEGATE_DATABASE_PORT: "5432"
    STAGEGATE_DATABASE_READYPORT: "5432"
    STAGEGATE_PROXYSETUP_READYPORT: "54325"
    STAGEGATE_READY_TORUNPORT: "54329"
    STAGEGATE_REGISTRY_HOST: edgex-core-keeper
    STAGEGATE_REGISTRY_PORT: "59890"
    STAGEGATE_REGISTRY_READYPORT: "54324"
    STAGEGATE_SECRETSTORESETUP_HOST: edgex-security-secretstore-setup
    STAGEGATE_SECRETSTORESETUP_TOKENS_READYPORT: "54322"
    STAGEGATE_WAITFOR_TIMEOUT: 60s
```

#### SecretStore Setup

Add alarm-service entries to EdgeX secretstore-setup:

```yaml
services:
  security-secretstore-setup:
    environment:
      EDGEX_ADD_SECRETSTORE_TOKENS: "alarm-service"
      EDGEX_ADD_KNOWN_SECRETS: message-bus[alarm-service],postgres[alarm-service]
```

### Volume Configuration

#### Data Volume

Add to docker-compose:

```yaml
volumes:
  alarm-service-data:
    name: edgex_alarm-service-data
```

#### License Volume

```yaml
volumes:
  license-data:
    external: true
```

### Deployment

Start services from the docker-compose directory:

```bash
docker compose up -d
```

---

## OPC UA Server Integration (EdgeX)

### Overview

The OPC UA Server integrates with EdgeX Foundry services. This guide covers setup and configuration for running the server alongside open source EdgeX services.

### Prerequisites

Start with EdgeX Foundry's base docker-compose file. Clone the repository:

```bash
git clone --branch odessa https://github.com/edgexfoundry/edgex-compose.git
```

#### Generate Compose File

**Non-Secure Mode:**
```bash
cd edgex-compose/compose-builder
make gen no-secty
```

**Secure Mode:**
```bash
cd edgex-compose/compose-builder
make gen
```

Security is enabled by default when not explicitly disabled.

### Add OPC UA Server Configuration

Insert this service definition into your generated docker-compose file:

```yaml
opc-ua-server:
  image: iotechsys/central-opc-ua-server:4.0
  container_name: opc-ua-server
  hostname: opc-ua-server
  networks:
    edgex-network: null
  user: 2002:2001
  read_only: true
  restart: always
  environment:
    EDGECENTRAL_NODE_SET_PATHS: '[]'
    EDGECENTRAL_MAPPING_PATHS: '[]'
  ports:
    - 4840:4840
  volumes:
    - /etc/localtime:/etc/localtime:ro
    - opc-ua-server-data:/opt/iotech/xrt/config
    - license-data:/edgecentral/licenses:ro

opc-ua-browser:
  image: iotechsys/opc-ua-browser
  container_name: opc-ua-browser
  ports:
    - "8080:8080"
  restart: always
```

### Accessing the OPC UA Browser

Navigate to `http://localhost:8080` in a web browser to access the interface.

**Important Note:** The OPC-UA server cannot discover or integrate with EdgeX device services for now. To enable visibility and integration, users must use the EdgeCentral device connector.

Create a new connection using `opc.tcp://172.17.0.1:4840/` with default connection settings.

### Volumes

#### Configuration Volume

Add to the bottom of your docker-compose file:

```yaml
opc-ua-server-data:
  name: edgex_opc-ua-server-data
```

#### License Volume

```yaml
volumes:
  license-data:
    external: true
```

### Running the Services

From the docker-compose directory:

```bash
docker compose up -d
```
