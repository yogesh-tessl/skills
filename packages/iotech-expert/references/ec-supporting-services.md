<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/supporting-services/supporting-services-overview.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/influxdb.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/grafana.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/notifications/alerts.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/notifications/restnotifications.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/notifications/mailconfig.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/scheduler/scheduler.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/provision/provision.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/sparkplug/sparkplug.html
  Synced: 2026-03-07
-->

# Supporting Services Overview

## 目錄

- [Introduction](#introduction)
- [Core Supporting Services](#core-supporting-services)
  - [Internal Services](#internal-services)
  - [Included Third-Party Services](#included-third-party-services)
- [Security Considerations](#security-considerations)
- [Overview](#overview)
- [InfluxDB Example Workflow](#influxdb-example-workflow)
  - [Required Steps](#required-steps)
- [Overview](#overview)
- [Grafana Example Setup](#grafana-example-setup)
  - [Implementation Steps](#implementation-steps)
  - [Starting Grafana](#starting-grafana)
  - [Datasource Configuration](#datasource-configuration)
  - [Dashboard Creation](#dashboard-creation)
- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Key Data Objects](#key-data-objects)
  - [Subscription](#subscription)
  - [Channel](#channel)
  - [Notification](#notification)
  - [Transmission](#transmission)
  - [TransmissionRecord](#transmissionrecord)
- [Data Retention](#data-retention)
- [Summary](#summary)
- [Related Resources](#related-resources)
- [Overview](#overview)
- [Configuring SMTP Server](#configuring-smtp-server)
- [Store Username/Password as Insecure Secrets](#store-usernamepassword-as-insecure-secrets)
  - [Step 1: Start the Notifications Service](#step-1-start-the-notifications-service)
  - [Step 2: Store Credentials via Core-Keeper](#step-2-store-credentials-via-core-keeper)
  - [Step 3: Configure Email Account](#step-3-configure-email-account)
- [Note on Secure Mode](#note-on-secure-mode)
- [Core Functionality](#core-functionality)
- [Key Components](#key-components)
  - [Schedule Job](#schedule-job)
  - [Schedule Action](#schedule-action)
  - [Schedule Definition](#schedule-definition)
  - [Schedule Action Record](#schedule-action-record)
- [API Changes](#api-changes)
- [Overview](#overview)
- [Provision Data Structure](#provision-data-structure)
- [Default Configuration](#default-configuration)
- [Secret Data Configuration](#secret-data-configuration)
- [Configuration Overrides](#configuration-overrides)
  - [Environment Variables](#environment-variables)
  - [Custom configuration.yaml](#custom-configurationyaml)
- [Deployment via CLI](#deployment-via-cli)
- [Key Notes](#key-notes)
- [Overview](#overview)
  - [Additional Features](#additional-features)
- [Default Configuration](#default-configuration)
  - [Sparkplug.MqttBroker Properties](#sparkplugmqttbroker-properties)
  - [Sparkplug Core Properties](#sparkplug-core-properties)
  - [Sparkplug.Payload Properties](#sparkplugpayload-properties)
  - [Sparkplug.Node Properties](#sparkplugnode-properties)
- [Authentication Modes](#authentication-modes)
- [Configuration Override Methods](#configuration-override-methods)
  - [Docker Compose File Override](#docker-compose-file-override)
  - [Environment File Override](#environment-file-override)
- [Running Sparkplug](#running-sparkplug)
  - [Prerequisites](#prerequisites)
  - [Launch Steps](#launch-steps)
- [Adding Secrets via REST API](#adding-secrets-via-rest-api)
  - [Prerequisites](#prerequisites)
  - [PEM File Conversion](#pem-file-conversion)
  - [Secret Insertion Example](#secret-insertion-example)


## Introduction

The Supporting Services layer provides essential microservices for edge computing operations. These services deliver:

- Edge decision-making, rules and analytics in low-latency mission-critical systems
- Data visualization and dashboard capabilities
- Event scheduling and automation
- Alert and notification systems
- Service provisioning functionality

## Core Supporting Services

### Internal Services

**Scheduler**: An internal timing mechanism that triggers actions for any Edge Central service, supporting both cron-based and interval-based schedules.

**Alerts and Notifications**: Enables Edge Central services to send out an alert or notification to another system or to a person monitoring Edge Central.

**Provision**: A configuration service that can provision other Edge Central services including device profiles, Node-RED flows, and Grafana dashboards.

### Included Third-Party Services

**InfluxDB**: An open-source time series database deployable at the edge to complement the storage provided by Core Data.

**Grafana**: An open-source visualization platform enabling creation of dashboards for your data with built-in InfluxDB integration.

**Node-RED**: A development tool offering a browser-based flow editor to connect flows using nodes in the Node-RED palette and allows bidirectional communication with Edge Central devices.

**eKuiper**: A lightweight, SQL-based rules engine, which is used for IoT data analytics and streaming applications at the edge.

## Security Considerations

Some of these services can be launched securely with reference to detailed security configuration guidance available in supplementary documentation.

---

# InfluxDB

## Overview

InfluxDB is an open-source time-series database. It can be deployed at the edge and complements the storage provided by the Edge Central Core Data service.

The system exports data to InfluxDB through the Application Service. Edge Central specifically supports InfluxDB v2.x versions.

## InfluxDB Example Workflow

The documentation provides a practical example demonstrating data export from the Virtual Device Service into InfluxDB via the Application Service, configured through the Edge Central UI.

### Required Steps

**1. Starting Edge Central Services**

Initial InfluxDB configurations (organization, bucket, token) are defined in compose files located at `/etc/edgecentral`.

For custom InfluxDB instances, create a local `docker-compose-security.yml` file with modified configurations:

```yaml
services:
  influxdb:
    environment:
      DOCKER_INFLUXDB_INIT_MODE: <mode>
      DOCKER_INFLUXDB_INIT_USERNAME: <username>
      DOCKER_INFLUXDB_INIT_PASSWORD: <password>
      DOCKER_INFLUXDB_INIT_ORG: <org>
      DOCKER_INFLUXDB_INIT_BUCKET: <bucket>
      DOCKER_INFLUXDB_INIT_ADMIN_TOKEN: <token>
```

Launch services:
```
edgecentral up sys-mgmt device-virtual influxdb central-ui
```

**2. Exporting Data via Central UI**

Access the UI at `http://localhost:9090` and:
- Navigate to App Services page
- Click **Add App Service**
- Enter "Influx" as the name
- Drag InfluxDB function to pipeline
- Configure these settings:

| Field | Value |
|-------|-------|
| InfluxDBServerURL | http://influxdb:8086 |
| InfluxDBOrganization | my-org |
| InfluxDBBucket | my-bucket |
| InfluxDBMeasurements | readings |
| Authentication Mode | Token |
| Token | custom-token |

**3. Verifying Readings via InfluxDB CLI**

Query collected data using:
```bash
docker exec -it influxdb influx query 'from(bucket:"my-bucket") |> range(start:-1h) |> drop(columns: ["_start", "_stop"]) |> filter(fn: (r) => r._measurement == "readings")'
```

This command uses the Flux Scripting Language with functions for data retrieval, time filtering, column removal, and conditional filtering.

---

# Grafana

## Overview

Grafana functions as an open-source visualization platform enabling dashboard creation for data representation. It integrates seamlessly with InfluxDB through a dedicated datasource plugin that retrieves and streams data from InfluxDB.

## Grafana Example Setup

This walkthrough demonstrates configuring and utilizing Grafana within an Edge Central environment. Prerequisites include completing the InfluxDB setup with Virtual Device Service data exports before proceeding with Grafana configuration.

### Implementation Steps

Three core steps are required:
1. Launch Grafana
2. Configure a datasource
3. Establish a dashboard

### Starting Grafana

Execute this command to initiate the Grafana service:

```
edgecentral up grafana
```

### Datasource Configuration

Before visualization, you must establish a datasource connection to the InfluxDB instance receiving Edge Central events.

**Configuration Process:**

1. Navigate to `http://localhost:3000/login` in your web browser
2. Authenticate using "admin" for both username and password
3. Select **Add Your First Data Source** or navigate via **Configuration > Data sources**
4. Choose InfluxDB from available datasources
5. Complete the datasource form with your InfluxDB connection details
6. Verify the connection by selecting **Save and Test** - successful configuration displays "buckets found"

**Note:** Port configuration is customizable within the docker-compose.yml file.

### Dashboard Creation

**Process:**

1. Select **Create (+) > Dashboard**
2. Designate InfluxDB as your data source on the Edit Panel interface
3. Insert the following Flux query:

```
from(bucket: "my-bucket")
|> range(start: -15m)
|> filter(fn: (r) => r["_measurement"] == "readings" and r["resourceName"] == "Float32")
|> group(columns: ["resourceName"])
|> sort(columns: ["_time"])
```

4. Execute the query to generate your visualization dashboard

---

# Alerts and Notifications

## Overview

The Alerts and Notifications system in Edge Central sends notifications when systems or users need awareness of events. **"Notifications are informative, whereas Alerts are typically of a more important, critical or urgent nature possibly requiring immediate attention."**

## System Architecture

The notification flow operates through these steps:

1. REST APIs from microservices pass data to Alerts and Notifications
2. The Notifications Handler processes the data
3. The Distribution Coordinator routes based on severity:
   - **Critical severity**: Sent immediately with retransmission on failure
   - **Normal severity**: Sent immediately with status marked as `PROCESSED`
4. The coordinator queries subscriptions to identify receivers
5. Channel senders deliver notifications via REST callbacks or email

## Key Data Objects

### Subscription
Describes receivers and recipient channels with properties:
- **ID**: UUID for unique identification
- **Name**: Unique subscription identifier
- **Receiver**: Party interested in notifications
- **Categories**: Links to notification categories
- **Channels**: Destination array for notifications
- **ResendLimit**: Retry attempts for sending
- **ResendInterval**: Golang duration format retry interval
- **AdminState**: Lock/unlock enumeration

### Channel
Describes notification endpoints supporting email or REST delivery:
- **Type**: ChannelType enumeration (email or REST)
- **MailAddress**: Array of email addresses
- **RESTAddress**: REST API destination endpoint

### Notification
Contains message and sender content:
- **ID**: UUID for unique identification
- **Sender**: Message originator
- **Category**: Notification categorization string
- **Severity**: Normal or critical enumeration
- **Content**: The transmitted message
- **Status**: New, processed, or escalated enumeration
- **ContentType**: Message content type indicator

### Transmission
Groups notifications with properties:
- **ID**: UUID identifier
- **Created**: Notification creation timestamp
- **NotificationId**: Referenced notification ID
- **SubscriptionName**: Interested subscription name
- **Status**: Failed, sent, resending, acknowledged, or escalated
- **ResendCount**: Resend attempt counter
- **Records**: TransmissionRecord array

### TransmissionRecord
Tracks delivery status per receiver:
- **Status**: Enumeration indicating transmission result
- **Response**: Receiver response string
- **Sent**: Delivery timestamp

## Data Retention

The system uses similar retention mechanisms as core data to prevent indefinite growth.

---

# Manage Alerts and Notifications Using REST

## Summary

Users can use the support-notifications REST API to manage alerts and notifications. The documentation directs readers to the comprehensive API reference for detailed endpoint specifications.

## Related Resources

- **Device Change Notifications** - Instructions for managing notifications triggered by device state changes
- **MQTT Channel Subscription** - Examples demonstrating MQTT-based notification channels
- **ZeroMQ Channel Subscription** - Examples for ZeroMQ-based notification channels

---

# Mail Server Configuration

## Overview

Edge Central uses Gmail SMTP by default. To configure a different SMTP server or manage email credentials, you'll need to use the Core-Keeper API.

## Configuring SMTP Server

To update the SMTP server host, send a PUT request to the Core-Keeper API:

```bash
curl --location --request PUT 'localhost:59890/api/v3/kvs/key/edgex/v3/support-notifications/Smtp/Host?flatten=true' \
--header 'Content-Type: application/json' \
--data-raw '{
   "value": "test-smtp-server"
}'
```

Replace `test-smtp-server` with your actual SMTP server address.

## Store Username/Password as Insecure Secrets

### Step 1: Start the Notifications Service

Launch Edge Central's notifications service:

```bash
edgecentral up consul support-notifications
```

### Step 2: Store Credentials via Core-Keeper

Use the Core-Keeper API to store SMTP credentials as insecure secrets:

```bash
curl --location --request PUT 'localhost:59890/api/v3/kvs/key/edgex/v3/support-notifications/Writable/InsecureSecrets/SMTP/SecretData?flatten=true' \
--header 'Content-Type: application/json' \
--data-raw '{
   "value": {
       "username": "test@gmail.com",
       "password": "test123"
    }
}'
```

Replace the sample credentials with your actual username and password.

### Step 3: Configure Email Account

Set your email account as the sender and use the appropriate password:

- For Gmail accounts, you may need to generate an app-specific password rather than using your regular account password

## Note on Secure Mode

If Edge Central operates in secure mode, replace `localhost` in API URLs with the service's IP address.

---

# Scheduler

## Core Functionality

The v4 Support Scheduler is a microservice that replaces legacy scheduling functionality from earlier versions. It manages tasks occurring at specific intervals or predetermined times, supporting both cron-based and interval-based job execution.

## Key Components

### Schedule Job
A container holding the necessary configuration to orchestrate one or more scheduled actions.

### Schedule Action
Defines what operation executes at the designated time. Three supported types include:

1. **REST** - Invokes a REST API endpoint on a specified service
2. **EDGEXMESSAGEBUS** - Publishes messages to EdgeX message bus topics
3. **DEVICECONTROL** - Sends command instructions to devices and their resources

### Schedule Definition
Determines when jobs execute using either intervals or crontab expressions.

**Interval Example:** Triggers every 5 minutes from August 28, 2024 (12:00 AM GMT) through September 1, 2024 (12:00 AM GMT)

**Cron Example:** Executes daily at midnight in the Asia/Taipei timezone using the expression: `CRON_TZ=Asia/Taipei 0 0 0 * * *`

### Schedule Action Record
Maintains an audit trail documenting each action's execution, including:
- Scheduled execution time
- Status outcomes (SUCCEEDED, FAILED, or MISSED)
- Optional automatic triggering of missed records upon service restart

## API Changes

The Scheduler now uses Data Transfer Objects (DTOs) for all responses and request payloads. Query endpoints returning multiple results include `offset` and `limit` parameters for pagination control.

---

# Provision Service

## Overview

The Provision service is a bootstrapping utility that automates initial Edge Central setup. It provisions core services including Core Metadata, Scheduler, Node-RED, and Grafana, reducing manual configuration during deployment.

**Key capabilities:**
- Add device services, devices, profiles, and provision watchers to Core Metadata
- Import Node-RED flows
- Configure Grafana datasources and dashboards
- Set up application services
- Update common configuration
- Create scheduler jobs
- Store secret data in the Secret Store

## Provision Data Structure

By default, the Provision service expects data organized in these directories:

| Target | Default Location |
|--------|------------------|
| Device Services | `/provision-data/device-services` |
| Device Profiles | `/provision-data/profiles` |
| Devices | `/provision-data/devices` |
| Provision Watchers | `/provision-data/provision-watchers` |
| Node-RED Flows | `/provision-data/nodered` |
| Grafana Datasources | `/provision-data/grafana/datasources` |
| Grafana Dashboards | `/provision-data/grafana/dashboards` |
| Application Services | `/provision-data/app-services` |
| Common Config | `/provision-data/common-config` |
| Scheduler Jobs | `/provision-data/schedulers` |
| Secrets | `/provision-data/secrets` |

## Default Configuration

The service includes built-in configuration for:
- Core Metadata on localhost:59881
- Central UI on localhost:9090
- Support Scheduler on localhost:59863

Configuration can reference REST endpoints for custom services using the format: `Provisions.Rest.<HTTP_OPERATION>.<Target_Name>`

## Secret Data Configuration

Secrets are organized hierarchically under `/provision-data/secrets`:

```
└── provision-data/secrets
    └── {serviceKey}              # Service name in registry
        └── {secretName}          # Groups related secrets
            ├── key1              # File becomes key
            └── key2              # File content becomes value
```

**Example structure for MQTT device service:**
```
└── device-mqtt
    └── mqtt
        ├── username
        └── password
```

The Provision service recursively scans folders, identifies secret locations, and posts data to each service's `POST /secret` API.

## Configuration Overrides

### Environment Variables

Modify the docker-compose file to override settings:

```yaml
support-provision:
  environment:
    PROVISIONS_OVERWRITEMETADATA: true
    PROVISIONS_CLIENTS_ADD_DEVICE_PAYLOADFOLDERPATH: /devices
```

### Custom configuration.yaml

Create a custom configuration file and bind-mount it:

```yaml
support-provision:
  volumes:
    - ${PWD}/provision-data:/provision-data
  environment:
    EDGEX_CONFIG_DIR: "/provision-data"
    EDGEX_CONFIG_FILE: "configuration.yaml"
```

## Deployment via CLI

**Prerequisites:** Prepare provision data directories locally

```bash
edgecentral up support-provision central-ui sys-mgmt grafana nodered
```

The service automatically provisions all data, then terminates upon completion.

## Key Notes

- Payload folders can use relative or absolute paths
- REST targets execute in alphabetical order by name
- Central UI service must run when provisioning common config or app services
- Environment variable substitution is supported for all payloads except secrets (v4.0.12+)

---

# Sparkplug

## Overview

The Sparkplug is a microservice functioning as a Sparkplug B Edge of Network (EoN) node for communicating with Sparkplug-enabled applications like SCADA/IIOT systems. Implementation follows "Sparkplug Specification Version 3.0" and supports various message types including:

- EoN Death Certificate (NDEATH)
- EoN Birth Certificate (NBIRTH)
- EoN Data Messages (NDATA)
- EoN Command (NCMD)
- Device Birth Certificate (DBIRTH)
- Device Death Certificate (DDEATH)
- Device Data Messages (DDATA)
- Device Command (DCMD)

### Additional Features

Beyond standard metrics like `bdSeq` and Node Rebirth, Sparkplug includes a Heartbeat metric. By default, heartbeat NDATA publication is disabled. To enable it, refer to the Sparkplug.Node configuration section. When enabled, periodic heartbeat messages are published with status information.

**Limitation:** Edge Central Sparkplug supports only a single MQTT Broker, so STATE messages are not processed.

## Default Configuration

Sparkplug uses common EdgeX microservice configuration patterns. The unique `Sparkplug` configuration section includes these subsections:

### Sparkplug.MqttBroker Properties

| Property | Default | Description |
|----------|---------|-------------|
| Url | tcp://mqtt-broker:1883 | MQTT broker connection URL |
| ClientIdPrefix | edgex-sparkplug | Client ID prefix (random string appended) |
| ConnectTimeout | 30s | Connection timeout duration |
| AutoReconnect | false | Enable automatic reconnection |
| KeepAlive | 60s | PING interval to broker |
| QoS | 0 | Quality of Service level |
| Retain | false | MQTT retained message setting |
| SkipCertVerify | false | Certificate verification setting |
| AuthMode | none | Authentication mode (none, usernamepassword, cacert, clientcert) |
| SecretName | sparkplug-mqtt-broker | Secret provider reference |
| RetryDuration | 600 | Connection establishment timeout (seconds) |
| RetryInterval | 5 | Retry interval (seconds) |

### Sparkplug Core Properties

| Property | Default | Description |
|----------|---------|-------------|
| Namespace | spBv1.0 | Topic structure root and payload encoding |
| GroupId | group | Logical grouping identifier |
| EdgeNodeId | node | Edge node identifier |

### Sparkplug.Payload Properties

| Property | Default | Description |
|----------|---------|-------------|
| MetricNameFormat | {metric_level1}/{metric_level2}/{resourceName} | Hierarchical metric naming template |

### Sparkplug.Node Properties

| Property | Default | Description |
|----------|---------|-------------|
| HeartbeatInterval | 0 | Heartbeat publication interval (seconds); values >0 enable feature |

## Authentication Modes

**Username/Password Mode** requires these secret keys:
- `username` - authentication username
- `password` - authentication password

**Client Certificate Mode** requires:
- `clientkey` - client private key (PEM format)
- `clientcert` - client certificate (PEM format)

**CA Certificate Mode** requires:
- `cacert` - CA certificate (PEM format)

**None Mode** requires no secrets.

## Configuration Override Methods

### Docker Compose File Override

Environment variables can override settings directly in compose files. Example with TLS (non-secure mode):

```yaml
support-sparkplug:
  environment:
    SERVICE_HOST: support-sparkplug
    SPARKPLUG_NAMESPACE: spBv1.0
    SPARKPLUG_GROUPID: IOTech
    SPARKPLUG_EDGENODEID: Node_001
    SPARKPLUG_PAYLOAD_METRICNAMEFORMAT: '{Sunspec_Model}/{Sub_Device}/{Tag_Name_n}/{resourceName}'
    SPARKPLUG_MQTTBROKER_URL: tcps://172.17.0.1:8883
    SPARKPLUG_MQTTBROKER_AUTHMODE: cacert
    WRITABLE_INSECURESECRETS_SPARKPLUG_MQTT_BROKER_SECRETDATA_CACERT: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
```

### Environment File Override

Create `/etc/edgecentral/.env` with desired values:

```
SPARKPLUG_NAMESPACE=spBv1.0
SPARKPLUG_GROUPID=IOTech
SPARKPLUG_EDGENODEID=Node_001
SPARKPLUG_PAYLOAD_METRICNAMEFORMAT={Sunspec_Model}/{Sub_Device}/{Tag_Name_n}/{resourceName}
SPARKPLUG_MQTTBROKER_URL=tcp://172.17.0.1:1883
```

## Running Sparkplug

### Prerequisites

- Installed Ignition with MQTT modules (MQTT Distributor, MQTT Engine)
- TLS configuration for secure communication
- Sparkplug MQTT broker connection details

### Launch Steps

1. Prepare `docker-compose.yml` with broker configuration
2. Run command: `edgecentral up --secret central-ui support-sparkplug`
3. Post certificates and credentials to secret store
4. Sparkplug publishes NBIRTH message to topic `spBv1.0/IOTech/NBIRTH/Node_001`
5. Launch Virtual Device Service to simulate devices: `edgecentral up --secret device-virtual`
6. Devices appear in SCADA system with periodic DDATA updates
7. SCADA can issue DCMD messages for device control
8. Delete devices in Edge Central UI to trigger DDEATH messages
9. Force kill Sparkplug (`docker kill support-sparkplug`) to simulate NDEATH

## Adding Secrets via REST API

### Prerequisites

1. Install jq utility
2. Retrieve JWT token from secret store
3. Get Sparkplug service IP address

### PEM File Conversion

Convert X.509 PEM files to REST-compatible strings:

```bash
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cert.pem
```

### Secret Insertion Example

Post username, password, and CA certificate:

```bash
curl -k -H "Authorization: Bearer ${jwt}" -X POST \
http://${ip}:59996/api/v3/secret \
-d '{
  "apiVersion":"v3",
  "secretName":"sparkplug-mqtt-broker",
  "secretData":[
    {"key":"username","value":"admin"},
    {"key":"password","value":"changeme"},
    {"key":"cacert","value":"-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----\n"}
  ]
}'
```

**Important:** All necessary secrets must be added in a single REST call to prevent overwrites.
