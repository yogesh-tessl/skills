<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/core-services/core-services-overview.html
    - https://docs.iotechsys.com/edge-central40/core-services/core-data.html
    - https://docs.iotechsys.com/edge-central40/core-services/event-filter.html
    - https://docs.iotechsys.com/edge-central40/core-services/core-metadata.html
    - https://docs.iotechsys.com/edge-central40/core-services/core-command.html
    - https://docs.iotechsys.com/edge-central40/core-services/core-config.html
    - https://docs.iotechsys.com/edge-central40/core-services/database.html
    - https://docs.iotechsys.com/edge-central40/core-services/database-external-drive-postgres.html
  Synced: 2026-03-07
-->

# Edge Central Core Services


## 目錄

- [Overview](#overview)
  - [Four Primary Core Services](#four-primary-core-services)
- [Core Data](#core-data)
  - [Data Submission Methods](#data-submission-methods)
  - [Core Data vs. Edge Historian](#core-data-vs-edge-historian)
  - [TimescaleDB Integration](#timescaledb-integration)
  - [Data Retention Features](#data-retention-features)
- [Event Filter](#event-filter)
  - [Subscribe Topics](#subscribe-topics)
  - [FilterIn Mechanism](#filterin-mechanism)
  - [FilterOut Mechanism](#filterout-mechanism)
  - [Combination](#combination)
  - [API Usage](#api-usage)
- [Core Metadata](#core-metadata)
  - [Data Models](#data-models)
- [Core Command](#core-command)
  - [Command Types](#command-types)
  - [Key Characteristics](#key-characteristics)
  - [Functional Role](#functional-role)
- [Config & Registry](#config-registry)
  - [Configuration](#configuration)
  - [Configuration Provider](#configuration-provider)
  - [Registry Provider](#registry-provider)
  - [Core Keeper API Examples](#core-keeper-api-examples)
- [Database](#database)
  - [User Access and Security](#user-access-and-security)
- [Configure External Drive for PostgreSQL](#configure-external-drive-for-postgresql)
  - [Attach the External Drive](#attach-the-external-drive)
  - [Docker Compose Configuration](#docker-compose-configuration)

---

## Overview

The Core Services layer is the central processing component between edge devices (Southbound) and cloud/enterprise systems (Northbound). It performs:

- **Data decoupling** - translating between different data formats from various edge devices
- **Data aggregation** - consolidating information from multiple sources
- **Standards compliance** - maintaining open, standardized APIs for interoperability

### Four Primary Core Services

1. **Core Data**: A persistence system storing device-collected data with associated management capabilities
2. **Core Command**: Manages actuation requests flowing from enterprise systems back to edge devices
3. **Core Metadata**: Maintains device information repository and handles device provisioning/pairing with Device Services
4. **Registry and Configuration**: Distributes service discovery and configuration details to other Edge Central microservices

---

## Core Data

The Core Data service provides centralized data persistence for device-collected sensor information. It manages this data persistence using a local database, with PostgreSQL as the default option.

### Data Submission Methods

1. **Message Bus Publishing** - Services publish sensor data to MQTT topics that Core Data subscribes to by default
2. **REST API** - Direct API calls send data to Core Data, which then republishes it to the message bus

### Core Data vs. Edge Historian

| Aspect | Core Data | Edge Historian |
|--------|-----------|-----------------|
| Purpose | Short-term storage | Long-term historical data |
| Default retention | 7 days | 30 days |
| Event purge on deletion | Disabled by default | Enabled |

### TimescaleDB Integration

Both services support TimescaleDB for improved time-series performance:

- **ChunkTimeInterval**: Default 168 hours (7 days)
- **Data Compression**: Disabled by default; can be enabled via environment variables
- **Query Optimization**: Automatically partitions data by time

#### Deployment Commands

```bash
# Core Data with TimescaleDB
edgecentral up --timescale

# Edge Historian with TimescaleDB (without Core Data)
edgecentral up edge-historian --no-core-data --timescale
```

> **Note**: Do not run Core Data and Edge Historian simultaneously — use `--no-core-data` when deploying Edge Historian.

#### Memory Planning

Chunk data (including indexes) should use no more than **25%** of main memory. Example for a 10GB RAM server:

- Available chunk budget: 10GB × 25% = **2.5GB**
- If device services generate ~1GB/day (300MB events + 700MB readings), the budget supports approximately **60 hours** of in-memory chunks
- Recommended chunk intervals for this scenario:
  - `TIMESCALEDB_EVENT_CHUNKTIMEINTERVAL=18h`
  - `TIMESCALEDB_READING_CHUNKTIMEINTERVAL=42h`

#### Compression

Data compression is disabled by default (`CompressInterval` set to `0s`). To enable:

```yaml
TIMESCALEDB_EVENT_COMPRESSINTERVAL: "12h"
TIMESCALEDB_EVENT_COMPRESSAFTER: "168h"
TIMESCALEDB_READING_COMPRESSINTERVAL: "12h"
TIMESCALEDB_READING_COMPRESSAFTER: "168h"
```

Performance example: 100GB of data compresses to 19GB, with query times averaging 2–3 seconds.

**Limitations when compression is enabled:**

- Row-by-row deletion becomes inefficient; use interval-based chunk dropping instead
- AutoEvent-level retention settings are ignored by the service
- Avoid APIs that perform row deletion from compressed chunks

#### DefaultQueryOffset

- **Core Data**: Default `0`
- **Edge Historian**: Default `-1` (skips counting, improving performance with large datasets)

### Data Retention Features

The retention system automatically purges outdated data based on:

- **Count-based rules** (maxCap/minCap)
- **Time-based policies** (duration settings)
- **Device/source filtering** (regex pattern matching in Edge Historian)

#### Retention Environment Variables

```yaml
RETENTION_INTERVAL: "10m"            # Purge check interval (default: 10m)
RETENTION_DEFAULTMAXCAP: <maxcap>
RETENTION_DEFAULTMINCAP: <mincap>
RETENTION_DEFAULTDURATION: "168h"    # Default retention duration (default: 168h)
```

Setting `RETENTION_INTERVAL` or `RETENTION_DEFAULTDURATION` to `0s` disables automatic purging.

---

## Event Filter

The Core Data/Edge Historian service provides three-level filtering to selectively persist event readings. Users can define message topics, create filters based on device names, event sources, or resource names (with regex support), and apply both inclusion and exclusion rules.

### Subscribe Topics

The service receives events from specified topics via the `SUBSCRIBETOPICS` environment variable. By default, Core Data subscribes to `events/device/#`, while Edge Historian subscribes to nothing.

### FilterIn Mechanism

**Purpose**: Pass events matching specified criteria to the next processing level.

**Behavior**: If no FilterIn rules exist, all events proceed. When rules are present, only matching events continue.

Features:
- Filter by deviceName and eventSourceName using regex patterns
- Filter by deviceName and resourceName, processing individual readings
- Apply onChange settings with thresholds to detect significant value changes

The onChange feature persists readings only on first occurrence or when value change exceeds the `onChangeThreshold`.

### FilterOut Mechanism

**Purpose**: Drop events or readings matching exclusion criteria.

**Matching Logic**: Events matching both deviceName and eventSourceName are dropped entirely. For reading-level filters, individual readings are removed while others in the event persist.

### Combination

Users can chain multiple filters together:
1. FilterIn rules select relevant data
2. FilterOut rules remove unwanted readings from selected events

> Regex expressions follow the syntax documented at the Google RE2 library specification.

### API Usage

Filters are created via REST endpoint `/api/v3/filter` accepting JSON payloads with filter type (IN/OUT), matching criteria, and optional onChange parameters.

---

## Core Metadata

The Core Metadata service stores information about devices and sensors connected to Edge Central, including communication protocols and data organization details.

### Data Models

Core Metadata persists information in a local database, defaulting to PostgreSQL with an abstraction layer allowing alternative databases.

#### Device Profile

Device profiles define available resources and commands for specific device types. IOTech provides a flexible naming and encoding mechanism that allows users to include reserved characters in resource name field.

#### Device

Device entries represent individual connected devices with specific configuration. The system supports a flexible naming and encoding mechanism that allows users to include reserved characters in device name field.

#### Device Service

Device Services facilitate communication between Edge Central and connected devices through protocol-specific implementations.

#### Device Provisioning

Device provisioning requires two components:

1. **Device Profile**: Contains resource and command definitions
2. **Connection Information**: Specifies physical addressing (IP addresses, ports, etc.)

**Static Provisioning**: All Device Services support static provisioning where device profiles and connection details are pre-configured through REST APIs or the Edge Central UI.

**Dynamic Provisioning**: Select Device Services support automatic discovery, where provision watchers configure the system to scan for and automatically register matching devices.

#### Provision Watcher

Provision watchers provide configuration parameters for automatic device discovery. They contain identifier key-value pairs specifying protocol types and scanning locations. Blocking identifiers can exclude specific devices from automatic provisioning.

---

## Core Command

Core Command functions as a command and control microservice that enables issuing commands to devices on behalf of other microservices, local applications, or external systems.

### Command Types

- **GET Commands**: Request data from the device, often used to request the latest sensor value
- **SET Commands**: Request an action or the operation of the device, or the setting of a configuration

### Key Characteristics

- GET commands typically require no parameters
- SET commands require request bodies with key/value pair arrays
- Edge Central supports an `Object` value type for structural data representation
- Core Command retrieves device information from Core Metadata
- All device communication flows through Device Services (Core Command never communicates directly with devices)

### Functional Role

Core Command acts as a proxy service between the north side of Edge Central (applications, analytics, services) and protocol-specific Device Services. This architecture enables:

- Normalized command representation across diverse device types
- Potential security layers for unauthorized access prevention
- Request regulation to prevent device overwhelm
- Possible response caching mechanisms

---

## Config & Registry

The Edge Central registry and configuration service supplies other services with information about associated services (location and status) and configuration properties (initialization and operational values). By default, Core Keeper serves as the reference implementation.

### Configuration

All Edge Central services share common configuration properties. Device services have additional configuration details.

- **Writable Settings**: Located under a service's `Writable` section, can be modified at runtime without requiring service restart
- **Read-only Settings**: All other configuration; changes require service restart

### Configuration Provider

Services accept a `-cp/--configProvider` flag at startup to enable centralized configuration management. When pointed to Core Keeper:

- Missing configuration is bootstrapped into the provider
- Existing configuration loads from the specified location
- Environment variable overrides are applied automatically

### Registry Provider

The registry enables microservice discovery and communication. Services register upon startup, and the registry performs periodic health checks.

Core Keeper provides native service registration, discovery, and health-checking capabilities.

> **Secure Mode Note**: When Edge Central is running in secure mode, you must replace `localhost` in API URLs with the actual service IP address. Refer to the CLI Service Ports documentation and JWT authentication guidelines for details.

### Core Keeper API Examples

#### Change Log Level

1. Retrieve current configuration:
   ```bash
   curl "http://localhost:59890/api/v3/kvs/key/edgex/v3/core-data?plaintext=true"
   ```

2. Update the log level:
   ```bash
   curl -X PUT "http://localhost:59890/api/v3/kvs/key/edgex/v3/core-data/Writable/LogLevel" \
     -H "Content-Type: application/json" \
     -d '{"value": "DEBUG"}'
   ```

3. Verify the update:
   ```bash
   curl "http://localhost:59880/api/v3/config"
   ```

#### Update Retention Settings

```bash
curl -X PUT "http://localhost:59890/api/v3/kvs/key/edgex/v3/core-data/Retention/MinCap" \
  -H "Content-Type: application/json" \
  -d '{"value": "10000"}'
```

---

## Database

Edge Central's primary database is PostgreSQL, an open-source object-relational database system that offers exceptional scalability and performance, with support for both relational and document (JSON) data models.

### User Access and Security

**Non-Secure Mode:** All services use the default postgres user to connect to the PostgreSQL database.

**Secure Mode:** Each EdgeX service is assigned a unique username and password, with limited privileges. Each service can only access schemas it owns. For example, the Core Data service uses the `core_data` user with privileges restricted to tables within the `core_data` schema.

---

## Configure External Drive for PostgreSQL

### Attach the External Drive

1. Identify the external drive:
   ```bash
   sudo fdisk -l
   sudo file -sL /dev/sdb
   ```

2. Create mount directory:
   ```bash
   sudo mkdir -p /mnt/external
   ```

3. Mount the drive:
   ```bash
   sudo mount /dev/sdb /mnt/external
   ```

4. Persist mount configuration in `/etc/fstab`:
   ```
   /dev/sdb      /mnt/external  ext4    errors=remount-ro 0       1
   ```

### Docker Compose Configuration

Add volume mapping to direct PostgreSQL data to external storage:

```yaml
services:
  postgres:
    volumes:
      - /mnt/external/postgres-data:/var/lib/postgresql/data
```

If PostgreSQL encounters permission errors, adjust directory ownership using `chown` to ensure proper access rights.
