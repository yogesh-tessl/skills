<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/device-services-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/device-profiles.html
    - https://docs.iotechsys.com/edge-central40/device-services/device-profile-reference.html
    - https://docs.iotechsys.com/edge-central40/device-services/lua-scripting.html
    - https://docs.iotechsys.com/edge-central40/device-services/discovery/auto-discovery.html
    - https://docs.iotechsys.com/edge-central40/device-services/discovery/auto-discovery-rest.html
    - https://docs.iotechsys.com/edge-central40/device-services/discovery/default-provision-watchers.html
    - https://docs.iotechsys.com/edge-central40/device-services/operating-state.html
    - https://docs.iotechsys.com/edge-central40/device-services/multiple-instance.html
    - https://docs.iotechsys.com/edge-central40/device-services/tuning.html
    - https://docs.iotechsys.com/edge-central40/device-services/provisioning-examples.html
  Synced: 2026-03-07
-->

# Edge Central Device Services Overview

## 目錄

- [General Concepts](#general-concepts)
  - [Device Service Features](#device-service-features)
  - [Auto Events or Data on Demand](#auto-events-or-data-on-demand)
  - [Admin State](#admin-state)
  - [Starting a Device Service](#starting-a-device-service)
  - [Current Device Services](#current-device-services)
  - [Environment Variables](#environment-variables)
- [Device Profiles](#device-profiles)
  - [Identification Fields](#identification-fields)
  - [DeviceResources](#deviceresources)
  - [DeviceCommands](#devicecommands)
  - [Device Configuration Tool](#device-configuration-tool)
- [Device Profile Reference](#device-profile-reference)
  - [Top-Level Structure](#top-level-structure)
  - [DeviceResource Definition](#deviceresource-definition)
  - [ResourceProperties](#resourceproperties)
  - [DeviceCommand Configuration](#devicecommand-configuration)
  - [ResourceOperation](#resourceoperation)
- [Device Data Transformation (Lua Scripting)](#device-data-transformation-lua-scripting)
  - [Enabling](#enabling)
  - [Lua Script Structure](#lua-script-structure)
  - [Example: Temperature Conversion](#example-temperature-conversion)
  - [Uploading via REST API](#uploading-via-rest-api)
- [Automatic Discovery](#automatic-discovery)
  - [Supported Device Services](#supported-device-services)
  - [Enabling](#enabling)
  - [Provision Watcher Properties](#provision-watcher-properties)
  - [Customizing Discovered Devices](#customizing-discovered-devices)
  - [Customizing Device Profiles](#customizing-device-profiles)
- [Automatic Discovery with REST API](#automatic-discovery-with-rest-api)
  - [Add a Provision Watcher](#add-a-provision-watcher)
  - [Example with Custom Device Properties](#example-with-custom-device-properties)
  - [Custom Profile Properties](#custom-profile-properties)
- [Default Provision Watchers](#default-provision-watchers)
  - [Basic Configuration](#basic-configuration)
  - [Full Example](#full-example)
- [Operating State](#operating-state)
  - [Automatic Management](#automatic-management)
- [Multiple Device Service Instances](#multiple-device-service-instances)
  - [Required Configuration Changes](#required-configuration-changes)
  - [Secure Mode](#secure-mode)
- [Tuning](#tuning)
  - [Internal Message Buffer](#internal-message-buffer)
  - [Allowed Failed Device Requests](#allowed-failed-device-requests)
  - [Timeout Configuration](#timeout-configuration)
- [Provisioning Examples](#provisioning-examples)


## General Concepts

Device Services function as software connectors that communicate with physical IoT devices at the edge, including home appliances, industrial machinery, alarm systems, HVAC equipment, lighting systems, irrigation systems, drones, and traffic systems.

Data collected from devices flows to Edge Central's Core Services layer for normalization and aggregation, then distributes to Supporting Services or Application Services.

### Device Service Features

All Device Services perform the following functions:

- Register with Core Metadata service
- Obtain configuration settings
- Register with Registry Service
- Onboard and manage edge devices (provisioning)
- Support automatic device detection (see Automatic Discovery)
- Update and communicate device operating state
- Monitor for configuration changes
- Obtain sensor data and pass to Core Data microservice
- Receive and respond to actuation commands

### Auto Events or Data on Demand

Data retrieval options include:

- On-demand polling through REST API calls
- Auto events configured for specific resources at defined intervals

**Auto event configurable fields:**
- **Resource**: The resource name
- **Interval**: Specified as alphanumeric strings (e.g., "5m" for five minutes, "1hr" for one hour)
- **On Change**: Boolean indicating whether events generate only when values change

> Once the number of auto events exceeds 100, please increase the message buffer of the device service.

### Admin State

Admin State is either `LOCKED` or `UNLOCKED` per device. When `LOCKED`, device requests stop and HTTP 423 status returns to callers.

### Starting a Device Service

```bash
edgecentral up <device-service>
```

### Current Device Services

| Device Service | Port | Description | Language |
|---|---|---|---|
| BACnet (IP) | 59980 | BACnet/IP protocol integration | C |
| BACnet (MSTP) | 59981 | BACnet/MSTP protocol integration | C |
| BLE | 59951 | BLE protocol integration | C |
| CANbus | 59955 | CANbus protocol via SocketCAN | C |
| EtherNet/IP | 59959 | EtherNet/IP protocol connections | C |
| File | 59956 | File uploads from watched directories | Go |
| GPS | 59987 | GPS data reading via GPS daemon | C |
| Modbus | 59901 | Modbus TCP/IP and RTU protocols | C |
| MQTT | 59982 | MQTT protocol integration | Go |
| ONVIF Camera | 59984 | ONVIF Camera integration | C |
| OPC UA | 59953 | OPC UA protocol integration | C |
| REST | 59986 | Third-party application data pushes | Go |
| S7 | 59958 | S7 protocol integration | C |
| USB Camera | 59983 | USB camera integration | C |
| Virtual | 59900 | Testing and demonstration device service | Go |
| WebSocket | 59950 | WebSocket protocol data pushes | Go |

### Environment Variables

| Parameter | Type | Description |
|---|---|---|
| `XRTCONTROL_WRITABLE_RESPONSETIMEOUT` | Duration String | Wait time for Edge Connect service CRUD response (default: 60s) |
| `XRTCONTROL_DISCOVERY_TIMEOUT` | Duration String | Wait time for device discovery completion (default: 30s) |
| `DEVICE_ALLOWEDFAILS` | Unsigned Integer | Failed requests before automatic non-operational marking; 0 disables (default: 5) |
| `DEVICE_DEVICEDOWNTIMEOUT` | Unsigned Integer | Seconds before re-enabling non-operational devices; 0 disables (default: 60) |
| `XRT_MQTTBRIDGE_MAX_BUFFERED_MESSAGES` | Unsigned Integer | Maximum buffered message bus messages (default: 100) |
| `XRT_ENABLE_PROTOCOL_TIMING` | Boolean | Publishes average request timing to telemetry topic (default: false) |

Example:
```yaml
services:
  device-opc-ua:
    environment:
      XRT_MQTTBRIDGE_MAX_BUFFERED_MESSAGES: 400
```

---

## Device Profiles

The device profile describes a type of device within the EdgeX system. Each device managed by a device service has an association with a device profile, which defines that device type in terms of the operations that it supports.

### Identification Fields

Device profiles require a unique **Name** field. Additional optional fields include Description, Manufacturer, Model, and Labels.

### DeviceResources

Device resources represent individual sensor values that can be read from or written to. Each resource entry contains:

- **Name and Description** - for identification and documentation
- **Attributes** - service-specific values required for accessing the resource
- **Properties** - describe the value and optional processing

| Property | Purpose |
|----------|---------|
| `valueType` | Required data type (bool, int8-int64, uint8-uint64, float32/64, string, binary, or arrays) |
| `readWrite` | Specifies R (read), W (write), or RW (read-write) |
| `units` | Measurement units (e.g., Amperes, degrees Celsius) |
| `minimum`/`maximum` | Range validation for SET commands |
| `defaultValue` | Default for SET operations |
| `assertion` | Health check comparison value |
| `base`, `scale`, `offset` | Mathematical transformations applied in order |
| `mask`, `shift` | Bitwise operations on integer readings |

### DeviceCommands

Commands group multiple related resources for simultaneous access. Each command contains resource operations with:

- `deviceResource` - target resource name
- `defaultValue` - optional SET command default
- `mappings` - optional string value remapping

### Device Configuration Tool

IOTech provides a [Device Configuration Tool](https://dct.iotechsys.com/) for creating and managing device profiles graphically.

---

## Device Profile Reference

### Top-Level Structure

| Field | Type | Required | Purpose |
|-------|------|----------|---------|
| `name` | String | Yes | Unique identifier; must use unreserved RFC 3986 characters |
| `description` | String | No | Explanatory text |
| `manufacturer` | String | No | Device manufacturer information |
| `model` | String | No | Device model designation |
| `labels` | String Array | No | Categorical tags |
| `deviceResources` | Array | Yes | Defines individual device capabilities |
| `deviceCommands` | Array | No | Groups resources into executable commands |

### DeviceResource Definition

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `name` | String | Yes | Must be unique within the profile |
| `description` | String | No | Resource documentation |
| `isHidden` | Boolean | No | Controls Command Service exposure (default: false) |
| `tags` | Map | No | Arbitrary key-value metadata |
| `attributes` | Map | No | Device service-specific configuration |
| `properties` | Object | Yes | Defines value characteristics |

### ResourceProperties

| Field | Type | Required | Details |
|-------|------|----------|---------|
| `valueType` | Enum | Yes | Int8-64, Uint8-64, Float32-64, Bool, String, Binary, or array variants |
| `readWrite` | Enum | Yes | R, W, or RW |
| `units` | String | No | Measurement units |
| `minimum` | String | No | Validation floor for SET commands |
| `maximum` | String | No | Validation ceiling for SET commands |
| `defaultValue` | String | No | Initial value if not specified |
| `mask` | String | No | Bit masking for unsigned integers |
| `shift` | String | No | Bit shifting for unsigned integers |
| `scale` | String | No | Multiplication factor for numeric types |
| `offset` | String | No | Additive adjustment for numeric types |
| `base` | String | No | Numeric base for calculations |
| `assertion` | String | No | Expected value for comparisons |
| `mediaType` | String | Conditional | Required when valueType is Binary |

### DeviceCommand Configuration

| Field | Type | Required | Details |
|-------|------|----------|---------|
| `name` | String | Yes | Unique command identifier within profile |
| `isHidden` | Boolean | No | Controls Command Service visibility (default: false) |
| `readWrite` | Enum | Yes | R, W, or RW |
| `resourceOperations` | Array | Yes | References to executed operations |

### ResourceOperation

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `deviceResource` | String | Yes | Must reference an existing DeviceResource |
| `defaultValue` | String | No | Default when not specified |
| `mappings` | Map | No | String-to-string transformations for GET values |

---

## Device Data Transformation (Lua Scripting)

The Device Data Transformation feature enables automatic data transformation in device services through Lua scripts. Scripts intercept collected data, apply transformations, and deliver the results to the Edge Central message bus.

### Enabling

Disabled by default. Activate via Docker Compose Override:

```yaml
services:
  device-bacnet-ip:
    environment:
      USETRANSFORMSCRIPT: "true"
```

### Lua Script Structure

Scripts work with a predefined `data` variable representing an Edge Central Event containing:

- `deviceName`, `profileName`, `sourceName`
- `readings` array with: `origin`, `deviceName`, `profileName`, `resourceName`, `valueType`, `units`, `value`

With Lua enabled, `value` maintains its original data type instead of converting to string, enabling direct mathematical operations.

### Example: Temperature Conversion

```lua
for k,v in pairs(data.readings) do
  if v.units == 'C' then
    data.readings[k].units = 'F'
    data.readings[k].value = data.readings[k].value * 9 / 5 + 32
  end
end
```

### Uploading via REST API

```bash
curl -X 'PATCH' \
  'http://<core-metadata-address>/api/v3/deviceservice' \
  -H 'Content-Type: application/json' \
  -d '[{
    "apiVersion": "v3",
    "service": {
      "name": "device-bacnet-ip",
      "transformScript": "<path>/<to>/<file>/celsius-to-fahrenheit.lua"
    }
  }]'
```

---

## Automatic Discovery

Automatic discovery enables Edge Central to locate and automatically add devices and device profiles with minimal configuration.

### Supported Device Services

**Device Discovery Support:** BACnet/IP, BLE, Modbus, OPC UA, ONVIF Camera, USB Camera

**Device Profile Discovery Support:** BACnet/IP, OPC UA

### Enabling

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
```

### Provision Watcher Properties

| Property | API Field | Purpose |
|----------|-----------|---------|
| Name | `name` | Watcher identifier |
| Service Name | `serviceName` | Target device service |
| Labels | `labels` | Organizational tags |
| Admin State | `adminState` | LOCKED or UNLOCKED status |
| Identifiers | `identifiers` | Filter criteria (regex supported) |
| Blocking Identifiers | `blockingIdentifiers` | Exclusion filters |
| Profile Name | `discoveredDevice.profileName` | Device profile assignment |
| Device Admin State | `discoveredDevice.adminState` | LOCKED/UNLOCKED |
| Auto Events | `discoveredDevice.autoEvents` | Automatic event configuration |
| Protocol Name | `discoveredDevice.properties.IOTech_ProtocolName` | Protocol identifier |

### Customizing Discovered Devices

| Property | API Field | Description |
|----------|-----------|-------------|
| Name Pattern | `IOTech_DeviceNamePattern` | Custom name formatting |
| Labels | `IOTech_DeviceLabels` | Override device labels |
| Description | `IOTech_DeviceDescription` | Device details |

### Customizing Device Profiles

For BACnet and OPC UA:

| Property | API Field | Description |
|----------|-----------|-------------|
| Name Pattern | `IOTech_ProfileNamePattern` | Custom profile naming |
| Labels | `IOTech_ProfileLabels` | Override profile labels |
| Description | `IOTech_ProfileDescription` | Profile details |

---

## Automatic Discovery with REST API

### Add a Provision Watcher

```bash
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
--header 'Content-Type: application/json' \
--data-raw '[
    {
       "provisionwatcher":{
          "apiVersion":"v3",
          "name":"Provision-Watcher-0-199",
          "serviceName":"device-bacnet-ip",
          "labels" : ["bacnet"],
          "identifiers":{
             "DeviceInstance":"^[01]?[0-9][0-9]?$"
          },
          "adminState":"UNLOCKED",
          "discoveredDevice":{
             "profileName": "bacnet-sim-profile",
             "adminState": "LOCKED",
             "autoEvents": [{
                 "interval": "30m",
                 "onChange": false,
                 "sourceName": "FileInfo"
               }]
          }
       },
       "apiVersion":"v3"
    }
]'
```

### Example with Custom Device Properties

```bash
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
--header 'Content-Type: application/json' \
--data-raw '[
    {
       "provisionwatcher":{
          "apiVersion":"v3",
          "name":"Provision-Watcher-0-199",
          "serviceName":"device-bacnet-ip",
          "identifiers":{
             "DeviceInstance":"^[01]?[0-9][0-9]?$"
          },
          "adminState":"UNLOCKED",
          "discoveredDevice":{
             "profileName": "bacnet-sim-profile",
             "adminState": "LOCKED",
             "autoEvents": [{
                 "interval": "30m",
                 "onChange": false,
                 "sourceName": "FileInfo"
               }],
             "properties": {
                 "IOTech_ProtocolName":"bacnet-ip",
                 "IOTech_DeviceNamePattern" : "BACnet-IP-{{ModelName}}",
                 "IOTech_DeviceLabels" : [
                     "Auto-Discovered",
                     "instance-{{InstanceID}}",
                     "{{DeviceType}}",
                     "{{VendorName}}"
                  ],
                 "IOTech_DeviceDescription" : "{{ModelName}}, DeviceInstance {{DeviceInstance}}"
             }
           }
       },
       "apiVersion":"v3"
    }
]'
```

### Custom Profile Properties

Profile auto-generation and field overriding **will not** work if you provide a profile name. Leave the profileName field empty to enable automatic profile generation with customization.

```bash
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
--header 'Content-Type: application/json' \
--data-raw '[
    {
       "provisionwatcher":{
          "apiVersion":"v3",
          "name":"Provision-Watcher-0-199",
          "serviceName":"device-bacnet-ip",
          "identifiers":{
             "DeviceInstance":"^[01]?[0-9][0-9]?$"
          },
          "adminState":"UNLOCKED",
          "discoveredDevice":{
             "profileName": "",
             "adminState": "LOCKED",
             "properties": {
                 "IOTech_ProtocolName":"bacnet-ip",
                 "IOTech_ProfileNamePattern": "BACnet-IP-{{ModelName}}",
                 "IOTech_ProfileLabels" : [
                     "Auto-Discovered",
                     "instance-{{InstanceID}}",
                     "{{DeviceType}}",
                     "{{VendorName}}"
                  ],
                 "IOTech_ProfileDescription" : "{{DeviceType}} profile for {{ModelName}}"
             }
           }
       },
       "apiVersion":"v3"
    }
]'
```

---

## Default Provision Watchers

Default provision watchers can be enabled through environment variables. Supported Device Services: BACnet/IP, OPC UA.

### Basic Configuration

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_IDENTIFIER: 'DeviceInstance'
```

The identifier uses a period (`.`) as the default value, matching all characters as a regex pattern.

### Full Example

```yaml
services:
  device-bacnet-ip:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_IDENTIFIER: 'DeviceInstance'
      XRTCONTROL_DISCOVERY_PROVISIONWATCHERADMINSTATE: 'UNLOCKED'
      XRTCONTROL_DISCOVERY_DEVICENAMEPATTERN: 'BACnet-IP-{{VendorName}}-{{DeviceInstance}}'
      XRTCONTROL_DISCOVERY_DEVICEADMINSTATE: 'LOCKED'
      XRTCONTROL_DISCOVERY_DEVICELABELS: 'Auto-Discovered,instance-{{InstanceID}},{{DeviceType}}'
      XRTCONTROL_DISCOVERY_DEVICEDESCRIPTION: '{{ModelName}}, DeviceInstance {{DeviceInstance}}'
      XRTCONTROL_DISCOVERY_PROFILENAMEPATTERN: 'BACnet-IP-{{ModelName}}'
      XRTCONTROL_DISCOVERY_PROFILELABELS: 'Auto-Discovered,{{DeviceType}}'
      XRTCONTROL_DISCOVERY_PROFILEDESCRIPTION: '{{DeviceType}} profile for {{ModelName}}'
```

---

## Operating State

A device's operating state indicates whether it is currently functioning: `UP` or `DOWN`.

When `DOWN`:
- Auto events will not be executed
- REST API requests to access the device's resources will be blocked (HTTP 423)

### Automatic Management

Supported device services: device-bacnet-ip, device-bacnet-mstp, device-ble, device-ethernet-ip, device-gps, device-modbus, device-opc-ua, device-s7.

| Property | Description | Default |
|----------|-------------|---------|
| **DeviceDownTimeout** | Seconds before marking a device back to UP | 60 (0 disables) |
| **AllowedFails** | Consecutive failed requests triggering DOWN state | 5 (0 disables) |

When a device's operating state changes, a Device Changed Notification is generated automatically.

---

## Multiple Device Service Instances

Edge Central supports running multiple instances of a specific device service simultaneously.

### Required Configuration Changes

For each additional instance:

- `EDGEX_INSTANCE_NAME`: A numeric identifier (e.g., 2, 3)
- `SERVICE_HOST`: Append `_` + instance number (e.g., `device-bacnet-ip_2`)
- `MESSAGEBUS_OPTIONAL_CLIENTID`: Match the SERVICE_HOST value
- Update `container_name`, `hostname`, and volume paths with the `_` + instance suffix

### Secure Mode

```
EDGEX_ADD_KNOWN_SECRETS: message-bus[device-bacnet-ip_2]
EDGEX_ADD_SECRETSTORE_TOKENS: device-bacnet-ip_2
MESSAGEBUS_MQTT_CLIENTS: device-bacnet-ip_2
```

---

## Tuning

### Internal Message Buffer

Default buffer size: 100. When auto event quantities exceed this, data loss occurs.

```yaml
services:
  device-opc-ua:
    environment:
      XRT_MQTTBRIDGE_MAX_BUFFERED_MESSAGES: 400
```

### Allowed Failed Device Requests

```yaml
services:
  device-opc-ua:
    environment:
      DEVICE_ALLOWEDFAILS: 5
      DEVICE_DEVICEDOWNTIMEOUT: 60
```

### Timeout Configuration

```yaml
XRTCONTROL_WRITABLE_RESPONSETIMEOUT: 60s   # CRUD response timeout
XRTCONTROL_DISCOVERY_TIMEOUT: 30s           # Discovery timeout
```

---

## Provisioning Examples

Available provisioning examples by device service type:

- **BACnet**: BACnet IP Example, BACnet MSTP Example
- **Modbus**: Modbus TCP/IP Example, Modbus RTU Example
- **MQTT**: MQTT Example
- **OPC UA**: OPC UA Example
- **REST**: REST Example
- **Virtual**: Virtual Example

Each example provides suitable commands to start all required services for the corresponding Device Service.
