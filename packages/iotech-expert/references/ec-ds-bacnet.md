<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-sim.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-bbmd.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-discovery.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-profile-generation.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-cov.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-env-variables.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-example-ip.html
    - https://docs.iotechsys.com/edge-central40/device-services/bacnet/bacnet-example-mstp.html
  Synced: 2026-03-07
-->

# BACnet Device Service

## 目錄

- [Overview](#overview)
  - [Key Features](#key-features)
  - [Supported Data Types](#supported-data-types)
  - [Device Profile Attributes](#device-profile-attributes)
  - [Protocol Properties](#protocol-properties)
  - [Priority Levels](#priority-levels)
- [BACnet Simulated Device](#bacnet-simulated-device)
  - [Server Options](#server-options)
  - [Default Configuration](#default-configuration)
  - [MSTP Mode](#mstp-mode)
- [BACnet/IP Broadcast Management Device (BBMD)](#bacnetip-broadcast-management-device-bbmd)
  - [Foreign Device Configuration](#foreign-device-configuration)
  - [mini-bbmd Configuration](#mini-bbmd-configuration)
  - [Docker Compose Example](#docker-compose-example)
- [BACnet Discovery](#bacnet-discovery)
  - [Enabling Discovery](#enabling-discovery)
  - [Profile Generation](#profile-generation)
  - [Triggering Discovery](#triggering-discovery)
  - [Discovery Filtering](#discovery-filtering)
  - [Discovery Range](#discovery-range)
  - [Full Configuration Example](#full-configuration-example)
  - [Custom Provision Watcher](#custom-provision-watcher)
  - [Query by Labels](#query-by-labels)
  - [Multi-Subnet via Macvlan](#multi-subnet-via-macvlan)
- [BACnet Profile Auto Generation](#bacnet-profile-auto-generation)
  - [Via REST API](#via-rest-api)
  - [Filtered Generation](#filtered-generation)
  - [Via Environment Variables](#via-environment-variables)
- [BACnet COV (Change of Value)](#bacnet-cov-change-of-value)
  - [Notification Types](#notification-types)
  - [Configuration](#configuration)
- [BACnet Optional Environment Variables](#bacnet-optional-environment-variables)
  - [BACnet/IP Variables](#bacnetip-variables)
  - [BACnet/MSTP Variables](#bacnetmstp-variables)
  - [Discovery Variables](#discovery-variables)
- [BACnet/IP Example](#bacnetip-example)
  - [Start Service](#start-service)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Verify](#verify)
- [BACnet/MSTP Example](#bacnetmstp-example)
  - [Preconfiguration](#preconfiguration)
  - [Start](#start)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Verify](#verify)


## Overview

The BACnet Device Service integrates the BACnet protocol with Edge Central, functioning as a BACnet client. Two variants: BACnet/IP and BACnet/MSTP, both supporting read and write operations.

### Key Features

- **Automatic Discovery**: Automatic onboarding of BACnet devices found on networks
- **Profile Generation**: Automatically generate device profiles
- **Change Of Value (COV)**: Subscribe to resource changes on devices
- **Multi Reads and Writes**: Automatically batch multiple properties in a single command

### Supported Data Types

| BACnet Type | Edge Central Type | Read/Write |
|---|---|---|
| Boolean | Bool | RW |
| Enumerated | Uint32 | RW |
| Unsigned Int | Uint64 | RW |
| Signed Int | Int32 | RW |
| Real | Float32 | RW |
| Double | Float64 | RW |
| Character String | String | RW |
| Date | String | R |
| Time | String | R |
| Octet String | Uint8Array | R |
| Bit String | Uint8Array | R |
| BACnetObjectIdentifier | String | R |
| Null | N/A | RW |

**Array Support**: BACnet arrays return as comma-separated values in String format.

### Device Profile Attributes

| Attribute | Type | Required | Purpose |
|---|---|---|---|
| `type` | Uint32 | Yes | BACnet object type enumeration |
| `instance` | Uint32 | Yes | Object instance number |
| `property` | Uint32 | Yes | Property type enumeration |
| `index` | Uint32 | No | Array element index |
| `raw` | Bool | No | Read/write full APDU (requires Uint8Array) |

### Protocol Properties

| Property | Description | Valid Values |
|---|---|---|
| DeviceInstance | Network ID of BACnet device | Unsigned Integer |
| APDUTimeout | Confirmed request timeout | Default: 3000ms |
| COVIdleTimeout | COV refresh interval (minutes) | Default: 0 |
| RefreshCOVsOnRestart | Refresh COVs on device restart | Default: false |

### Priority Levels

Priority levels (1-16) can be set via URL query parameter:

```bash
curl -g --request PUT 'http://<address>:59882/api/v3/device/name/bacnet-ip-sim/analog_output_0-present-value?options={"Priority":2}' \
--header 'Content-Type: application/json' \
--data-raw '{"analog_output_0-present-value": 33.0}'
```

---

## BACnet Simulated Device

Edge Central provides `bacnet-sim` running in Docker, based on Lua scripting and the BACnet Protocol Stack.

### Server Options

| Option | Description | Default |
|--------|-------------|---------|
| `--instance` | BACnet device instance ID | 1234 |
| `--name` | Device object name | SimpleServer |
| `--script` | Lua script for device creation | 1 instance per type |
| `--populate` | Create N instances per object type | 1 |

Do not use `--populate` and `--script` simultaneously.

### Default Configuration

```yaml
bacnet-sim:
  image: iotechsys/bacnet-sim:2.0
  container_name: bacnet-sim
  hostname: bacnet-sim
  command: "--script /example-scripts/device-service-example.lua --instance 123 --name SimpleServer"
  networks:
    - edgex-network
  restart: always
  environment:
    RUN_MODE: "IP"
```

### MSTP Mode

For simulated serial connections:
```bash
socat pty,link=/tmp/virtualport,raw,echo=0 tcp:<IP_of_bacnet-sim>:55000
```

Configure `BACNET_SERIAL_INTERFACE: /tmp/virtualport` in docker-compose.yml.

---

## BACnet/IP Broadcast Management Device (BBMD)

BACnet/IP networks depend on broadcast messages. Docker confines broadcasts to the Docker network. BBMDs relay broadcast messages across multiple subnets.

### Foreign Device Configuration

| Environment Variable | Description |
|---|---|
| `BACNET_BBMD_ADDRESS` | IP address of the BBMD device |
| `BACNET_BBMD_PORT` | BBMD port |
| `BACNET_BBMD_TIME_TO_LIVE` | Registration duration (default: 60000 seconds) |

### mini-bbmd Configuration

| Variable | Description | Default |
|---|---|---|
| `BBMD_LOOSE_REGISTRATION` | Forward any sender's message | true |
| `BBMD_PORT` | Listen/broadcast port | :47808 |
| `BBMD_BROADCAST_INTERFACE` | Network adapter for broadcasts | - |
| `BBMD_IP_STACK` | IPv4-only, IPv6-only, or auto | auto |
| `BBMD_FORCE_LOCAL_IP` | IP prefixes to match and replace | - |

### Docker Compose Example

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      DEVICE_DISCOVERY_INTERVAL: 1h
      BACNET_BBMD_ADDRESS: 'host.docker.internal'
      BACNET_BBMD_PORT: '47808'
      BACNET_PORT: '47809'
    extra_hosts:
      - "host.docker.internal:host-gateway"
    ports:
      - mode: ingress
        protocol: udp
        published: "47809"
        target: 47809

  mini-bbmd:
    environment:
      BBMD_LOOSE_REGISTRATION: 'true'
      BBMD_PORT: 47808
      BBMD_IP_STACK: 'ipv4'
      BBMD_FORCE_LOCAL_IP: 172
```

---

## BACnet Discovery

### Enabling Discovery

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
```

### Profile Generation

```yaml
XRTCONTROL_DISCOVERY_AUTOPROFILESCAN: 'true'
```

### Triggering Discovery

Manual:
```bash
curl -X POST http://localhost:59980/api/v3/discovery
```

Automatic:
```yaml
DEVICE_DISCOVERY_INTERVAL: 1h
```

### Discovery Filtering

```yaml
BACNET_DISCOVERY_PROPERTIES: '[85]'      # present-value
BACNET_DISCOVERY_OBJECTS: '[0,1]'         # analog input/output
```

### Discovery Range

```yaml
XRTCONTROL_DISCOVERY_EXTENDEDOPTIONS: |
  {
    "DiscoveryDeviceRange": [0, 999]
  }
```

Or by IP:
```yaml
XRTCONTROL_DISCOVERY_EXTENDEDOPTIONS: |
  {
    "Address": "192.168.50.27",
    "Port": 47808
  }
```

### Full Configuration Example

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      DEVICE_DISCOVERY_INTERVAL: 1h
      XRTCONTROL_DISCOVERY_IDENTIFIER: 'DeviceInstance'
      XRTCONTROL_DISCOVERY_PROVISIONWATCHERADMINSTATE: 'UNLOCKED'
      XRTCONTROL_DISCOVERY_DEVICENAMEPATTERN: 'BACnet-IP-{{VendorName}}-{{DeviceInstance}}'
      XRTCONTROL_DISCOVERY_DEVICEADMINSTATE: 'LOCKED'
      XRTCONTROL_DISCOVERY_DEVICELABELS: 'Auto-Discovered,instance-{{InstanceID}},{{DeviceType}},{{VendorName}}'
      XRTCONTROL_DISCOVERY_DEVICEDESCRIPTION: '{{ModelName}}, DeviceInstance {{DeviceInstance}}'
      XRTCONTROL_DISCOVERY_PROFILENAMEPATTERN: 'BACnet-IP-{{ModelName}}'
      XRTCONTROL_DISCOVERY_PROFILELABELS: 'Auto-Discovered,{{DeviceType}},{{VendorName}}'
      XRTCONTROL_DISCOVERY_PROFILEDESCRIPTION: '{{DeviceType}} profile for {{ModelName}}'
      XRTCONTROL_DISCOVERY_AUTOPROFILESCAN: 'true'
      XRTCONTROL_DISCOVERY_AUTOEVENTS: '[{"Interval":"10s","SourceName":".*"}]'
      BACNET_DISCOVERY_PROPERTIES: '[85]'
      BACNET_DISCOVERY_OBJECTS: '[0,1]'
```

### Custom Provision Watcher

```bash
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
  --header 'Content-Type: application/json' \
  --data-raw '[{
    "provisionwatcher": {
      "apiVersion": "v3",
      "name": "Provision-Watcher-0-199",
      "adminState": "UNLOCKED",
      "identifiers": {
        "DeviceInstance": "^[01]?[0-9][0-9]?$"
      },
      "serviceName": "device-bacnet-ip",
      "discoveredDevice": {
        "profileName": "",
        "adminState": "LOCKED",
        "properties": {
          "IOTech_ProtocolName": "bacnet-ip",
          "IOTech_DeviceDescription": "Group-A, DeviceInstance {{DeviceInstance}}",
          "IOTech_DeviceLabels": ["Group-A", "BACnet-IP", "0-199"]
        }
      }
    },
    "apiVersion": "v3"
  }]'
```

### Query by Labels

```bash
curl http://localhost:59881/api/v3/device/all?labels=BACnet-IP
curl http://localhost:59881/api/v3/device/all?labels=Group-A
```

### Multi-Subnet via Macvlan

```yaml
networks:
  macvlan_net:
    name: macvlan_net
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        - subnet: 198.19.249.0/24
          gateway: 198.19.249.1

services:
  device-bacnet-ip:
    networks:
      edgex-network:
        interface_name: eth0
      macvlan_net:
        interface_name: eth1
    environment:
      BACNET_NETWORK_INTERFACE: "eth1"
```

**Notes:** Macvlan typically fails with wireless interfaces. Linux kernels block traffic between Macvlan and host. Docker Desktop on Mac/Windows doesn't support Macvlan properly.

---

## BACnet Profile Auto Generation

### Via REST API

```bash
curl -X 'POST' \
  'http://localhost:59980/api/v3/profilescan' \
  -H 'Content-Type: application/json' \
  -d '{
    "apiVersion": "v3",
    "deviceName": "bacnet-ip-sim"
  }'
```

### Filtered Generation

```bash
curl -X 'POST' \
  'http://localhost:59980/api/v3/profilescan' \
  -H 'Content-Type: application/json' \
  -d '{
    "apiVersion": "v3",
    "deviceName": "bacnet-ip-sim",
    "options": {
      "DiscoverProperties": [28, 85],
      "DiscoverObjects": [0, 1, 2]
    }
  }'
```

Profile naming: `{deviceName}_profile_{timestamp}` if omitted.

### Via Environment Variables

```yaml
services:
  device-bacnet-ip:
    environment:
      BACNET_DISCOVERY_PROPERTIES: '[28,85]'
      BACNET_DISCOVERY_OBJECTS: '[0,1,2]'
```

---

## BACnet COV (Change of Value)

COV subscriptions monitor resource changes, typically the "Present Value" property. When the value changes by more than the "COV Increment" threshold, the device sends an automatic notification.

### Notification Types

- **Unconfirmed**: No delivery verification (recommended for high-traffic networks)
- **Confirmed**: Expects acknowledgement, resends if unacknowledged

### Configuration

| Property | Purpose | Values |
|----------|---------|--------|
| `resources` | Resources to monitor | String list |
| `confirmed` | Notification type | Boolean |
| `lifetime` | Duration in seconds (0 = indefinite) | Uint16 |

```json
{
  "properties": {
    "IOTech_ProtocolName": "bacnet-ip",
    "IOTech_BACnet-COVs": [
      {
        "resources": [
          "analog_value_1:present-value",
          "analog_input_0:present-value"
        ],
        "confirmed": false,
        "lifetime": 0
      },
      {
        "resources": ["analog_value_0:present-value"],
        "confirmed": true,
        "lifetime": 60
      }
    ]
  }
}
```

Resource format: `resource_name:property-name`

---

## BACnet Optional Environment Variables

### BACnet/IP Variables

**Device Identity:**
- `BACNET_INSTANCE_ID` (Uint32): Device instance ID (default: 0)
- `BACNET_OBJECT_NAME` (String): Device name
- `BACNET_VENDOR_NAME` (String): Vendor identifier (default: "IOTech")
- `BACNET_VENDOR_ID` (Uint16): Vendor ID (default: 1313)
- `BACNET_MODEL_NAME` (String): Model name
- `BACNET_LOCATION` (String): Location (default: "UK")
- `BACNET_DESCRIPTION` (String): Description
- `BACNET_APPLICATION_SOFTWARE` (String): Software version (default: "1.2")

**Network:**
- `BACNET_NETWORK_INTERFACE` (String): Network interface name
- `BACNET_PORT` (Uint16): Communication port (default: 47808)

**Communication:**
- `BACNET_APDU_TIMEOUT` (Uint32): Timeout in ms (default: 3000)
- `BACNET_APDU_RETRIES` (Uint8): Max retries (default: 3)
- `BACNET_MULTI_BATCH_SIZE` (Uint8): Max batch size (default: 3)
- `BACNET_MULTI_READ` (Bool): Enable read batching (default: true)
- `BACNET_MULTI_WRITE` (Bool): Enable write batching (default: true)
- `BACNET_READ_PROP_MULTI_FAILOVER` (Bool): Auto-retry with batch splitting (default: true)
- `BACNET_CANCEL_STALE_COV` (Bool): Cancel unexpected COV notifications (default: true)

**BBMD:**
- `BACNET_BBMD_ADDRESS` (String): BBMD IP address
- `BACNET_BBMD_PORT` (Uint16): BBMD port (default: 47808)
- `BACNET_BBMD_TIME_TO_LIVE` (Uint16): Registration lifetime (default: 65535)

### BACnet/MSTP Variables

Unique to MSTP:
- `BACNET_SERIAL_INTERFACE` (String): RS-485 serial connection path
- `BACNET_APDU_TIMEOUT` defaults to 60000ms
- `BACNET_MULTI_BATCH_SIZE` defaults to 20

### Discovery Variables

- `DEVICE_DISCOVERY_ENABLED`: Activate discovery (default: FALSE)
- `DEVICE_DISCOVERY_INTERVAL`: Trigger frequency
- `BACNET_DISCOVERY_DURATION`: Broadcast wait duration (default: 3000ms)
- `BACNET_DISCOVERY_RETRIES`: Additional broadcast attempts (default: 1)
- `BACNET_DISCOVER_MODE`: "All", "Mandatory", or "PresentValue" (default: "All")
- `XRTCONTROL_DISCOVERY_AUTOPROFILESCAN`: Auto-generate profiles (default: FALSE)
- `BACNET_DISCOVERY_PROPERTIES`: Filter properties by enumeration
- `BACNET_DISCOVERY_OBJECTS`: Filter object types by enumeration

---

## BACnet/IP Example

### Start Service

```bash
edgecentral up device-bacnet-ip bacnet-sim
```

### Onboard via REST API

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/bacnet/bacnet-sim-profile.yml"

curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{"apiVersion":"v3","device":{"name":"bacnet-ip-sim","serviceName":"device-bacnet-ip","profileName":"bacnet-sim-profile","protocols":{"BACnet-IP":{"DeviceInstance":123}},"adminState":"UNLOCKED","operatingState":"UP"}}]'
```

Or via Address/Port:
```bash
curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{"apiVersion":"v3","device":{"name":"bacnet-ip-sim","serviceName":"device-bacnet-ip","profileName":"bacnet-sim-profile","protocols":{"BACnet-IP":{"Address":"192.168.60.123","Port":47808}},"adminState":"UNLOCKED","operatingState":"UP"}}]'
```

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/bacnet-ip-sim/analog_input_0-present-value
```

---

## BACnet/MSTP Example

### Preconfiguration

Docker compose override:
```yaml
services:
  device-bacnet-mstp:
    environment:
      BACNET_SERIAL_INTERFACE: /dev/virtualport
    volumes:
      - /dev/virtualport:/dev/virtualport
  bacnet-sim:
    environment:
      RUN_MODE: "MSTP"
```

### Start

```bash
edgecentral up bacnet-sim
```

Create virtual serial port:
```bash
sudo socat pty,link=/dev/virtualport,raw,echo=0,mode=666 tcp:$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-sim):55000
```

### Onboard via REST API

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/bacnet/bacnet-sim-profile.yml"

curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "bacnet-mstp-sim",
      "description": "Simulated BACnet device",
      "labels": ["BACnet"],
      "profileName": "bacnet-sim-profile",
      "serviceName": "device-bacnet-mstp",
      "protocols": { "BACnet-MSTP": { "DeviceInstance": 123 } },
      "properties": { "IOTech_ProtocolName": "bacnet-mstp" },
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "autoEvents": [{"interval": "5s", "onChange": false, "sourceName": "analog_input_0-present-value"}]
    }
  }]'
```

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/bacnet-mstp-sim/analog_input_0-present-value
```
