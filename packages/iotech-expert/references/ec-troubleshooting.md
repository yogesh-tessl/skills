<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/troubleshooting/troubleshooting-overview.html
    - https://docs.iotechsys.com/edge-central40/troubleshooting/known-issues.html
    - https://docs.iotechsys.com/edge-central40/troubleshooting/view-logs.html
    - https://docs.iotechsys.com/edge-central40/troubleshooting/core-dump.html
    - https://docs.iotechsys.com/edge-central40/migration/general-migr.html
    - https://docs.iotechsys.com/edge-central40/release-notes/4.0.html
  Synced: 2026-03-07
-->

# Edge Central Troubleshooting

## 目錄

- [Overview](#overview)
- [Installation Issues](#installation-issues)
- [Licensing Problems](#licensing-problems)
  - [No License Installed Error](#no-license-installed-error)
  - [License Validation Issues](#license-validation-issues)
- [UI Troubleshooting](#ui-troubleshooting)
- [Service-Specific Troubleshooting](#service-specific-troubleshooting)
- [Support Resources](#support-resources)
- [UI Limitations](#ui-limitations)
- [Device Service Connectivity](#device-service-connectivity)
- [OPC UA Configuration with nsenter](#opc-ua-configuration-with-nsenter)
- [HTTP Server Startup Error](#http-server-startup-error)
- [Device Profile Issues](#device-profile-issues)
- [Redis Vault Token Access](#redis-vault-token-access)
- [Secure Mode Timeouts](#secure-mode-timeouts)
- [OPC UA Empty Node Values](#opc-ua-empty-node-values)
- [Overview](#overview)
- [Viewing Logs](#viewing-logs)
  - [Terminal Display](#terminal-display)
  - [Saving to Directory](#saving-to-directory)
- [Rotated Log Files](#rotated-log-files)
  - [Accessing Rotated Files](#accessing-rotated-files)
- [Log Levels](#log-levels)
  - [Configuring Log Level](#configuring-log-level)
  - [Custom Log Rotation](#custom-log-rotation)
- [Overview](#overview)
- [Configuration Instructions](#configuration-instructions)
  - [Setting Up Core Dump Storage](#setting-up-core-dump-storage)
  - [Docker Compose Configuration](#docker-compose-configuration)
- [Retrieving Core Dump Files](#retrieving-core-dump-files)
  - [Step 1: Locate Docker Volumes](#step-1-locate-docker-volumes)
  - [Step 2: Find Mount Points](#step-2-find-mount-points)
  - [Step 3: Access Core Dump Files](#step-3-access-core-dump-files)
- [Alternative Collection Method](#alternative-collection-method)
- [Overview](#overview)
- [Key Changes in v4.0](#key-changes-in-v40)
- [Important Limitation](#important-limitation)
- [Migration Procedure](#migration-procedure)
- [Data Preservation](#data-preservation)
- [Overview](#overview)
- [Key Features and Enhancements](#key-features-and-enhancements)
  - [Core Capabilities](#core-capabilities)
- [Release Changelog Summary](#release-changelog-summary)
  - [Version 4.0.13](#version-4013)
  - [Version 4.0.12](#version-4012)
  - [Version 4.0.11](#version-4011)
  - [Version 4.0.10](#version-4010)
  - [Earlier Versions (4.0.9 - 4.0.4)](#earlier-versions-409---404)


## Overview

This section addresses common issues users may encounter when installing, configuring, and operating Edge Central, along with guidance for obtaining support.

## Installation Issues

Verify your environment meets the prerequisites outlined in the Edge Central Installation and Licensing Guide. Proper configuration of Docker and system dependencies is essential before proceeding with Edge Central deployment.

## Licensing Problems

### No License Installed Error

When Edge Central fails to start with a "No License Installed" message, despite having a valid license file, the issue often relates to Docker functionality. Running `edgecentral license check` may produce errors referencing temporary file paths. The recommended solution involves reinstalling Docker and verifying basic Docker operations:

```bash
docker run hello-world
```

### License Validation Issues

Even when license validation succeeds, startup failures may occur. "Permission denied reading license EdgeCentral_Trial_Evaluation.lic" typically indicates file permission problems. Fix with:

```bash
chmod 644 <license_file>
```

## UI Troubleshooting

Browser-related display issues after updating Edge Central UI should be addressed by clearing browser cache and refreshing the page. This resolves rendering inconsistencies caused by cached assets.

## Service-Specific Troubleshooting

- **Device Services**: Verify device profile configuration files for accuracy
- **Application Services**: Check the configuration.toml file for proper settings
- **Additional Services**: Ensure services are configured according to provided examples

## Support Resources

Edge Central includes a built-in troubleshooting script located at `/usr/share/edgecentral/tools/troubleshooting.sh` that collects system information and service logs. The generated archive should be sent to IOTech Systems support for analysis.

```bash
sudo chmod a+x /usr/share/edgecentral/tools/troubleshooting.sh
sh /usr/share/edgecentral/tools/troubleshooting.sh
```

---

# Known Issues

## UI Limitations
The Central UI has been tested with Google Chrome only, limiting browser compatibility.

## Device Service Connectivity
When Device Services use nsenter in Docker containers, they may fail to resolve hostnames for Core Data and Core Metadata. Solutions include mounting the hosts file as a volume or editing container `/etc/hosts`.

## OPC UA Configuration with nsenter
Services running with nsenter require IP address references instead of hostnames. For example, instead of `Host: "device-opc-ua"`, use the local IP: `Host: "172.18.10.2"`.

## HTTP Server Startup Error
Device Services may fail with an error when launched using both `--privileged` and `-p :` flags. Use only the `--privileged` command and set `privileged: true` in docker-compose configuration.

## Device Profile Issues
Duplicate names in `deviceResource` or `deviceCommand` elements generate warnings but don't block profile uploads. Ensure unique naming across all profiles to prevent these messages.

## Redis Vault Token Access
Direct Redis database access is restricted when using Vault. Modify `docker-compose-security.yml` to add the `EDGECENTRAL_PASSWORD_FILE` environment variable set to `'true'` (string) in the secretstore-setup microservice, then restart. Access credentials:

- **Username**: `redis5`
- **Password location**: `/tmp/edgex/secrets/redis-password`

## Secure Mode Timeouts
Resource-constrained systems may experience service startup failures in secure mode due to bootstrap timeouts. Stagger service launches using separate commands:

```bash
edgecentral up --no-core --secret
edgecentral up device-virtual
```

## Docker Toolbox Security Mode

When using Docker Toolbox in secure mode, services may fail to start with an **X509 certificate signed by unknown authority** error. To diagnose:

```bash
docker logs vault-worker
```

If the log does not end with `"Waiting for termination signal"`, the certificate issue is confirmed.

**Solution**: Clean all services, remove the security folder, and restart Edge Central:

```bash
edgecentral clean
# Remove the security folder, then restart
edgecentral up --secret
```

## OPC UA Empty Node Values
Some device resources pointing to empty variable-type nodes become unreadable. Workarounds include avoiding commands to affected resources or manually setting `isHidden=false` in device profiles.

---

# Logging

## Overview

Edge Central provides logging capabilities for monitoring services, understanding service interactions, improving performance, and troubleshooting issues. Each log entry contains a timestamp, originating service, log level, and message.

## Viewing Logs

### Terminal Display

To view service logs in a terminal, use:

```bash
docker logs <service>
```

For example, viewing Core Data logs:

```bash
docker logs core-data
```

### Saving to Directory

To export logs to a directory:

```bash
edgecentral logs <services> -o <output_directory>
```

Example:

```bash
edgecentral logs device-modbus -o Logs
```

## Rotated Log Files

Docker implements automated log rotation with default settings:

- **max-size**: "10mb" - Individual log files limited to 10 megabytes
- **max-file**: "5" - Retains up to 5 rotated log files per container

### Accessing Rotated Files

For Docker:
```bash
sudo ls -lh /var/lib/docker/containers/$(docker inspect -f '{{.Id}}' <container>)
```

For Podman (log file named `ctr.log`):
```bash
sudo ls -lh ~/.local/share/containers/storage/overlay-containers/$(podman inspect -f '{{.Id}}' <container>)/userdata/ctr.log
```

## Log Levels

| Level | Purpose |
|-------|---------|
| TRACE | Low-level data (requests/responses) |
| DEBUG | Detailed service information |
| INFO | High-level info (default level) |
| WARN | Unexpected events/problems |
| ERROR | Failed operations/errors |

### Configuring Log Level

Set via docker-compose.yaml:

```yaml
environment:
  WRITABLE_LOGLEVEL: DEBUG
```

Alternatively, adjust through the Central UI Service Control page.

### Custom Log Rotation

Modify logging driver settings:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10mb"
    max-file: "20"
```

---

# Core Dump

## Overview

The core dump file contains a memory snapshot of a crashed process, primarily used for post-mortem debugging. Several device services support core dump generation when they crash, including device-modbus, device-bacnet-ip, device-bacnet-mstp, device-ble, device-opc-ua, device-s7, device-gps, device-ethernet-ip, and device-canbus.

## Configuration Instructions

### Setting Up Core Dump Storage

Since device services use a designated folder for core dumps and Docker containers share the host's kernel settings, you must configure the host system's core pattern.

Execute this command on the host:

```bash
sudo sysctl -w kernel.core_pattern="/edgex-coredump/%e.%t"
```

This specifies where core dump files should be stored and defines a naming template using the executable name (%e) and timestamp (%t).

### Docker Compose Configuration

Set `ulimits.core` to `-1` to allow unlimited core dump file sizes for specific device services:

```yaml
services:
  device-modbus:
    ulimits:
      core: -1
```

## Retrieving Core Dump Files

### Step 1: Locate Docker Volumes

List all Docker volumes related to core dumps:

```bash
docker volume ls | grep coredump
```

### Step 2: Find Mount Points

Inspect a specific volume to locate its mount point:

```bash
docker inspect edgecentral_device-modbus-coredump | grep Mountpoint
```

Example output: `/var/lib/docker/volumes/edgecentral_device-modbus-coredump/_data`

### Step 3: Access Core Dump Files

List the generated core dump files at the mount point:

```bash
sudo ls /var/lib/docker/volumes/edgecentral_device-modbus-coredump/_data
```

Files are named using the pattern specified (e.g., `core.device-modbus.1744362576.21`).

## Alternative Collection Method

The troubleshooting script can automatically collect core dump files. Refer to the troubleshooting overview for additional support resources.

---

# Migration Guide (v3.1 to v4.0)

## Overview

This guide provides instructions for migrating from Edge Central v3.1 to v4.0. The API and data model remain at v3 in Edge Central v4, with one important exception regarding the Scheduler Service.

## Key Changes in v4.0

- Enhanced Core Data with improved event retention policies
- PostgreSQL adopted as the default database, replacing Redis across multiple services
- Core Keeper replaces Consul for configuration and registry management
- OpenBao replaces Vault for secret management
- Redesigned Support Scheduler service for advanced job scheduling
- Enhanced authentication middleware with external JWT support

## Important Limitation

Migration prior to v2.3 is not supported. Additionally, scheduler data from v3.1 cannot be automatically migrated due to the complete redesign of the Scheduler Service in v4.0.

## Migration Procedure

**Step 1: Export System Archive**
Use the Central UI to export a complete system archive containing all configurations.

**Step 2: Clean Up v3.1**
Execute `edgecentral clean` to stop running services.

**Step 3: Uninstall v3.1**
Remove Edge Central v3.1 using `sudo apt remove edgecentral`.

**Step 4: Install v4.0**
Follow the official installation guide to deploy Edge Central v4.0.

**Step 5: Relaunch Services**
Start services using the same command structure as before.

**Step 6: Import Archive**
Upload the previously exported archive file through the v4.0 Central UI to restore all configurations, devices, profiles, and settings.

## Data Preservation

The migration successfully restores most system configurations. However, plan accordingly for Scheduler Service data, which requires manual reconfiguration.

---

# Release Notes - Edge Central 4.0

## Overview

Edge Central 4.0 is built upon EdgeX Foundry version 4.0, codenamed "Odesa". This release introduces enterprise-grade edge computing capabilities with enhanced management, monitoring, and historical data features.

## Key Features and Enhancements

### Core Capabilities

**Alarm Service**: Monitors events and triggers alerts based on critical conditions, enabling real-time operator notifications of potential system issues.

**Edge Historian & Filter API**: Provides efficient storage and retrieval of historical data with customized query capabilities for trend analysis and performance tracking.

**Time-series Database Support**: TimescaleDB integration (PostgreSQL extension) improves query performance and enables data compression for time-series data in Core Data/Edge Historian.

**AI Inference Service**: Hosts and executes trained ML models with REST APIs for job submission and result retrieval. Primary application includes auto-tagging of device profiles for enhanced OT data context.

**User Roles and Access Management**: Comprehensive role-based permission system for controlling feature and data access across the platform.

## Release Changelog Summary

### Version 4.0.13
- Enhanced database indexing for improved reading query performance
- Fixed App Services configuration issues with encryption functions
- Resolved GPS Device Service protocol settings loss during auto-event configuration
- Fixed dashboard panel creation modal closure issues
- Improved alarm service functionality

### Version 4.0.12
- Enhanced provision service supporting shell-style environment variable expansion
- Improved error messages in REST Device Service for Sauter data objects
- Enhanced multi-resource read fault tolerance with partial result returns
- Added data dashboard support in system archive exports
- Implemented Map panel support in dashboards

### Version 4.0.11
- Added AI Inference service for auto-tagging capabilities
- Improved event retention cleanup stability
- Enhanced OPC UA profile scan user experience
- Fixed Central UI blinking and unexpected logout issues
- Added automatic 10-second refresh in Alarm Service views

### Version 4.0.10
- Supported multi-level secret folders in Support-Provision
- Added `ReadPropMultiFailover` configuration for BACnet Device Service
- Enhanced Ping/Pong mechanism with debug logging
- Fixed import/export of system-level configurations

### Earlier Versions (4.0.9 - 4.0.4)

Significant improvements across microservices, device services, UI, CLI, and application services including:

- Historian retention policy APIs
- Data compression capabilities for improved disk consumption
- Enhanced error handling and validation mechanisms
- Security enhancements with JWT authentication and access control
- Support for SASL/PLAIN authentication in Kafka operations
- Coredump retrieval capabilities for troubleshooting
