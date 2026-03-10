<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/tutorials/quick-start/index.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/overview.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/installation.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/simulators.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/starting.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/onboard-devices.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/time-series-storage.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/dashboarding.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/edge-rules.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/cloud-integration.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/stopping.html
    - https://docs.iotechsys.com/edge-central40/tutorials/chemical-tank/automated-provisioning.html
  Synced: 2026-03-07
-->

# Quick Start Guide

## 目錄

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Installation Steps](#installation-steps)
  - [1. Prerequisites](#1-prerequisites)
  - [2. Install Edge Central Package](#2-install-edge-central-package)
  - [3. Install License File](#3-install-license-file)
- [Starting Edge Central](#starting-edge-central)
  - [Verify Services](#verify-services)
- [Using the Edge Central UI](#using-the-edge-central-ui)
  - [Dashboard Features](#dashboard-features)
  - [Device Control](#device-control)
  - [Data Center](#data-center)
- [Using the Edge Central APIs](#using-the-edge-central-apis)
- [Stopping Services](#stopping-services)
- [Use Case Description](#use-case-description)
  - [System Architecture Components](#system-architecture-components)
  - [Key Learning Objectives](#key-learning-objectives)
  - [Software Installation Steps](#software-installation-steps)
- [Modbus Simulator](#modbus-simulator)
  - [Starting the Modbus Simulator](#starting-the-modbus-simulator)
  - [Testing the Modbus Simulator](#testing-the-modbus-simulator)
- [OPC UA Simulator](#opc-ua-simulator)
  - [Starting the OPC UA Simulator](#starting-the-opc-ua-simulator)
  - [Testing the OPC UA Simulator](#testing-the-opc-ua-simulator)
  - [Clean Previous Instances](#clean-previous-instances)
  - [Start Required Microservices](#start-required-microservices)
  - [Verify Service Status](#verify-service-status)
- [Edge Central UI Method](#edge-central-ui-method)
  - [Onboarding a Modbus Device](#onboarding-a-modbus-device)
  - [Onboarding an OPC UA Device](#onboarding-an-opc-ua-device)
- [REST API Method](#rest-api-method)
  - [Onboarding Modbus via REST](#onboarding-modbus-via-rest)
  - [Onboarding OPC UA via REST](#onboarding-opc-ua-via-rest)
- [Overview](#overview)
- [Edge Central UI Method](#edge-central-ui-method)
  - [InfluxDB Function Settings](#influxdb-function-settings)
- [Command Line Method](#command-line-method)
- [Data Verification](#data-verification)
- [Grafana UI Configuration](#grafana-ui-configuration)
  - [Create InfluxDB Data Source](#create-influxdb-data-source)
  - [Import Dashboard](#import-dashboard)
- [Grafana REST API Configuration](#grafana-rest-api-configuration)
  - [Configure Data Source](#configure-data-source)
  - [Load Dashboard](#load-dashboard)
- [Overview](#overview)
- [Node-RED Setup](#node-red-setup)
  - [Node-RED UI Method](#node-red-ui-method)
  - [Node-RED REST API Method](#node-red-rest-api-method)
- [Export to Node-RED](#export-to-node-red)
  - [Edge Central UI Approach](#edge-central-ui-approach)
  - [Command Line Approach](#command-line-approach)
- [Adjusting the Maximum Value](#adjusting-the-maximum-value)
- [Overview](#overview)
- [Edge Central UI Method](#edge-central-ui-method)
- [Command Line Method](#command-line-method)
- [Verification](#verification)
  - [Stop Command (Preserves State)](#stop-command-preserves-state)
  - [Down Command (Also Preserves State)](#down-command-also-preserves-state)
  - [Clean Command (Removes All State)](#clean-command-removes-all-state)
  - [Stopping Simulators](#stopping-simulators)
- [Overview](#overview)
- [Startup](#startup)
- [Shutdown](#shutdown)


## Table of Contents

- [Quick Start Guide](#quick-start-guide)
- [Chemical Tank Tutorial - Overview](#chemical-tank-tutorial---overview)
- [1. Simulator Setup](#1-simulator-setup)
- [2. Start Edge Central](#2-start-edge-central)
- [3. Onboard Devices](#3-onboard-devices)
- [4. Time Series Storage](#4-time-series-storage)
- [5. Dashboarding with Grafana](#5-dashboarding-with-grafana)
- [6. Edge Rules](#6-edge-rules)
- [7. Cloud Integration](#7-cloud-integration)
- [8. Stop Edge Central](#8-stop-edge-central)
- [Automated Provisioning](#automated-provisioning)

## Overview

Edge Central is a microservices-based edge software platform. This quick start guide demonstrates how to get the platform operational using default services and the Virtual Device Service for simulated sensor data.

## Installation Steps

### 1. Prerequisites
Verify Docker or Podman installation as described in the prerequisites documentation.

### 2. Install Edge Central Package
For Debian systems:
```bash
sudo dpkg -i edgecentral-<version_number>_amd64.deb
```

For RPM systems:
```bash
sudo rpm -ivh edgecentral-<version_number>.x86_64.rpm
```

Verify installation:
```bash
edgecentral -v
```

### 3. Install License File
Ensure the license file is readable:
```bash
chmod +r <EdgeCentralLicenseFile>.lic
```

Install the license:
```bash
edgecentral license install <EdgeCentralLicenseFile>.lic
```

Verify the license:
```bash
edgecentral license check
```

## Starting Edge Central

Launch core services, the Manager UI, and virtual device simulator:

```bash
edgecentral up central-ui device-virtual
```

The command starts these microservices: core-command, mqtt-broker, core-data, core-metadata, device-virtual, postgres, central-ui, and core-keeper.

### Verify Services

Check service status:
```bash
edgecentral status
```

## Using the Edge Central UI

Access the web interface at `http://localhost:9090`

**Default credentials:**
- Username: `admin`
- Password: `Admin@Edge0`

### Dashboard Features
The dashboard displays six virtual devices. The Devices tab shows all devices with their operational status (Up/Locked status).

### Device Control
Click the three-dot menu icon and select the Control option to execute GET/SET commands. The Virtual Device Service simulates sensors with configurable parameters. For example, the Random-Integer-Device generates values within -32,768 to 32,767 range by default.

### Data Center
The Data Center tab visualizes collected data in table or graph formats, displaying readings from specific device resources at configurable intervals.

## Using the Edge Central APIs

Access device data via REST endpoints. Example using curl:

```bash
curl http://localhost:59882/api/v3/device/name/Random-Integer-Device/Int16 | jq
```

Response includes API version, status code, device name, resource name, timestamp, and sensor value.

## Stopping Services

Stop and remove containers:
```bash
edgecentral down
```

Remove services, containers, volumes, and networks:
```bash
edgecentral clean
```

---

# Chemical Tank Tutorial - Overview

## Use Case Description

This tutorial introduces users to Edge Central's capabilities through a practical smart manufacturing scenario. It guides users through collecting data from multiple sources, storing it in time-series databases, visualizing results, implementing edge logic, and streaming data to cloud platforms.

The tutorial models two interconnected edge devices:

1. **Chemical Tank Device** - Equipped with Modbus-based sensors measuring temperature, pressure, and level, plus configurable maximum safety thresholds
2. **Flow Controller Device** - Features an OPC UA interface with a controllable valve, setpoint configuration, and flow rate measurements

The control logic automatically opens the valve when chemical tank measurements exceed safe maximums, then closes it when values return to normal ranges.

### System Architecture Components
- Edge Central for device management and orchestration
- InfluxDB for time-series data storage
- Grafana for real-time dashboard visualization
- Node-RED for rules engine and edge decision-making
- HiveMQ for cloud data streaming

### Key Learning Objectives
- Collecting and ingesting data from two simulated data sources (Modbus and OPC UA)
- Delivering data to time-series storage systems
- Building user-configured visualization dashboards
- Implementing edge-based decision logic and device control
- Streaming northbound data to cloud/IT systems

---

# Chemical Tank Tutorial - Installation

This tutorial has been tested and verified on Ubuntu 22.04, but should run fine on any version of Linux that supports Docker.

### Software Installation Steps

1. **Install Edge Central** - Follow the Edge Central Installation instructions, ensuring Docker and Docker Compose are installed as per the prerequisites
2. **Install the Edge Central license file** - Follow the Edge Central Licensing instructions which includes information on how to access your commercial or evaluation license file
3. **Download the Chemical Tank tutorial project** - Download the Chemical Tank Demo project file and extract using: `unzip Chemical_Tank_Demo.zip`

---

# 1. Simulator Setup

## Modbus Simulator

The Chemical Tank is modeled by a Modbus simulator running in a Docker container, configured to represent the following data points:

| Modbus Holding Register | Value | Permissions |
|---|---|---|
| 1000 | Temperature | Read Only |
| 1001 | Pressure | Read Only |
| 1002 | Level | Read Only |
| 1003 | Maximum | Read Write |

The simulator includes a Python script called `update-tank-values.py` that generates meaningful demonstration data using sine waves, cosine waves, and sawtooth patterns.

### Starting the Modbus Simulator

**Docker:**
```bash
docker run -d --rm -v ${PWD}/sim_files:/sim_files -p 5020:5020 --name modbus-sim iotechsys/pymodbus-sim:1.0.4 --profile /sim_files/chemical-tank.json --script /sim_files/update-tank-values.py
```

**Podman:**
```bash
podman run -d --rm -v ${PWD}/sim_files:/sim_files:z -p 5020:5020 --name modbus-sim iotechsys/pymodbus-sim:1.0.4 --profile /sim_files/chemical-tank.json --script /sim_files/update-tank-values.py
```

### Testing the Modbus Simulator

```bash
mbpoll -r 1000 -c 4 -0 localhost -p 5020
```

## OPC UA Simulator

The Flow Controller is modeled by an OPC UA simulator with these data points:

| OPC UA Node Information | Value | Permissions |
|---|---|---|
| ns=4;s=Valve | Valve | Read Write |
| ns=4;s=FlowRate | FlowRate | Read Only |
| ns=4;s=SetPoint | SetPoint | Read Write |

The simulator uses a Lua script (`flow-controller-sim.lua`) implementing an algorithm where opening the valve causes the flow rate to progress toward the target set point.

### Starting the OPC UA Simulator

**Docker:**
```bash
docker run -d --rm -v ${PWD}/sim_files:/sim_files --name opc-ua-sim -p 49947:49947 iotechsys/opc-ua-sim:1.4.0 -l /sim_files/flow-controller-sim.lua
```

**Podman:**
```bash
podman run -d --rm -v ${PWD}/sim_files:/sim_files:z --name opc-ua-sim -p 49947:49947 iotechsys/opc-ua-sim:1.4.0 -l /sim_files/flow-controller-sim.lua
```

### Testing the OPC UA Simulator

Use the OPC UA Browser tool:
```bash
docker run --rm -d --name opc-ua-browser -p 8080:8080 iotechsys/opc-ua-browser:1.0
```

Access at `http://localhost:8080`, enter `opc.tcp://172.17.0.1:49947` as connection information, then navigate to Objects/FlowController to view the three nodes.

---

# 2. Start Edge Central

### Clean Previous Instances
```bash
edgecentral clean
```

### Start Required Microservices
```bash
edgecentral up device-modbus device-opc-ua central-ui influxdb grafana nodered sys-mgmt
```

**Note:** The `sys-mgmt` microservice is required for the Edge Central UI to dynamically manage Application Services.

### Verify Service Status
```bash
edgecentral status
```

---

# 3. Onboard Devices

Device onboarding supports two methods: the graphical user interface or REST API commands.

## Edge Central UI Method

### Onboarding a Modbus Device

**Access:** Navigate to `http://localhost:9090` with default credentials admin/Admin@Edge0.

**Upload Device Profile:**
1. Go to **Devices** > **Device Profiles** tab
2. Select **Upload** and choose `ChemicalTank.yaml` from provision-data/profiles
3. Click **Save**

**Add Device:**

| Setting | Value |
|---------|-------|
| Name | Chemical-Tank |
| Protocol | Modbus-TCP |
| Device Profile | Chemical-Tank.yaml |
| Device Service | device-modbus |
| Host | 172.17.0.1 |
| Port | 5020 |
| Unit Identifier | 1 |
| Auto Events | Interval: 1s, Resource: GetAllValues |

### Onboarding an OPC UA Device

**Upload Profile:** Choose `FlowController.yaml` from provision-data/profiles.

**Add Device:**

| Setting | Value |
|---------|-------|
| Name | Flow-Controller |
| Protocol | OPC-UA |
| Address | 172.17.0.1:49947 |
| Device Profile | Flow-Controller.yaml |
| Device Service | device-opc-ua |
| Auto Events | Interval: 1s, Resource: GetAllValues |

## REST API Method

### Onboarding Modbus via REST

**Upload Profile:**
```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@provision-data/profiles/ChemicalTank.yaml"
```

**Create Device:**
```bash
curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "Chemical-Tank",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "protocols": {
        "modbus-tcp": {
          "Address": "172.17.0.1",
          "Port": 5020,
          "UnitID": 1
        }
      },
      "serviceName": "device-modbus",
      "properties": {
        "IOTech_ProtocolName": "modbus-tcp"
      },
      "profileName": "Chemical-Tank",
      "autoEvents": [{
        "interval": "1s",
        "onChange": false,
        "sourceName": "GetAllValues"
      }]
    }
  }]'
```

**Query Data:**
```bash
curl http://localhost:59882/api/v3/device/name/Chemical-Tank/Temperature
```

### Onboarding OPC UA via REST

**Upload Profile:**
```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@provision-data/profiles/FlowController.yaml"
```

**Create Device:**
```bash
curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "Flow-Controller",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "protocols": {
        "OPC-UA": {
          "Address": "172.17.0.1:49947"
        }
      },
      "serviceName": "device-opc-ua",
      "properties": {
        "IOTech_ProtocolName": "opc-ua"
      },
      "profileName": "Flow-Controller",
      "autoEvents": [{
        "interval": "1s",
        "onChange": false,
        "sourceName": "GetAllValues"
      }]
    }
  }]'
```

**Query Data:**
```bash
curl http://localhost:59882/api/v3/device/name/Flow-Controller/Valve
```

---

# 4. Time Series Storage

## Overview

This section demonstrates how to create an Edge Central Application Service that exports data to InfluxDB. The default docker-compose files configure InfluxDB with the security token "custom-token."

## Edge Central UI Method

1. Navigate to `http://localhost:9090`
2. Go to **App Services** > **Add App Service**
3. Enter "Influx" as the service name
4. On the Functions Pipeline page, drag and drop the **InfluxDB** function

### InfluxDB Function Settings

| Configuration Field | Value |
|---|---|
| InfluxDBServerURL | http://influxdb:8086 |
| InfluxDBOrganization | my-org |
| InfluxDBBucket | my-bucket |
| InfluxDBMeasurements | readings |
| Authentication Mode | Token |
| Token | custom-token |

## Command Line Method

```bash
edgecentral up app-service -p ./provision-data/app-services/influx.yaml
```

## Data Verification

```bash
docker exec -it influxdb /bin/sh
influx query 'from(bucket: "my-bucket") |> range(start: -3s) |> filter(fn: (r) => r["_measurement"] == "readings" and r["resourceName"] == "Temperature")'
```

---

# 5. Dashboarding with Grafana

## Grafana UI Configuration

Access Grafana at `http://localhost:3000` with default credentials admin/admin.

### Create InfluxDB Data Source

| Field | Value |
|-------|-------|
| Name | InfluxDB |
| Query Language | Flux |
| HTTP / URL | http://influxdb:8086 |
| Auth / Basic auth | Disabled |
| Organization | my-org |
| Token | custom-token |
| Default Bucket | my-bucket |

### Import Dashboard

1. Select **Dashboards** > **New** > **Import**
2. Upload the **Grafana.json** file from `provision-data/grafana/loadable`
3. Select **Import**

## Grafana REST API Configuration

### Configure Data Source
```bash
curl http://admin:admin@localhost:3000/api/datasources \
  -H "Content-Type:application/json" -X POST \
  -d '{
    "name": "InfluxDB",
    "type": "influxdb",
    "url": "http://influxdb:8086",
    "access":"proxy",
    "basicAuth":false,
    "jsonData": {
      "organization": "my-org",
      "defaultBucket": "my-bucket",
      "version": "Flux"
    },
    "secureJsonData": {
      "token": "custom-token"
    }
  }'
```

### Load Dashboard
```bash
curl http://admin:admin@localhost:3000/api/dashboards/db \
  -H "Content-Type:application/json" -X POST \
  -d '{
    "dashboard":'"$(cat provision-data/grafana/loadable/Grafana.json | tr -d '\t\n\r ')"'
  }'
```

---

# 6. Edge Rules

## Overview

Edge Central supports executing rules at the edge through Kuiper and Node-RED as out-of-the-box options. This tutorial demonstrates using Node-RED to implement a control rule that opens the Flow Controller's Valve when Chemical Tank sensor values exceed a configurable maximum threshold (initially set to 75).

## Node-RED Setup

### Node-RED UI Method

Access Node-RED at `http://localhost:1880`:

1. Select **Import** from the top-right options menu
2. Upload the `flows.json` file from the nodered directory
3. Click **Import**, then **Deploy**

### Node-RED REST API Method

```bash
curl http://localhost:1880/flows \
  -H "Content-Type:application/json" \
  -X POST \
  --data-binary "@provision-data/nodered/flows.json"
```

## Export to Node-RED

### Edge Central UI Approach

1. Navigate to **App Services** > **Add App Service**
2. Enter "Node-RED" as the name
3. Add MQTT function to the pipeline:
   - **Broker Address**: `tcp://mqtt-broker:1883`
   - **Topic**: `MyTopic`

### Command Line Approach

```bash
edgecentral up app-service -p ./provision-data/app-services/nodered-mqtt.yaml
```

## Adjusting the Maximum Value

**Via Edge Central UI:**
Select **Control** on Chemical-Tank device, choose **Maximum**, enter new value (e.g., 50), and execute.

**Via Command Line:**
```bash
curl -X PUT http://localhost:59882/api/v3/device/name/Chemical-Tank/Maximum \
  -d '{"Maximum":50}'
```

---

# 7. Cloud Integration

## Overview

This section demonstrates streaming sensor data to cloud endpoints using Application Services. The tutorial uses HiveMQ as an example, though the platform supports AWS and Microsoft Azure.

## Edge Central UI Method

1. Navigate to **App Services** > **Add App Service**
2. Enter "HiveMQ" as the service name
3. Add MQTT function to the pipeline:
   - **Broker Address**: `tcp://broker.hivemq.com:1883`
   - **Topic**: `Chemical-Tank`

## Command Line Method

```bash
edgecentral up app-service -p ./provision-data/app-services/hive-mqtt.yaml
```

## Verification

1. Visit the HiveMQ WebSocket Client at `http://www.hivemq.com/demos/websocket-client/`
2. Click Connect
3. Subscribe to topic `Chemical-Tank`
4. Observe JSON-formatted sensor readings arriving in real-time

---

# 8. Stop Edge Central

### Stop Command (Preserves State)
```bash
edgecentral stop
```
Halts all running microservices while keeping containers and their associated state intact. A subsequent `edgecentral up` command will cause the microservices to pick up where they were stopped.

### Down Command (Also Preserves State)
```bash
edgecentral down
```

### Clean Command (Removes All State)
```bash
edgecentral clean
```
Stops all running microservices, deletes all containers, and deletes any volumes or networks. All Edge Central state is lost.

### Stopping Simulators
```bash
docker stop modbus-sim
docker stop opc-ua-sim
```

---

# Automated Provisioning

## Overview

The Provision service simplifies Edge Central deployment by automating configuration across all microservices. It handles device profile uploads, device onboarding, Node-RED flow rules, Grafana data sources and dashboards, and application service startup for data export.

## Startup

```bash
sh startup.sh
```

This command initializes 18 containers including core services, device services, supporting services, provision service, UI and authentication services.

The startup script performs validation checks:
- Metadata Service availability
- Device Service registration
- Node-RED readiness
- Grafana configuration
- Flow upload success
- Dashboard availability

Upon successful completion, the system displays "Chemical Tank Demo Ready."

## Shutdown

```bash
sh shutdown.sh
```

Removes all running services, networks, and data volumes. Verify with:
```bash
edgecentral status
```
