<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/ui/ui-overview.html
    - https://docs.iotechsys.com/edge-central40/ui/dashboard.html
    - https://docs.iotechsys.com/edge-central40/ui/service-control.html
    - https://docs.iotechsys.com/edge-central40/ui/opc-ua-browser.html
    - https://docs.iotechsys.com/edge-central40/ui/devices/device-mgmt.html
    - https://docs.iotechsys.com/edge-central40/ui/devices/device-profile-mgmt.html
    - https://docs.iotechsys.com/edge-central40/ui/devices/device-service-mgmt.html
    - https://docs.iotechsys.com/edge-central40/device-services/discovery/auto-discovery-ui.html
    - https://docs.iotechsys.com/edge-central40/ui/devices/mass-devices-onboarding.html
    - https://docs.iotechsys.com/edge-central40/ui/data-center/data-center.html
    - https://docs.iotechsys.com/edge-central40/ui/app-services/application-services.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/scheduler/ui-schedules.html
    - https://docs.iotechsys.com/edge-central40/ui/usersandrolepolicy.html
    - https://docs.iotechsys.com/edge-central40/ui/system-config.html
    - https://docs.iotechsys.com/edge-central40/ui/secure.html
    - https://docs.iotechsys.com/edge-central40/ui/rebranding.html
  Synced: 2026-03-07
-->

# Edge Central UI Overview

## 目錄

