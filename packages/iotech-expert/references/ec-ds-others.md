<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/ble/ble-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/canbus/canbus-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/gps/gps-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/rest/rest-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/file/file-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/websocket/websocket-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/onvif-camera/onvif-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/usb-camera/usb-camera-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/virtual/virtual-overview.html
  Synced: 2026-03-07
-->

# Other Device Services

## 目錄

- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Key Features](#key-features)
  - [GATT Characteristics](#gatt-characteristics)
- [Prerequisites](#prerequisites)
- [Supported Data Types](#supported-data-types)
- [BLE Device Profile Configuration](#ble-device-profile-configuration)
- [BLE Protocol Properties](#ble-protocol-properties)
- [Overview](#overview)
- [CANbus Device Profile](#canbus-device-profile)
  - [Attributes for Device Resources](#attributes-for-device-resources)
  - [Properties for Device Resources](#properties-for-device-resources)
  - [Supported Data Types](#supported-data-types)
  - [Example J1939 Device Resource](#example-j1939-device-resource)
- [CANbus Device Provisioning](#canbus-device-provisioning)
  - [Protocol Properties](#protocol-properties)
  - [Native CAN Network Example](#native-can-network-example)
  - [Ethernet Network Example](#ethernet-network-example)
- [Continuous Read and Processing](#continuous-read-and-processing)
- [Overview](#overview)
- [Key Features](#key-features)
- [Supported Data Types](#supported-data-types)
- [GPS Device Profile](#gps-device-profile)
- [GPS Protocol Properties](#gps-protocol-properties)
- [Overview](#overview)
- [Key Features](#key-features)
- [REST Endpoint Format](#rest-endpoint-format)
- [Supported Data Types](#supported-data-types)
- [Device Profile Configuration](#device-profile-configuration)
- [Overview](#overview)
- [Key Features](#key-features)
- [Storage Configuration](#storage-configuration)
  - [Setup Options](#setup-options)
  - [NAS Configuration](#nas-configuration)
- [Device Profile](#device-profile)
- [Protocol Properties](#protocol-properties)
- [Overview](#overview)
- [Key Features](#key-features)
  - [Connection Retry](#connection-retry)
  - [Subscription Support](#subscription-support)
  - [Health Checking (Ping/Pong)](#health-checking-pingpong)
  - [Disconnect Notifications](#disconnect-notifications)
- [Supported Data Types](#supported-data-types)
- [Device Profile Configuration](#device-profile-configuration)
  - [Splitting Object Array Events](#splitting-object-array-events)
- [Protocol Support](#protocol-support)
- [Overview](#overview)
- [Key Features](#key-features)
- [Device Profile Configuration](#device-profile-configuration)
  - [Required Attributes](#required-attributes)
  - [Additional Properties](#additional-properties)
  - [Event Handling Attributes](#event-handling-attributes)
- [Overview](#overview)
- [Key Features](#key-features)
- [System Requirements](#system-requirements)
- [Device Profile Functions](#device-profile-functions)
- [Protocol Properties](#protocol-properties)
- [RTSP Server Configuration](#rtsp-server-configuration)
- [Tested Hardware](#tested-hardware)
- [Overview](#overview)
- [Key Features](#key-features)
- [Supported Data Types](#supported-data-types)
- [Available Device Profiles](#available-device-profiles)
- [Configuration Options](#configuration-options)
  - [Minimum and Maximum Values](#minimum-and-maximum-values)
  - [Randomization Control](#randomization-control)
- [Use Cases](#use-cases)


## Table of Contents

- [BLE Device Service](#ble-device-service)
- [CANbus Device Service](#canbus-device-service)
- [GPS Device Service](#gps-device-service)
- [REST Device Service](#rest-device-service)
- [File Device Service](#file-device-service)
- [WebSocket Device Service](#websocket-device-service)
- [ONVIF Camera Device Service](#onvif-camera-device-service)
- [USB Camera Device Service](#usb-camera-device-service)
- [Virtual Device Service](#virtual-device-service)

---

# BLE Device Service

## Introduction

The BLE Device Service provides integration capabilities for Bluetooth Low Energy (BLE) devices with Edge Central, enabling communication through the Generic Attribute Profile (GATT) standard.

## Key Features

The service supports:

- **GATT Device Support**: Read and write operations on GATT characteristics
- **BLE Device Discovery**: Automated detection of BLE devices
- **Change Notifications**: Monitoring BLE characteristic value changes
- **Vendor-specific Data Conversion**: Custom conversion functions for non-standard data formats

### GATT Characteristics

Some vendor-specific GATT characteristics don't follow standard BLE data types. Devices may return data requiring conversion to usable formats. Custom conversion functions can be created to handle these scenarios.

## Prerequisites

The BLE Device Service requires:

- **BlueZ**: The official Linux Bluetooth protocol stack (GPL-licensed, part of Linux kernel since v2.4.6)
- **D-Bus**: Inter-Process Communication mechanism enabling communication between the BLE Device Service and BlueZ daemon
- **Compatibility**: Works with any GATT devices compliant with Bluetooth 5.0

## Supported Data Types

- Bool
- String
- Binary
- UInt8, UInt16, UInt32, UInt64
- Int8, Int16, Int32, Int64
- Float32, Float64

## BLE Device Profile Configuration

Device profiles define available resources via YAML attributes:

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `characteristicUuid` | String | Conditional | UUID of the characteristic (format: dashed separation) |
| `isAdvertisement` | Bool | No | Indicates advertisement packet resource |
| `isNotification` | Bool | No | Controls notification enablement for a resource |
| `deviceResource` | String | Conditional | References existing device resource for notifications |
| `serviceUuid` | String | No | Service UUID (dashed format) |
| `startByte` | Uint32 | No | Byte position for rawType conversion |
| `conversionFunction` | String | No | Conversion function identifier |
| `rawType` | String | Conditional | Binary data type descriptor for conversion |

## BLE Protocol Properties

**MAC Address**: Device identifier in format `00:00:00:00:00` (replace with device-specific address)

---

# CANbus Device Service

## Overview

The CANbus Device Service integrates the CANbus protocol with Edge Central using SocketCAN. It supports continuously reading CANbus frames (Raw or J1939 formats) from a network and processing them into Device Resources. The service also supports ethernet connections via the USR-CANET200 CAN to Ethernet Adaptor using TCP.

**Key constraint:** The CANbus Device Service is intended to self report when data is available using the continuous read and process feature, and as such there is no support for Get or Put requests.

## CANbus Device Profile

### Attributes for Device Resources

| Attribute | Purpose | Valid Values | Required |
|-----------|---------|--------------|----------|
| muxNum | Multiplexor number for decoding | UInt8 | No* |
| muxSignal | Indicates multiplexing for CAN frame | Bool | No* |
| bitStart | Start offset for data extraction | UInt64 | Yes |
| bitLen | Length of bits to read | UInt8 | Yes |
| littleEndian | Byte interpretation format | Bool (true/false) | No |
| receiverName | Name of the Receiver | String | No |

*Note: multiplexing is currently unsupported

### Properties for Device Resources

| Property | Purpose | Valid Values | Required |
|----------|---------|--------------|----------|
| scale | Scaling factor for decoding | Numeric (Integer/Float) | Yes |
| offset | Offset for decoding | Numeric (Integer/Float) | Yes |
| minVal | Minimum value constraint | Numeric (Integer/Float) | No |
| maxVal | Maximum value constraint | Numeric (Integer/Float) | No |
| unit | Resource units | String | No |

### Supported Data Types

For continuous reading and processing:
- Unsigned integers: UInt8, UInt16, UInt32, UInt64
- Signed integers: Int8, Int16, Int32, Int64
- Floating point: Float32, Float64
- Boolean: Bool

### Example J1939 Device Resource

```json
"deviceResources": [
  {
    "description": "Signal corresponding to a Message - Engine_Coolant_Temperature",
    "attributes": {
      "bitStart": 0,
      "bitLen": 8,
      "littleEndian": true
    },
    "name": "Engine_Coolant_Temperature",
    "properties": {
      "readWrite": "R",
      "valueType": "Int64",
      "minVal": -40,
      "maxVal": 210,
      "scale": 1,
      "offset": -40,
      "unit": "C"
    }
  }
]
```

## CANbus Device Provisioning

### Protocol Properties

| Property | Description | Valid Values | Required |
|----------|-------------|--------------|----------|
| Network | Network name or IP address | String | Yes |
| Standard | CAN standard (default: RAW) | RAW, J1939 | No |
| ID | CAN message identifier | 11-bit or 29-bit extended | Yes |
| DataSize | Data bytes in message | UInt16 | Yes |
| Sender | ECU sending message name | String | No |
| NetType | Network type (default: CAN) | CAN, Ethernet | No |
| CommType | Communication type (default: TCP) | TCP, UDP | No |
| Port | Connection port | UInt16 | Yes (Ethernet only) |

### Native CAN Network Example

```json
{
  "name": "canbus-device",
  "profileName": "canbus-profile",
  "protocols": {
    "CANbus": {
      "Network": "can0",
      "Standard": "J1939",
      "ID": 2365517566,
      "DataSize": 8,
      "Sender": "Motor"
    }
  }
}
```

### Ethernet Network Example

```json
{
  "name": "canbus-device",
  "profileName": "canbus-profile",
  "protocols": {
    "CANbus": {
      "Standard": "J1939",
      "ID": 2364539902,
      "DataSize": 8,
      "NetType": "Ethernet",
      "Port": 20001,
      "CommType": "TCP",
      "Network": "192.168.50.7"
    }
  }
}
```

## Continuous Read and Processing

The service continuously reads data from a CAN network, processes it into device resources, and publishes via MQTT when data arrives -- eliminating the need for explicit GET requests.

---

# GPS Device Service

## Overview

The GPS Device Service enables Edge Central to connect with GPS sensors through a local Linux GPS daemon. It retrieves positional data from connected GPS sensors and supports NMEA (National Marine Electronics Association) formatted data from marine-based GPS devices.

## Key Features

The service supports reading the following data from GPS sensors:

- Date
- Time
- Track (degrees from true north)
- Climb (vertical speed in meters per second)
- Altitude (in meters)
- Speed (ground speed in meters per second)
- Latitude (latitude positional data in degrees)
- Longitude (longitude positional data in degrees)

## Supported Data Types

| Attribute | Data Type |
|-----------|-----------|
| Date | String |
| Time | Float64 |
| Track | Float64 |
| Climb | Float64 |
| Altitude | Float64 |
| Speed | Float64 |
| Latitude | Float64 |
| Longitude | Float64 |

## GPS Device Profile

The service uses a predefined device profile that cannot be modified. The profile defines all available commands for GPS devices and is located at `/usr/share/edgecentral/examples/device-services/gps/GPS.yaml`. This same profile applies to all GPS devices in the system.

## GPS Protocol Properties

Default protocol configuration for connecting to the GPSD instance:

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `GpsdHostname` | String | Host name or IP for GPSD instance | "172.17.0.1" |
| `GpsdPort` | Unsigned Integer | Connection port | 2947 |
| `GpsdMode` | String | Connection mode (poll or nopoll) | nopoll |
| `GpsdRetries` | Unsigned Integer | Connection retry attempts | 5 |
| `GpsdConnTimeout` | Unsigned Integer | Connection timeout (milliseconds) | 2500 |
| `GpsdRequestTimeout` | Unsigned Integer | Request timeout (milliseconds) | 5000 |

Custom protocol properties can be configured when onboarding GPS devices with different requirements.

---

# REST Device Service

## Overview

The REST Device Service enables third-party applications like Point of Sale systems and CV Analytics to push data to Edge Central using HTTP protocol and perform GET/SET operations on devices.

## Key Features

- **Two-way communication**: Push data to Edge Central and send GET/PUT requests to end devices
- **Asynchronous readings**: Support for non-blocking data collection
- **POST requests**: Enable data submission from external systems
- **Parametrized endpoints**: Dynamic resource addressing

## REST Endpoint Format

Endpoints follow this structure: `/api/v3/resource/{deviceName}/{resourceName}`

Configuration requirements:
- Replace `{deviceName}` with the actual device name managed by the REST service
- Replace `{resourceName}` with the device resource defined in the device profile

When protocol parameters are configured in device properties (such as Host, Port, and Path), the service forwards device commands to the end device and supports auto events for commanding-enabled resources.

## Supported Data Types

The service handles:
- Boolean values
- String data
- Unsigned integers (8, 16, 32, 64-bit)
- Signed integers (8, 16, 32, 64-bit)
- Floating-point numbers (32 and 64-bit)
- Binary data

## Device Profile Configuration

Device profiles are defined in YAML format with these attributes:

| Attribute | Purpose | Required |
|-----------|---------|----------|
| `valueType` | Data type specification | Yes |
| `readWrite` | Access mode (read/write) | No |
| `mediaType` | HTTP content type (text/plain, application/JSON, image/jpeg, image/png) | No |

When `mediaType` is specified, the HTTP request Content-Type header must match the declared value.

---

# File Device Service

## Overview

The File Device Service enables Edge Central to export files from designated storage locations by scanning at regular intervals for new files. When detected, files are exported and their contents populate readings.

## Key Features

The service generates events when new files are created in specified storage with:
- String type containing the filename
- Object type containing file metadata

## Storage Configuration

### Setup Options

Storage can be implemented as either a single folder or network-attached storage (NAS).

**Basic folder setup:**
```
mkdir -p my-storage
```

**Docker compose volume mount:**
```
services:
  device-file:
    volumes:
      - /path/to/my-storage:/storage:ro
```

Replace the path with your actual storage location.

### NAS Configuration

If you use NAS (Network-attached storage) as the file storage system, you have to mount the NAS into your machine and then mount into the File Device Service.

## Device Profile

The service includes a predefined file device automatically initialized:

```yaml
name: "file-device"
deviceResources:
  - name: "FileInfo"
    isHidden: false
    description: "The file information"
    properties:
      valueType: "Object"
      readWrite: "R"
```

## Protocol Properties

| Field | Example | Description | Required |
|-------|---------|-------------|----------|
| Name | StoragePath | Storage path to scan | Yes |

---

# WebSocket Device Service

## Overview

The WebSocket Device Service enables third-party applications to push data into Edge Central via the WebSocket protocol (RFC 6455). It supports one-way asynchronous communication for pushing data into the system.

## Key Features

### Connection Retry
The service automatically reconnects after connection errors unless the server sends a normal closure message. Default settings attempt reconnection 10 times every 5 seconds.

Configuration via environment variables:
- `DRIVER_RETRYLIMIT`: Maximum reconnection attempts (default: 10)
- `DRIVER_RETRYPERIOD`: Time between attempts (default: 5s)

### Subscription Support
The WebSocket Device Service can send subscription messages to specify desired data. Define subscriptions using the device protocol property `subscribeTopic`.

Expected successful response format:
```json
{
  "eventType": "SubscribeWithSuccessMessage"
}
```

Failure response format:
```json
{
  "eventType": "SubscriptionWithFailure",
  "payload": "error reason"
}
```

Customizable via environment variables:
- `SUBSCRIPTION_SUCCESS_MESSAGE` (default: "SubscribeWithSuccessMessage")
- `SUBSCRIPTION_FAIL_MESSAGE` (default: "SubscriptionWithFailure")
- `DRIVER_IGNORESUBRESPPARSINGERR`: Ignore malformed responses (default: false)

### Health Checking (Ping/Pong)
Maintains active connections and detects half-open connections using RFC 6455 specifications.

Configuration environment variables:

| Field | Example | Description | Default |
|-------|---------|-------------|---------|
| DRIVER_PINGINTERVAL | 1m | Ping frequency | 0s (disabled) |
| DRIVER_PONGWAITTIMEOUT | 3m | Maximum wait for Pong | 0s (disabled) |
| DRIVER_WRITETIMEOUT | 10s | Write operation timeout | 5s |

### Disconnect Notifications
System publishes disconnect events to MQTT broker when devices disconnect. Events include device name and error details, Base64-encoded in the payload.

## Supported Data Types

**Scalar types:** Bool, String, Int8/16/32/64, Uint8/16/32/64, Float32/64

**Array types:** BoolArray, StringArray, Int8Array/16Array/32Array/64Array, Uint8Array/16Array/32Array/64Array, Float32Array/64Array

**Complex types:** Object, ObjectArray

## Device Profile Configuration

Each device resource represents a JSON payload field and requires the `jsonPath` attribute. Device commands aggregate resources into single events pushed to Core Data.

### Splitting Object Array Events

The service can split object arrays into multiple events. Requirements:

- Add `splitEvents: true` to the object array resource
- Use array syntax in jsonPath: `payload.#.fieldname`
- Each command contains only one resource with `splitEvents: true`

Example profile structure:
```yaml
deviceResources:
  - name: SerialNumber
    attributes:
      jsonPath: "sn"
  - name: Sample
    properties:
      valueType: "ObjectArray"
    attributes:
      jsonPath: "payload"
      splitEvents: true
  - name: SampleField1
    attributes:
      jsonPath: "payload.#.field1"

deviceCommands:
  - name: Sample
    resourceOperations:
      - { deviceResource: "SerialNumber" }
      - { deviceResource: "Sample" }
      - { deviceResource: "SampleField1" }
```

## Protocol Support

- Supports both `ws` (unencrypted) and `wss` (encrypted) schemes
- Connects to multiple WebSocket endpoints
- Parses incoming JSON payloads
- One-way asynchronous data push architecture

---

# ONVIF Camera Device Service

## Overview

The ONVIF Camera Device Service enables integration of ONVIF-compliant cameras with Edge Central. It provides communication capabilities for cameras using the ONVIF protocol. For additional information, visit the [ONVIF website](https://www.onvif.org/).

## Key Features

The service supports:

- User Authentication
- Auto Discovery
- Network Configuration
- System Functions
- PTZ (Pan-Tilt-Zoom) control
- Event Handling

## Device Profile Configuration

### Required Attributes

All ONVIF Camera device resources require the following attribute:

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `service` | String | Yes | The ONVIF web service name. Available values are specified in key and custom features |
| `getFunction` | String | No | ONVIF function name for get operations |
| `setFunction` | String | No | ONVIF function name for set operations |

### Additional Properties

The `IOTech_PositionTour` property allows predefined camera positioning and actions:

**Structure:**
- `interval`: Frequency of position tour execution
- `positions`: Array of position configurations with:
  - `duration`: Action duration
  - `cameraAction`: Action type (takeSnapshot/recordVideo) and storage path
  - `position`: Coordinates (x, y, z)

**Example Use Case:**
Camera moves to position (10,0,0), captures a 5-second snapshot to `/camera/data/snapshot`, then moves to position (30,0,0) to record a 5-second video to `/camera/data/video`. This cycle repeats every minute.

### Event Handling Attributes

Additional attributes for event subscription:

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `subscribeType` | String | Yes | PullPoint or BaseNotification subscription types |
| `defaultAutoRenew` | Bool | No | Auto-renew subscriptions before expiration |
| `defaultSubscriptionPolicy` | String | No | Subscription policy configuration |
| `defaultInitialTerminationTime` | String | No | Subscription lifetime (e.g., PT1H) |
| `defaultTopicFilter` | String | No | XPATH event filter (e.g., tns1:RuleEngine/TamperDetector) |
| `defaultMessageContentFilter` | String | No | Message filter expression |
| `defaultMessageTimeout` | String | No | PullMessage timeout duration (e.g., PT5S) |
| `defaultMessageLimit` | Uint16 | No | Maximum messages returned at once |

---

# USB Camera Device Service

## Overview

The USB Camera Device Service facilitates integration of USB cameras with Edge Central through a specialized device service designed for Linux environments.

## Key Features

The service supports:
- Camera metadata retrieval
- Camera status monitoring
- Video stream references

## System Requirements

The device service ONLY works on Linux with kernel v5.10 or higher. The implementation leverages:
- V4L2 API for metadata acquisition
- FFmpeg framework for video frame capture and RTSP streaming
- An embedded RTSP server within the dockerized service

## Device Profile Functions

The service defines two function categories in its predefined device profile:

**Metadata Functions (METADATA_ prefix):**
- `METADATA_DEVICE_CAPABILITY` - Driver and device information
- `METADATA_CURRENT_VIDEO_INPUT` - Active video input query
- `METADATA_CAMERA_STATUS` - Video input status
- `METADATA_IMAGE_FORMATS` - Available image format enumeration
- `METADATA_FRAMERATE_FORMATS` - Supported frame rate settings
- `METADATA_DATA_FORMAT` - Current data format
- `METADATA_CROPPING_ABILITY` - Cropping and scaling capabilities
- `METADATA_STREAMING_PARAMETERS` - Current streaming parameters

**Video Functions (VIDEO_ prefix):**
- `VIDEO_START_STREAMING` - Initiate streaming
- `VIDEO_STOP_STREAMING` - Halt streaming
- `VIDEO_GET_FRAMERATE` - Query frame rate
- `VIDEO_SET_FRAMERATE` - Configure frame rate
- `VIDEO_STREAM_URI` - Retrieve streaming URI
- `VIDEO_STREAMING_STATUS` - Monitor streaming status with FFmpeg options

## Protocol Properties

| Property | Purpose | Values | Required |
|----------|---------|--------|----------|
| Paths | Device paths for streaming | Array like `["/dev/video0"]` | Yes |
| AutoStreaming | Auto-start streaming behavior | true/false (default: false) | No |
| SerialNumber | Device identifier | String | No |
| CardName | Manufacturer name | String | No |

## RTSP Server Configuration

Environment variables control server behavior:

| Variable | Function | Default |
|----------|----------|---------|
| `DRIVER_RTSPSERVERMODE` | Mode selection (internal/external/none) | internal |
| `DRIVER_RTSPSERVEREXECUTABLE` | Configuration path | `./mediamtx` |
| `DRIVER_RTSPSERVERHOSTNAME` | Server hostname | localhost |
| `DRIVER_RTSPTCPPORT` | Server port | 8554 |
| `DRIVER_RTSPAUTHENTICATIONSERVER` | Auth server URL | localhost:8000 |

## Tested Hardware

**EdgeX-compatible devices:**
- AUKEY PC-LM1E
- HP w200
- Jinpei JW-01B
- Logitech Brio 4K
- Logitech C270 HD
- Logitech StreamCam

**Edge Central-compatible devices:**
- HP w200
- Jinpei JW-01B
- Logitech C270 HD

---

# Virtual Device Service

## Overview

The Virtual Device Service generates simulated events and readings to the Core Data microservice, enabling testing without physical devices. It supports reading and writing data through the Core Command microservice.

## Key Features

- Reading data
- Writing data

## Supported Data Types

The service handles numeric, boolean, and binary types:

- **Boolean**: Bool, BoolArray
- **Signed Integers**: Int8, Int16, Int32, Int64, and array variants
- **Unsigned Integers**: Uint8, Uint16, Uint32, Uint64, and array variants
- **Floating Point**: Float32, Float64, and array variants
- **Binary**: Binary data

The implementation uses ql, an embedded SQL database engine, for simulating virtual resources. Binary values cannot be persisted in the ql database and are always randomly generated.

## Available Device Profiles

Six pre-configured profiles are provided in `/usr/share/edgecentral/examples/device-services/virtual`:

| Profile | File |
|---------|------|
| Random-Boolean-Device | device.virtual.bool.yaml |
| Random-Integer-Device | device.virtual.int.yaml |
| Random-UnsignedInteger-Device | device.virtual.uint.yaml |
| Random-Float-Device | device.virtual.float.yaml |
| Random-Binary-Device | device.virtual.binary.yaml |

## Configuration Options

### Minimum and Maximum Values

Device resources support `minimum` and `maximum` attributes to control generated value ranges:

```yaml
deviceResources:
  - name: "Int16"
    properties:
      valueType: "Int16"
      minimum: "-100"
      maximum: "100"
      defaultValue: "0"
```

### Randomization Control

Each resource has an associated `EnableRandomization_X` boolean device resource. When true, values are randomly generated; when false, values remain fixed. Setting a value via PUT command automatically toggles randomization to false.

For binary resources, randomization uses Golang's `rand.Read()` with byte size fixed to `MaxBinaryBytes/1000`.

## Use Cases

- Learning Edge Central functionality
- Functional and performance testing
- Verifying data flows to other microservices

The service is included by default in all EdgeX Docker Compose configurations, enabling complete system setup with simulated data within minutes.
