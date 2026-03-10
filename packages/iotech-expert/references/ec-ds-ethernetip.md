<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/ethernet-ip/ethernet-ip-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/ethernet-ip/ethernet-ip-implicit.html
    - https://docs.iotechsys.com/edge-central40/device-services/ethernet-ip/ethernet-ip-explicit.html
    - https://docs.iotechsys.com/edge-central40/device-services/ethernet-ip/ethernet-ip-logixtag.html
    - https://docs.iotechsys.com/edge-central40/device-services/ethernet-ip/ethernet-ip-example.html
  Synced: 2026-03-07
-->

# EtherNet/IP Overview

## 目錄

- [Key Features](#key-features)
- [EtherNet/IP Device Profile](#ethernetip-device-profile)
- [EtherNet/IP Protocol Properties](#ethernetip-protocol-properties)
  - [Required Properties](#required-properties)
  - [Key Protocol Properties](#key-protocol-properties)
- [Overview](#overview)
- [Implicit Device Profile Configuration](#implicit-device-profile-configuration)
  - [Initialization Resources](#initialization-resources)
  - [Communication Device Resources](#communication-device-resources)
- [Implicit Protocol Properties](#implicit-protocol-properties)
  - [O2T (Outbound) Configuration](#o2t-outbound-configuration)
  - [T2O (Inbound) Configuration](#t2o-inbound-configuration)
- [Overview](#overview)
- [Explicit Device Profile Requirements](#explicit-device-profile-requirements)
- [Supported Service Codes](#supported-service-codes)
- [ExplicitConnected Protocol Properties](#explicitconnected-protocol-properties)
- [Overview](#overview)
- [Logix Tag Device Profile](#logix-tag-device-profile)
  - [Required Attributes](#required-attributes)
  - [Implementation Examples](#implementation-examples)
- [Key Capabilities](#key-capabilities)
- [Overview](#overview)
- [Start the EtherNet/IP Simulator](#start-the-ethernetip-simulator)
- [Start the EtherNet/IP Device Service](#start-the-ethernetip-device-service)
- [Device Onboarding](#device-onboarding)
  - [UI Method](#ui-method)
  - [REST API Method](#rest-api-method)
- [Device Data Flow](#device-data-flow)
  - [UI Access](#ui-access)
  - [REST Commands](#rest-commands)


## Key Features

The EtherNet/IP Device Service supports:
- Implicit communication
- Explicit communication
- Logix Tag support
- Communication with up to 16 adapter devices
- Electronic keying

## EtherNet/IP Device Profile

The device profile defines available resources on a particular device. Since the EtherNet/IP Device Service can run different communication modes, each type has its own required resources:

- Device profile for implicit communication
- Device profile for explicit communication
- Device profile for Logix Tag support

## EtherNet/IP Protocol Properties

### Required Properties

**Address** is always required for all EtherNet/IP devices:
- Description: The IP address of the device
- Valid Values: A valid device IP address

Note: When provisioning an Allen Bradley PLC for reading and writing Tags, only the IP address of the PLC is needed to correctly provision.

### Key Protocol Properties

Required only when a key is required by the device:

| Property | Description | Valid Values |
|----------|-------------|--------------|
| Method | Defines how device accepts the key (compatibility or exact match) | compatibility, exact |
| VendorID | The ID of device manufacturer | Any UInt16 value |
| DeviceType | Class of device (e.g., motor drives, I/O device) | Any UInt16 value |
| ProductCode | Product code of device | Any UInt16 value |
| MajorRevision | Major revision of device | 0 to 127 |
| MinorRevision | Minor revision of device | Any UInt8 value |

---

# Implicit EtherNet/IP Communication

## Overview

Implicit communication can be used in the EtherNet/IP Device Service. It is used for time-critical situations. Also referred to as Input/Output (I/O) messaging, this approach minimizes overhead by using Input (T2O) and Output (O2T) assemblies for efficient data transfer between controllers and remote I/O devices.

## Implicit Device Profile Configuration

### Initialization Resources

Implicit communication requires specific initialization settings configured within device profiles.

#### O2T & T2O Setting Attributes

| Attribute | Purpose | Allowed Values |
|-----------|---------|-----------------|
| `type` | Resource type identifier | O2TSettings, T2OSettings |
| `assemblyID` | Assembly instance ID | 0 to 65536 |
| `includeHeader32bit` | 32-bit header inclusion flag | true, false |
| `size` | Assembly size in bytes | 0 to 2000 |

#### Configuration Settings Attributes (Optional)

| Attribute | Purpose | Allowed Values |
|-----------|---------|-----------------|
| `type` | Resource identifier | ConfigSettings |
| `assemblyID` | Config assembly instance ID | 0 to 65535 |
| `size` | Config assembly size in bytes | 0 to 400 |

### Communication Device Resources

Device resources extract values from combined byte arrays within T2O and O2T assemblies.

#### Implicit Communication Device Attributes

| Attribute | Purpose | Allowed Values |
|-----------|---------|-----------------|
| `type` | Assembly direction | T2O, O2T |
| `offsetBytes` | Byte position within data | 0 to 2000 |
| `offsetBits` | Bit position within data | 0 to 7 |
| `bitLength` | Value length in bits | Uint8: 1-8; Uint8Array: 1-2000 |

**Note:** Maximum implicit data size per device is 2000 bytes.

## Implicit Protocol Properties

### O2T (Outbound) Configuration

| Property | Description | Valid Values |
|----------|-------------|-----------------|
| `ConnectionType` | Communication mode (peer-to-peer or multicast) | p2p, mcast |
| `RPI` | Requested Packet Interval in milliseconds | Integer milliseconds |
| `Priority` | Data exchange priority level | low, high, scheduled, urgent |
| `Ownership` | Data exclusivity setting | exclusive, inputonly, listenonly |

### T2O (Inbound) Configuration

| Property | Description | Valid Values |
|----------|-------------|-----------------|
| `ConnectionType` | Communication mode (peer-to-peer or multicast) | p2p, mcast |
| `RPI` | Requested Packet Interval in milliseconds | Integer milliseconds |
| `Priority` | Data exchange priority level | low, high, scheduled, urgent |
| `Ownership` | Data exclusivity setting | exclusive, inputonly, listenonly |

---

# Explicit EtherNet/IP Communication

## Overview

Explicit communication in EtherNet/IP operates as a client-server messaging model for asynchronous message exchange. This works best for non-real-time messaging where communication is not time critical.

## Explicit Device Profile Requirements

To implement explicit messaging, device resources require these specific attributes:

| Attribute | Purpose | Range |
|-----------|---------|-------|
| type | Resource identifier | EM |
| objClass | CIP object class number | 0-65536 |
| instID | CIP object instance ID | 0-65536 |
| attrID | CIP attribute ID | 0-65535 |
| serviceCode | CIP service command code | 0-31 |

The `attrID` is conditionally required depending on the selected service code, as certain commands are not attribute-specific.

## Supported Service Codes

**Get Attributes All (Code 1):**
- Type: GET operation
- Function: Retrieves all attributes for the specified object class and instance ID
- Supported data types: String, Uint8Array
- Access: Read-only

**Get Attribute Single (Code 14):**
- Type: GET operation
- Retrieves individual attribute values
- Requires objClass, instID, and attrID
- Supports any Edge Central data type

**Set Attribute Single (Code 16):**
- Type: PUT operation
- Writes to single attribute values
- Requires objClass, instID, and attrID
- Write-only access

**Reset (Code 5):**
- Type: PUT operation
- Function: Resets the device
- Limited to identity object class (1)
- Data type: UInt8 or Bool

**Generic (Any Code 0-49):**
- Type: GET/PUT operations
- Uses Uint8Array for flexible service code implementation
- Access depends on service code support

## ExplicitConnected Protocol Properties

For persistent explicit connections, configure these properties:

| Property | Function | Values |
|----------|----------|--------|
| DeviceResource | Selects resource for periodic keep-alive requests | Service codes 0x0E or 0x01 |
| SaveValue | Controls data persistence to Edge Central | true/false |
| RPI | Keep-alive request interval | Milliseconds |

In order to keep an explicit connection alive, an explicit request will be periodically made to a resource.

---

# EtherNet/IP Logix Tags

## Overview

The EtherNet/IP Device Service enables communication with tags created and managed by Logix controllers through the industry-standard EtherNet/IP protocol.

## Logix Tag Device Profile

### Required Attributes

Creating device resources for Logix Tags requires specific configuration parameters:

| Attribute | Purpose | Allowed Values |
|-----------|---------|-----------------|
| `type` | Specifies the resource category | `logixTag` |
| `tagName` | References the programmed tag identifier in the PLC | Any valid tag name |
| `arraySize` | Indicates array element count for bulk reads | 0-200 |

**Note on arraySize:** This attribute applies only when reading an entire array tag simultaneously. Individual array elements can be accessed without this parameter.

### Implementation Examples

The service supports multiple tag types including integers, floating-point values, and boolean arrays:

**Single Value Tags:**
```json
{
  "name": "test_dint",
  "description": "Double Integer Value",
  "attributes": {
    "type": "logixTag",
    "tagName": "test_dint"
  },
  "properties": {
    "value": {
      "type": "int16",
      "readWrite": "RW"
    }
  }
}
```

**Floating-Point Tags:**
```json
{
  "name": "test_real",
  "description": "Floating point value",
  "attributes": {
    "type": "logixTag",
    "tagName": "test_real"
  },
  "properties": {
    "value": {
      "type": "float32",
      "readWrite": "RW"
    }
  }
}
```

**Array Element Access:**
```json
{
  "name": "bool_array[0]",
  "description": "First element of bool array",
  "attributes": {
    "type": "logixTag",
    "tagName": "bool_array[0]"
  },
  "properties": {
    "value": {
      "type": "bool",
      "readWrite": "RW"
    }
  }
}
```

**Complete Array Read:**
```json
{
  "name": "bool_array",
  "description": "Complete bool array",
  "attributes": {
    "arraySize": 10,
    "type": "logixTag",
    "tagName": "bool_array"
  },
  "properties": {
    "value": {
      "type": "Uint8Array",
      "readWrite": "R"
    }
  }
}
```

## Key Capabilities

- **Individual Element Access:** Reference specific array positions like `bool_array[0]` with read/write permissions
- **Full Array Retrieval:** Read complete arrays using `Uint8Array` format (read-only)
- **Flexible Data Types:** Support for DINT, REAL, BOOL, and array structures from Studio 5000 programming

---

# EtherNet/IP Example

## Overview

This guide demonstrates onboarding an EtherNet/IP device to Edge Central, covering simulator setup, device service configuration, and data flow verification.

## Start the EtherNet/IP Simulator

Launch the simulator container:

```bash
docker run --rm -d -i --name=ethernetip-sim iotechsys/ethernetip-sim:1.0
```

Retrieve the device IP address:

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ethernetip-sim
# Returns: 172.17.0.2
```

## Start the EtherNet/IP Device Service

Initialize the device service:

```bash
edgecentral up device-ethernet-ip
```

## Device Onboarding

### UI Method

1. Start the Edge Central UI:
   ```bash
   edgecentral up central-ui
   ```

2. Access the interface at `localhost:9090` (default credentials: admin/Admin@Edge0)

3. Upload the device profile from `/usr/share/edgecentral/examples/device-services/ethernet-ip/ethernetip-sim-profile.yml`

4. Configure device with these parameters:

| Field | Value | Notes |
|-------|-------|-------|
| Name | ethernet-ip-sim | Unique identifier |
| Protocol | EtherNet/IP | Required |
| Device Profile | ethernetip-sim-profile | From uploaded file |
| Device Service | device-ethernet-ip | Required |
| Address | 172.17.0.2 | Device IP |
| Enable Explicit Connected | true | Optional |
| Device Resource | DO6 | Optional |
| RPI | 10 | Packet interval |
| Connection Type | p2p | Peer-to-peer or multicast |
| Priority | low | Implicit exchange priority |
| Ownership | exclusive | Data exclusivity setting |

### REST API Method

Upload device profile:

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/ethernet-ip/ethernetip-sim-profile.yml"
```

Add device to metadata:

```bash
curl http://localhost:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "ethernet-ip-sim",
      "description": "The simulated device",
      "labels": ["ethernet-ip"],
      "serviceName": "device-ethernet-ip",
      "profileName": "ethernetip-sim-profile",
      "protocols": {
        "ethernet-ip": {"Address": "172.17.0.2"},
        "O2T": {
          "ConnectionType": "p2p",
          "RPI": "10",
          "Priority": "low",
          "Ownership": "exclusive"
        },
        "T2O": {
          "ConnectionType": "p2p",
          "RPI": "10",
          "Priority": "low",
          "Ownership": "exclusive"
        }
      },
      "properties": {"IOTech_ProtocolName": "ethernet-ip"},
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "autoEvents": [
        {"interval": "30s", "onChange": false, "sourceName": "DO6"}
      ]
    }
  }]'
```

## Device Data Flow

### UI Access

Use the Edge Central UI to read/write device data through the Device Management interface or view readings in the Data Center.

### REST Commands

Read Implicit communication resource:

```bash
http://localhost:59882/api/v3/device/name/ethernet-ip-sim/DO6
```

Both GET and PUT operations are supported at this endpoint for device interaction and data retrieval.