- [Architecture](#architecture)
- [Starting the UI](#starting-the-ui)
- [Dashboard Components](#dashboard-components)
  - [Device Metrics](#device-metrics)
  - [Service and Configuration Displays](#service-and-configuration-displays)
  - [Summary Statistics](#summary-statistics)
- [Service-Specific Restrictions](#service-specific-restrictions)
- [Accessing Service Control](#accessing-service-control)
- [Configuration Management](#configuration-management)
  - [Common Settings (All Services)](#common-settings-all-services)
  - [Device Service Settings](#device-service-settings)
- [Logging Features](#logging-features)
- [Configuration File Access](#configuration-file-access)
- [Key Capabilities](#key-capabilities)
- [Device Properties](#device-properties)
- [Device Actions](#device-actions)
- [Adding Devices](#adding-devices)
  - [Single Device Addition](#single-device-addition)
  - [Auto Events Configuration](#auto-events-configuration)
  - [Multiple Device Addition](#multiple-device-addition)
- [Device Profile Scanning](#device-profile-scanning)
- [Reading Device Data](#reading-device-data)
- [Writing Device Data](#writing-device-data)
- [Device Locking/Unlocking](#device-lockingunlocking)
- [Displayed Properties](#displayed-properties)
- [Device Profile Actions](#device-profile-actions)
- [Uploading Device Profiles](#uploading-device-profiles)
  - [Standard Upload](#standard-upload)
  - [Bulk Upload (Multiple Resources/Commands)](#bulk-upload-multiple-resourcescommands)
- [Device Service Properties](#device-service-properties)
- [Management Capabilities](#management-capabilities)
- [Add a Provision Watcher](#add-a-provision-watcher)
- [Customize Discovered Device Information](#customize-discovered-device-information)
- [Device Profile Onboarding](#device-profile-onboarding)
- [Device Onboarding](#device-onboarding)
- [Caution: Request Timeout Issues](#caution-request-timeout-issues)
- [Dashboard Features](#dashboard-features)
  - [Panel Types](#panel-types)
  - [GPS and Map Functionality](#gps-and-map-functionality)
  - [Dashboard Organization](#dashboard-organization)
- [Data Query Interface](#data-query-interface)
- [Adding a New Application Service](#adding-a-new-application-service)
- [Managing Application Services](#managing-application-services)
- [Prerequisites](#prerequisites)
- [Creating a Schedule Job](#creating-a-schedule-job)
  - [Example: Daily Job Configuration](#example-daily-job-configuration)
- [Key Definitions](#key-definitions)
- [Default Users](#default-users)
  - [Admin User](#admin-user)
  - [Default User](#default-user)
- [Role Policy Management](#role-policy-management)
- [User Management](#user-management)
- [Importing System Configuration](#importing-system-configuration)
- [Exporting System Configuration](#exporting-system-configuration)
- [Configuration Replication via Support-Provision Service](#configuration-replication-via-support-provision-service)
- [Configuring TLS](#configuring-tls)
- [Verification](#verification)
- [Certificate Rotation](#certificate-rotation)
- [Generating Self-Signed TLS Certificates](#generating-self-signed-tls-certificates)
  - [OpenSSL Method](#openssl-method)
  - [Go Tool Method](#go-tool-method)
- [Troubleshooting](#troubleshooting)
  - [Certificate Permission Issues](#certificate-permission-issues)
  - [Podman in RHEL with SELinux](#podman-in-rhel-with-selinux)
- [Auto-Generated Certificates (Not Recommended for Production)](#auto-generated-certificates-not-recommended-for-production)
- [Configurable Items via configs.json](#configurable-items-via-configsjson)
  - [Core Application Settings](#core-application-settings)
  - [Image Configuration](#image-configuration)
  - [Theme and Color Customization (theme.colors)](#theme-and-color-customization-themecolors)
- [Implementation Steps](#implementation-steps)


The Edge Central UI is a web-based interface for controlling and monitoring Edge Central microservices. It provides graphical access to key platform functions including device management, data querying, application services configuration, scheduling, and user administration.

## Architecture

The Edge Central UI comprises two components: a microservice backend and a web-based frontend application. The microservice must be operational before the UI can function properly.

## Starting the UI

Launch the Edge Central UI microservice with:
```bash
edgecentral up central-ui
```

Access the interface at `localhost:9090`. The default credentials are username `admin` and password `Admin@Edge0`. Custom ports can be configured via the `SERVICE_PORT` environment variable. By default, the UI runs in HTTP mode; refer to TLS Security documentation for HTTPS deployment.

---

# Dashboard

The Edge Central UI dashboard serves as the landing page, providing a comprehensive overview of various Edge Central services in a single view.

## Dashboard Components

### Device Metrics
- **By Protocol**: Distribution of connected devices across different protocols
- **By Admin State**: Device count categorized by administrative state
- **By Operating State**: Device count segmented by operational status

### Service and Configuration Displays
- **Device Services**: Pie chart showing service count colored by admin state
- **Subscriptions**: Visual representation of subscription count by admin state
- **Notifications**: Chart displaying notification occurrences categorized by status
- **Interval Actions**: Pie chart of scheduled actions colored by admin state

### Summary Statistics
- Device Profiles (total existing profiles)
- Application Services (total existing services)
- Data Readings (aggregate reading count across all devices)
- Events (aggregate event count across all devices)

---

# Service Control

The Service Control page enables comprehensive management of all Edge Central services. Users can start, stop, restart, configure, and monitor services.

## Service-Specific Restrictions

- **PostgreSQL**: Cannot start, stop, or restart because central-ui depends on postgres for app service management settings
- **System Management (sys-mgmt)**: Cannot be started, stopped, or restarted since the UI relies on it to control other services
- **Central-UI**: Cannot be started or stopped
- **Third-party Software**: Configuration editing and file downloads are restricted
- **Core-Keeper**: By default, configuration editing is not permitted

## Accessing Service Control

```bash
edgecentral up central-ui sys-mgmt device-virtual
```

Each service displays: container name, running state, image source, creation timestamp, IP address and port.

## Configuration Management

### Common Settings (All Services)

- **Health Check Interval**: Service registry check frequency in seconds
- **Max Result Count**: Data records per request limit
- **Max Request Size**: HTTP request body maximum (bytes)
- **Request Timeout**: Response wait duration (seconds)

### Device Service Settings

- **Reading Units**: Measurement units specification
- **Data Transform**: Transformation application indicator
- **Max Command Ops**: Maximum resources per command
- **Max Command Value Length**: JSON result string limit
- **Async Buffer Size**: Asynchronous result handling capacity

## Logging Features

Users can download all service logs as a ZIP archive, view individual service logs, download specific service logs, copy log content, and adjust display line count.

## Configuration File Access

The "Download configuration TOML file" option provides complete service configuration details for backup or transfer purposes.

---

# OPC UA Browser

The OPC UA Browser is an integrated feature within the Edge Central UI that requires no additional installation beyond the main platform.

## Key Capabilities

- **Connection Management**: Connect to OPC UA servers and quickly access frequently used server connections
- **Node Tree Navigation**: Browse hierarchical node structures while viewing node attributes and references
- **Data Interaction**: Subscribe to data, monitor values in real time, write values to nodes, or invoke methods

---

# Device Management

The Device Management section allows users to add, configure, and manage devices through the UI.

## Device Properties

- **Name**: Device identifier
- **Protocol**: Communication protocol used
- **Description**: Device details
- **Operating State**: Connection status (green=connected, red=disconnected)
- **Admin State**: Lock status (locked/unlocked)
- **Last Modified**: Update timestamp

## Device Actions

1. **View Device** - Display detailed device information, settings, and status
2. **Edit Device** - Modify device configuration and lock/unlock settings
3. **Control Device** - Read from and write data to the device
4. **Delete Device** - Remove the device from the system

## Adding Devices

### Single Device Addition

Prerequisites require uploading a device profile first:

1. Select **Add Device** icon
2. Choose device protocol (or "General" for generic fields)
3. Enter required information specific to the protocol
4. Select Device Profile from dropdown
5. Select Device Service from dropdown
6. Define Auto Events for data collection
7. Save the device

### Auto Events Configuration

- **Interval**: Time between queries (supports ISO 8601 format: 30us, 300ms, 10s, 5m, 1h, combinations)
- **ON CHANGE**: Report only when data changes between intervals
- **On Change Threshold**: Float value (default 0) for numeric types
- **Source Name**: Device resource or command from profile
- **Retention Settings**: MaxCap, MinCap, or Duration for event retention

### Multiple Device Addition

Edge Central supports bulk device imports via DBC and XLSX file formats.

**Caution**: Devices with duplicate names in XLSX files will be overwritten. Large imports (over 96,000 devices) may exceed the 15-second default timeout.

## Device Profile Scanning

Protocol-specific device profile discovery can be initiated per device. Starting v4.0.10, profile names support patterns using device properties (e.g., "BACnet-IP-{{ ModelName }}-{{ ObjectName }}").

## Reading Device Data

1. Select resource from Command List
2. Choose **Read** option (executes automatically)
3. Click **Execute** to refresh data

## Writing Device Data

1. Select resource from Command List
2. Click **Write** button
3. Input value in text box
4. Select **Execute** button

## Device Locking/Unlocking

Select the admin state icon to toggle between Lock and Unlock states. Default state for devices is unlocked.

---

# Device Profile Management

The Device Profiles pane displays all currently existing device profiles.

## Displayed Properties

- **Name**: The device profile's identifier
- **Description**: Details about the profile's purpose
- **Last Modified**: Timestamp of the last upload or update

## Device Profile Actions

- **View Device Profile**: Display comprehensive metadata including profile name, manufacturer, model, labels, device resources, and device commands
- **Delete Device Profile**: Remove a profile from the system

## Uploading Device Profiles

### Standard Upload
1. Select the upload icon
2. Choose your device profile file
3. Click **Save**

### Bulk Upload (Multiple Resources/Commands)
Upload DBC or XLSX formatted files. The XLSX format enables editing multiple device resources and commands before uploading.

---

# Device Services Management

The Device Services pane displays all device services currently deployed in Edge Central.

## Device Service Properties

- **Name**: The device service identifier
- **Base Address**: The service's network endpoint
- **Admin State**: Shows whether the service is locked or unlocked
- **Last Modified**: Timestamp of the last update

## Management Capabilities

Device service management is limited to administrative state control through locking and unlocking operations. Services are automatically created upon container deployment. By default, all device services deploy in an unlocked state.

---

# Automatic Discovery

The Edge Central UI enables automatic discovery configuration through provision watchers, which allow devices matching specific criteria to be automatically added to the system.

## Add a Provision Watcher

1. Navigate to **Devices** > **Automatic Discovery** tab
2. Click **Add** to launch the provision watcher wizard
3. Fill in the required details
4. Set mandatory identifiers that define which devices are eligible
5. Optionally add blocking identifiers to exclude specific devices

## Customize Discovered Device Information

The system supports customization of discovered device metadata (name, description, labels). Metadata placeholders like `{{ ModelName }}` are replaced with actual metadata during discovery.

---

# Mass Device Onboarding

Edge Central enables automatic onboarding of numerous devices and device profiles defined in XLSX files.

**Note:** The `device-usb-camera` protocol is unsupported for this functionality.

## Device Profile Onboarding

The Device Profiles sheet contains four tabs:

| Tab | Purpose |
|-----|---------|
| TemplateVersion | Template version information |
| DeviceInfo | Basic device profile information |
| DeviceResource | Device resource configuration |
| DeviceCommand | Device command configuration |

## Device Onboarding

The Device sheet contains three tabs:

| Tab | Purpose |
|-----|---------|
| TemplateVersion | Template version information |
| Devices | Device information |
| AutoEvents | Auto-event configuration |

## Caution: Request Timeout Issues

When uploading XLSX files, the default 10-second timeout may trigger a "503 HTTP request timeout" error. Adjust the timeout via Service Control > central-ui > Edit Configurations > Request Timeout.

---

# Data Center

The Data Center feature enables monitoring, visualization, and analysis of device data through two primary components:

- **Dashboard**: Real-time visual overview with customizable panels
- **Run Query**: Ad-hoc interface for filtering, searching, and analyzing device readings

## Dashboard Features

### Panel Types
- Time Series
- Table
- Gauge
- Bar Gauge
- State
- Map

### GPS and Map Functionality
When a device uses GPS protocol, the Map panel option becomes available. The Map panel requires an internet connection to display detailed maps.

### Dashboard Organization
Dashboards can be pinned for quick menu access, allowing users to organize multiple dashboards by device or use case.

## Data Query Interface

1. Device selection
2. Selection of one or more device resources
3. Time range specification
4. Click Query to fetch data

Auto-refresh capability: automatic updates every 5 seconds. Results support Table View and Chart View.

---

# Application Services

Edge Central UI provides functionality to create and manage Application Services for delivering data to external services.

**Prerequisite**:
```bash
edgecentral up sys-mgmt central-ui
```

**Important**: The UI only displays Application Services created by the UI. It does not display Application Services created by CLI.

## Adding a New Application Service

1. Select Add button
2. Complete basic info fields
3. Configure Trigger (select type, add topic for EdgeX Message Bus SubscribeTopics)
4. Pipeline Functions: Drag and drop functions to customize the service
5. Destination Configuration
6. Save (creates a new microservice)

Example subscription topic: `events/device/device-virtual/Random-Boolean-Device/Random-Boolean-Device/Bool`

## Managing Application Services

- **Edit**: Editing and saving will delete the original microservice and create a new one
- **Delete**: Select Delete icon and confirm
- **Control**: Start, Stop, or Restart services

---

# Schedules

## Prerequisites

```bash
edgecentral up central-ui support-scheduler
```

## Creating a Schedule Job

Schedule jobs support two execution time definition methods:
- **Interval-based**: Fixed time intervals
- **Cron expression**: Standard cron syntax with timezone support

### Example: Daily Job Configuration

| Setting | Value |
|---------|-------|
| Type | CRON |
| Crontab expression | CRON_TZ=Asia/Taipei 30 8 * * * |
| State | UNLOCKED (active) |
| Missed execution handling | Automatic trigger enabled |
| Action Type | Rest |
| HTTP Method | GET |
| Target URL | http://core-metadata:59881/api/v3/ping |

---

# Users and Role Policies

Edge Central UI implements role-based access control (RBAC) to manage user permissions.

## Key Definitions

- **User**: An individual logging into Edge Central UI with one or more assigned roles
- **Role**: A set of permissions defining allowed actions
- **Role Policy**: Rules applied to roles that specify allowed or denied actions on system resources

## Default Users

### Admin User
- **Credentials**: admin / Admin@Edge0
- **Roles**: edgex-user (read-only), system-admin (full access)
- **Cannot be deleted**, password changeable

### Default User
- **Roles**: edgex-user (read-only)
- **Cannot be deleted**

## Role Policy Management

Create policies with:
- Role name and optional description
- Access policies specifying Effect (Allow/Deny)
- Resource paths (regex supported)
- API type (REST or GraphQL)
- API methods (GET, POST, PUT, PATCH, DELETE for REST; QUERY, MUTATION, SUBSCRIPTION for GraphQL)

## User Management

- **Add**: Username, optional display name/description, assigned role, password
- **Edit**: Description, display name, roles, passwords
- **Delete**: Individual or batch deletion (admin and default users cannot be deleted)

---

# System Configuration

Edge Central provides capabilities for managing system-level configurations through archive file import and export operations. Supports `.zip` and `.gzip` formats.

## Importing System Configuration

1. Select "Import the system level config archive"
2. Browse to configuration archive file
3. Click Save

## Exporting System Configuration

1. Navigate to download option
2. Select desired file format (`.zip` or `.gzip`)
3. Save the archive locally

## Configuration Replication via Support-Provision Service

1. Configure devices and app services using Support-Provision
2. Export the configuration archive
3. On target nodes, import the archive to replicate the setup

---

# TLS Security

Edge Central UI operates without TLS encryption by default.

## Configuring TLS

1. Generate certificates: Create `cert.pem` and `key.pem` in a **certs** directory

2. Create docker-compose override file `docker-compose-security.yml`:

```yaml
services:
  central-ui:
    environment:
      TLS_ENABLE: "true"
      TLS_KEY_PATH: /certs/key.pem
      TLS_CERT_PATH: /certs/cert.pem
    volumes:
      - /<path-to-certs>/certs:/certs
```

3. Start with TLS:
```bash
edgecentral up --secret central-ui
```

4. Access at `https://localhost:9090`

## Verification

```bash
curl --cacert cert.pem https://localhost:9090/api/v4/ping
```

## Certificate Rotation

1. Replace `cert.pem` and `key.pem` (keep filenames unchanged)
2. Restart: `edgecentral restart central-ui`
3. Refresh browser and re-login

## Generating Self-Signed TLS Certificates

### OpenSSL Method
```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
  -days 365 -nodes -subj '/CN=localhost'
```

### Go Tool Method
```bash
go run /usr/local/go/src/crypto/tls/generate_cert.go \
  -ca -ecdsa-curve P256 -host localhost
```

## Troubleshooting

### Certificate Permission Issues
```bash
chmod 644 key.pem
chmod 644 cert.pem
```

### Podman in RHEL with SELinux
```yaml
volumes:
  - /<path-to-certs>/certs:/certs:ro,z
```

## Auto-Generated Certificates (Not Recommended for Production)

```yaml
central-ui:
  environment:
    TLS_ENABLE: "true"
    EDGECENTRAL_MANAGER_HOST: localhost
```

Auto-generated certificates stored in `/central-ui/data/`. Copy from container:
```bash
docker cp central-ui:/central-ui/data/cert.pem .
```

---

# Rebranding the UI

The rebranding feature enables customization of the Edge Central UI with your own company themes, logos, and branding. Requires an OEM license agreement with IOTech.

## Configurable Items via configs.json

### Core Application Settings
- **appName**: Application name in browser tabs, headers, and About dialogs
- **appDescription**: Text in the About pop-up
- **companyName**: Company name in exported file licenses
- **docURL**: Documentation link URL
- **copyright**: Copyright information (supports `${currentYear}` placeholder)

### Image Configuration
- `menuLogo`: Navigation menu logo
- `loginLogo`: Login page logo
- `copyright`: Optional copyright logo
- `menuCopyright`: Optional menu copyright logo
- `favicon`: Browser tab icon

### Theme and Color Customization (theme.colors)
- **primary**: Main widget colors (main, light, contrastText)
- **background**: Main page background
- **header**: Header text and background
- **menu**: Navigation menu styling (background, text, active states, hover)
- **dashboard**: Dashboard title and count colors
- **tabs**: Tab styling (text, background, active)
- **table**: Selected row text and background

Supported formats: `#nnn`, `#nnnnnn`, `rgb()`, `rgba()`, `hsl()`, `hsla()`

## Implementation Steps

1. Download branding.zip template
2. Extract and modify `configs.json`
3. Add custom images
4. Create docker-compose.yml mounting folder to `/res/branding`
5. Ensure proper file permissions
6. Start UI: `edgecentral up central-ui`
