<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-swap-operations.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-precision.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-discovery.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-simulator.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-tcp-example.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-rtu-example.html
    - https://docs.iotechsys.com/edge-central40/device-services/modbus/modbus-rtu-device.html
  Synced: 2026-03-07
-->

# Modbus Device Service

## 目錄

- [Overview](#overview)
  - [Key Features](#key-features)
  - [Batch Read Operations](#batch-read-operations)
  - [Supported Data Types](#supported-data-types)
- [Device Profile Configuration](#device-profile-configuration)
  - [Required Attributes](#required-attributes)
  - [Optional Attributes](#optional-attributes)
- [Protocol Properties](#protocol-properties)
- [Environment Variables](#environment-variables)
- [Function Codes](#function-codes)
- [Modbus Swap Operations](#modbus-swap-operations)
  - [Byte Swapping](#byte-swapping)
  - [Word Swapping](#word-swapping)
  - [Combined Byte and Word Swapping](#combined-byte-and-word-swapping)
- [Retaining Modbus Precision](#retaining-modbus-precision)
  - [Solution: Using Different Data Types](#solution-using-different-data-types)
  - [Example](#example)
- [Modbus Discovery](#modbus-discovery)
  - [TCP Parameters](#tcp-parameters)
  - [RTU Parameters](#rtu-parameters)
  - [Provision Watcher Example](#provision-watcher-example)
  - [Worked Example with Simulator](#worked-example-with-simulator)
- [Modbus Simulator](#modbus-simulator)
  - [Starting](#starting)
  - [Options](#options)
  - [Scripting Functions](#scripting-functions)
  - [Serial Connection Setup](#serial-connection-setup)
- [Modbus TCP/IP Example](#modbus-tcpip-example)
  - [Start Simulator](#start-simulator)
  - [Start Service](#start-service)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Onboard via UI](#onboard-via-ui)
  - [Verify](#verify)
- [Modbus RTU Example](#modbus-rtu-example)
  - [Preconfiguration](#preconfiguration)
  - [Onboard via REST API](#onboard-via-rest-api)
- [Modbus RTU Device (ICP DAS M-7055)](#modbus-rtu-device-icp-das-m-7055)
  - [Connect the Device](#connect-the-device)
  - [Docker Configuration](#docker-configuration)
  - [Onboard](#onboard)
  - [Verify](#verify)


## Overview

The Modbus Device Service enables integration of Modbus devices with Edge Central, supporting both serial and Ethernet protocols:

- **Modbus RTU**: Serial communication using compact binary data representation
- **Modbus TCP/IP**: Communications over TCP/IP networks, default port 502

### Key Features

- RTU and TCP/IP connection support
- Read operations from all primary tables (Coils, Discrete Inputs, Holding Registers, Input Registers)
- Write operations to Coils and Holding Registers
- Batch read operations that group contiguous registers to minimize Modbus requests
- Data type support: Int64, Uint64, Float32, Float64 with byte/word swap functionality
- Automatic device discovery capability

### Batch Read Operations

When a device command includes multiple resources, the service automatically groups resources occupying contiguous registers. Resources are batched when they use the same primary table and total batch length doesn't exceed the 125-register Modbus protocol limit.

### Supported Data Types

Bool, Uint8, Uint16, Uint32, Uint64, Int8, Int16, Int32, Int64, Float32, Float64

## Device Profile Configuration

### Required Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `primaryTable` | String | HOLDING_REGISTERS, INPUT_REGISTERS, COILS, or DISCRETES_INPUT |
| `startingAddress` | Uint16 | The address in the Modbus device |

### Optional Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `rawType` | String | INT16 or UINT16 for binary data conversion |
| `isByteSwap` | Bool | Swap bytes for little-endian to big-endian conversion |
| `isWordSwap` | Bool | Re-order 16-bit word segments |
| `boolIndex` | Uint8 | Bit position for bool values (0-15 for registers, 0 for coils/discrete inputs) |
| `stringEncoding` | String | UTF8 or ASCII encoding. Default is UTF8 |
| `stringRegisterSize` | Uint8 | Capacity for string data (1-123 registers). Default is 1 |

#### BoolIndex Example

For a 16-bit register `0000011111000001`:
- `boolIndex: 0` reads rightmost bit (returns true)
- `boolIndex: 7` reads center bit (returns true)
- `boolIndex: 15` reads leftmost bit (returns false)

## Protocol Properties

| Property | Description | Valid Values | Required |
|----------|-------------|--------------|----------|
| `UnitID` | Station identifier (up to 247) | Values up to 247 | Yes |
| `Address` | IP address for TCP; serial path for RTU | Valid IP or serial address | Yes |
| `Port` | TCP port for Modbus device | Any valid port number | Yes (TCP/IP only) |
| `BaudRate` | Serial device baud rate | Unsigned integer | Yes (RTU only) |
| `DataBits` | 7 or 8 bits | 7 or 8 | Yes (RTU only) |
| `StopBits` | 1 or 2 bits | 1 or 2 | Yes (RTU only) |
| `Parity` | N (none), E (even), or O (odd) | N, E, or O | Yes (RTU only) |
| `ReadMaxHoldingRegisters` | Max holding registers per read (default: 125) | Any UInt16 value | No |
| `ReadMaxInputRegisters` | Max input registers per read (default: 125) | Any UInt16 value | No |
| `ReadMaxBitsCoils` | Max coil bits per read (default: 2000) | Any UInt16 value | No |
| `ReadMaxBitsDiscreteInputs` | Max discrete input bits per read (default: 2000) | Any UInt16 value | No |
| `WriteMaxHoldingRegisters` | Max holding registers per write (default: 123) | Any UInt16 value | No |
| `WriteMaxBitsCoils` | Max coil bits per write (default: 1968) | Any UInt16 value | No |
| `RequestTimeout` | Response wait time in milliseconds (default: 500ms) | Any UInt32 value | No |
| `LinkRecovery` | Enables a connection error recovery mode. This will cause the connection to the device to be closed and reopened if a timeout occurs during communication with device. Timed out write requests will be re-attempted until successful. Timed out read requests will be re-attempted once. | Boolean | No |

## Environment Variables

| Variable | Type | Description |
|----------|------|-------------|
| `XRT_MODBUS_DEFAULT_TIMEOUT` | Uint32 | Default timeout in ms for devices without RequestTimeout (default: 500ms) |

## Function Codes

| Modbus Object | Function Name | Function Code |
|---------------|---------------|---------------|
| Coils | Read Coils | 1 |
| Discrete Inputs | Read Discrete Inputs | 2 |
| Holding Registers | Read Multiple Holding Registers | 3 |
| Input Registers | Read Input Registers | 4 |
| Coils | Write Multiple Coils | 15 |
| Holding Registers | Write Multiple Holding Registers | 16 |

---

## Modbus Swap Operations

The Modbus device service supports data swap operations to handle manufacturer implementation differences in byte and word ordering. Applies to: Int32, Int64, Uint32, Uint64, Float32, Float64.

### Byte Swapping

Reverses the order of bytes within each register.

```
attributes: {
  primaryTable: "INPUT_REGISTERS",
  startingAddress: "4",
  isByteSwap: "true",
  isWordSwap: "false"
}
```

**32-bit Example:**

| Register | Original | After Swap |
|----------|----------|-----------|
| 40001 | 45 41 | 41 45 |
| 40002 | 1f 85 | 85 1f |

Result: `41 45 85 1f` -> Float32: `12.345`

**64-bit Example (Float64: 123.456):**

| Register | Original | After Swap |
|----------|----------|-----------|
| 40001 | 93 40 | 40 93 |
| 40002 | 3d 4a | 4a 3d |
| 40003 | a3 70 | 70 a3 |
| 40004 | 0a d7 | d7 0a |

Result: `40 93 4a 3d 70 a3 d7 0a` -> Float64: `123.456`

### Word Swapping

Exchanges pairs of words (registers).

```
attributes: {
  primaryTable: "INPUT_REGISTERS",
  startingAddress: "4",
  isByteSwap: "false",
  isWordSwap: "true"
}
```

**32-bit Example:**

| Register | Original | After Swap |
|----------|----------|-----------|
| 40001 | 85 1f | 41 45 |
| 40002 | 41 45 | 85 1f |

Result: `41 45 85 1f` -> Float32: `12.345`

**64-bit Example (Float64: 123.456):**

| Register | Original | After Swap |
|----------|----------|-----------|
| 40001 | 4a 3d | 40 93 |
| 40002 | 40 93 | 4a 3d |
| 40003 | d7 0a | 70 a3 |
| 40004 | 70 a3 | d7 0a |

Result: `40 93 4a 3d 70 a3 d7 0a` -> Float64: `123.456`

### Combined Byte and Word Swapping

Byte-swapping occurs first, followed by word-swapping.

```
attributes: {
  primaryTable: "INPUT_REGISTERS",
  startingAddress: "4",
  isByteSwap: "true",
  isWordSwap: "true"
}
```

**32-bit Example:**

| Register | Original | After Byte Swap | After Word Swap |
|----------|----------|-----------------|-----------------|
| 40001 | 1f 85 | 85 1f | 41 45 |
| 40002 | 45 41 | 41 45 | 85 1f |

Result: `41 45 85 1f` -> Float32: `12.345`

**64-bit Example (Float64: 123.456):**

| Register | Original | After Byte Swap | After Word Swap |
|----------|----------|-----------------|-----------------|
| 40001 | 3d 4a | 4a 3d | 40 93 |
| 40002 | 93 40 | 40 93 | 4a 3d |
| 40003 | 0a d7 | d7 0a | 70 a3 |
| 40004 | a3 70 | 70 a3 | d7 0a |

Result: `40 93 4a 3d 70 a3 d7 0a` -> Float64: `123.456`

---

## Retaining Modbus Precision

When transforming Modbus data with floating-point scales (such as 0.01), precision loss can occur. For example, a reading of 26.53 might become 26 after standard transformation.

### Solution: Using Different Data Types

| Source Type | Target Type |
|-------------|------------|
| INT16 | FLOAT32 |
| INT16 | FLOAT64 |
| UINT16 | FLOAT32 |
| UINT16 | FLOAT64 |

### Example

```json
{
  "name": "humidity",
  "description": "Original value multiplied by 100",
  "properties": {
    "valuetype": "Float32",
    "readWrite": "RW",
    "units": "%"
  },
  "attributes": {
    "primaryTable": "HOLDING_REGISTERS",
    "startingAddress": 1,
    "rawType": "INT16",
    "scale": 0.01
  }
}
```

- **Read**: INT16 binary data is parsed and cast to FLOAT32
- **Write**: FLOAT32 values are cast back to INT16 before transmission

---

## Modbus Discovery

Modbus discovery uses Function Code 43 (Read Device Identification) to obtain key identification information. The service scans specified address ranges and attempts to read identification data.

Function Code 43 returns the following fields:

- **ProductName** - Name of the product
- **ProductCode** - Product code identifier
- **MajorMinorRevision** - Firmware/software revision
- **VendorName** - Name of the device vendor
- **VendorURL** - URL of the device vendor

**Important:** Not all Modbus devices implement Function Code 43.

### TCP Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| Port | UInt16 | Yes | TCP port |
| StartAddress | String | Yes | Beginning IP address |
| EndAddress | String | No | Ending IP address |

```yaml
services:
  device-modbus:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_EXTENDEDOPTIONS: |
        {
          "TCP": [
            { "Port": 502, "StartAddress": "192.168.215.1", "EndAddress": "192.168.215.10"},
            { "Port": 503, "StartAddress": "192.168.216.1"}
          ]
        }
```

### RTU Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| Device | String | Yes | Serial port device |
| StartUnit | UInt16 | Yes | Starting Modbus unit ID |
| EndUnit | UInt16 | No | Ending Modbus unit ID |
| Baud | UInt32 | Yes | Serial baud rate |
| Bits | String | No | Data-parity-stop format (default: "8-N-1") |

```yaml
services:
  device-modbus:
    environment:
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_EXTENDEDOPTIONS: |
        {
          "RTU": [
            { "Device": "/dev/ttyUSB0", "StartUnit": 1, "EndUnit": 10, "Baud": 19200},
            { "Device": "/dev/ttyUSB1", "StartUnit": 1, "Baud": 9600}
          ]
        }
```

### Provision Watcher Example

```bash
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
  --header 'Content-Type: application/json' \
  --data-raw '[{
    "provisionwatcher": {
      "name": "modbus-pw",
      "adminState": "UNLOCKED",
      "identifiers": {
        "Address": "192.168.215.[1-5]",
        "VendorName": "ABC",
        "ProductCode": "123"
      },
      "serviceName": "device-modbus",
      "discoveredDevice": {
        "profileName": "Profile-123",
        "adminState": "UNLOCKED",
        "properties": {
          "IOTech_ProtocolName": "modbus-tcp",
          "IOTech_DeviceNamePattern": "Modbus-TCP-{{Address}}",
          "IOTech_DeviceDescription": "Auto-Discovered",
          "IOTech_DeviceLabels": ["Modbus-TCP", "{{VendorName}}", "{{ProductCode}}", "{{Address}}"]
        }
      }
    },
    "apiVersion": "v3"
  }]'
```

### Worked Example with Simulator

Deploy the simulator:
```bash
docker run --rm -d -p 5020:5020 --name modbus-sim iotechsys/pymodbus-sim:1.0.5
```

Configure discovery:
```yaml
services:
  device-modbus:
    environment:
      WRITABLE_LOGLEVEL: DEBUG
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_EXTENDEDOPTIONS: |
        {
          "TCP": [
            { "Port": 5020, "StartAddress": "172.17.0.1"}
          ]
        }
```

Start and verify:
```bash
edgecentral up central-ui device-modbus

# Upload profile
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/modbus/pymodbus-sim/modbus-sample-profile.yaml"

# Create provision watcher
curl --request POST 'http://localhost:59881/api/v3/provisionwatcher' \
  --header 'Content-Type: application/json' \
  --data-raw '[{
    "provisionwatcher": {
      "name": "modbus-pw",
      "adminState": "UNLOCKED",
      "identifiers": {
        "VendorName": "IOTech",
        "ProductCode": "MODBUS-SIM"
      },
      "serviceName": "device-modbus",
      "discoveredDevice": {
        "profileName": "Modbus-Sample-Profile",
        "adminState": "UNLOCKED",
        "properties": {
          "IOTech_ProtocolName": "modbus-tcp",
          "IOTech_DeviceNamePattern": "Modbus-TCP-{{Address}}",
          "IOTech_DeviceDescription": "Auto-Discovered",
          "IOTech_DeviceLabels": ["Modbus-TCP", "{{VendorName}}", "{{ProductCode}}", "{{Address}}"]
        }
      }
    },
    "apiVersion": "v3"
  }]'

# Verify
curl http://localhost:59882/api/v3/device/all
```

---

## Modbus Simulator

### Starting

```bash
docker run -d --rm --name modbus-sim iotechsys/pymodbus-sim:1.0
```

Initializes all registers to 0, uses TCP on port 5020.

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--profile` | JSON device profile path | Zero-init registers |
| `--script` | Python script for value management | Zero-init |
| `--delay` | Seconds between `update_values()` calls | 1s |
| `--log` | Log level | info |

### Scripting Functions

**set_initial(resources)** - Sets initial values on startup:
```python
def set_initial(resources):
    this_resource = resources.get("resource name")
    this_resource.set_value(5)
```

**update_values(resources)** - Updates values at regular intervals:
```python
def update_values(resources):
    this_resource = resources.get("resource name")
    previous_value = this_resource.get_value()
    this_resource.set_value(previous_value + 3)
```

### Serial Connection Setup

Run with serial mode:
```bash
docker run -d --rm \
    --name pymodbus-sim iotechsys/pymodbus-sim:1.0 \
    --profile /sim_files/<profile>.json \
    --comm serial \
    --serial_over_tcp_port <port>
```

Create virtual serial port:
```bash
sudo socat pty,link=/dev/virtualport,raw,echo=0,mode=666 tcp:172.17.0.1:<port>
```

---

## Modbus TCP/IP Example

### Start Simulator

```bash
docker run -d --rm \
  -v /usr/share/edgecentral/examples/device-services/modbus/power-submeter/sim-files:/sim_files \
  -p 5020:5020 \
  --name modbus-sim iotechsys/pymodbus-sim:1.0 \
  --profile /sim_files/Network-Power-Meter.json \
  --script /sim_files/update-values.py
```

### Start Service

```bash
edgecentral up device-modbus
```

### Onboard via REST API

```bash
# Upload profile
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/modbus/power-submeter/sim-files/Network-Power-Meter.json"

# Register device
curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{"apiVersion":"v3","device":{"name":"Power-Submeter-Device","profileName":"Network-Power-Meter","serviceName":"device-modbus","protocols":{"modbus-tcp":{"Address":"172.17.0.1","Port":5020,"UnitID":1}}}}]'
```

### Onboard via UI

| Field | Value |
|-------|-------|
| Name | Power-Submeter-Device |
| Protocol | Modbus-TCP |
| Device Profile | Network-Power-Meter |
| Device Service | device-modbus |
| Host | 172.17.0.1 |
| Port | 5020 |
| Unit Identifier | 1 |

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/Power-Submeter-Device/Configuration
```

---

## Modbus RTU Example

### Preconfiguration

Run simulator:
```bash
docker run --rm -d -e RUN_MODE=RTU -p 50103:50103 --name modbus-sim iotechsys/modbus-sim:1.0
```

Create virtual serial port:
```bash
sudo socat pty,link=/dev/virtualport,raw,echo=0,mode=666 tcp:172.17.0.1:50103
```

Docker compose override:
```yaml
version: '3.7'
services:
  device-modbus:
    volumes:
      - /dev/virtualport:/dev/virtualport
```

### Onboard via REST API

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/modbus/power-submeter/DENT.Mod.PS6037.profile.yaml"

curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "Power-Submeter-Device",
      "protocols": {
        "modbus-rtu": {
          "Address": "/dev/virtualport",
          "BaudRate": 19200,
          "DataBits": 8,
          "Parity": "N",
          "StopBits": 1,
          "UnitID": 1
        }
      },
      "serviceName": "device-modbus",
      "properties": { "IOTech_ProtocolName": "modbus-rtu" },
      "profileName": "Network-Power-Meter"
    }
  }]'
```

---

## Modbus RTU Device (ICP DAS M-7055)

### Connect the Device

1. Attach via RS485/USB adapter
2. Verify: `dmesg | grep tty`
3. Confirm path: `ls -l /dev/ttyUSB0`

### Docker Configuration

Using devices:
```yaml
services:
  device-modbus:
    devices:
      - /dev/ttyUSB0
```

Using volumes with cgroup rules:
```yaml
services:
  device-modbus:
    group_add:
      - dialout
    volumes:
      - /dev:/dev
    device_cgroup_rules:
      - 'c 188:* rw'
```

### Onboard

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/modbus/digital-io-device/ICPDAS-M7055.yml"
```

| Field | Value |
|-------|-------|
| Name | ICPDAS-M7055 |
| Address | /dev/ttyUSB0 |
| Baud Rate | 9600 |
| Data Bits | 8 |
| Parity | None |
| Stop Bits | 1 |
| Unit Identifier | 1 |

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/ICPDAS-M7055/DO
```
