<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/s7/s7-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/s7/s7-example.html
  Synced: 2026-03-07
-->

# S7 Device Service Overview

## Overview

The S7 Device Service provides integration between Edge Central and Siemens S7 PLCs. It enables communication via the Siemens S7 protocol, with reference to the [Snap7 website](http://snap7.sourceforge.net/) for protocol specifications.

## Key Features

The service supports several operational categories:

**Singular Requests:**
- Data Block operations (Read/Write)
- Process Input Image (Read/Write)
- Process Output Image (Read/Write)
- Read Last Job Result
- Read PLC State
- Read Connection State
- Log Error Code (Write)

**Multiple Requests:**
- Data Block operations (Read/Write)
- Process Input/Output Image operations (Read/Write)

**Compatible Devices:**
- S7-300
- S7-400
- S7-1200
- S7-1500

## Supported Data Types

The service handles the following data types:
- Bool
- String
- Uint8, Uint16, Uint32, Uint64
- Int8, Int16, Int32, Int64
- Float32, Float64

## Device Profile Configuration

### Required Type Attribute

Every S7 device resource requires a `type` attribute with five possible values:

| Type | Purpose |
|------|---------|
| DB | Data Block operations |
| IPU | Output Process operations |
| IPI | Input Process operations |
| PLC | PLC operations |
| MISC | Miscellaneous operations |

### Additional Attributes by Type

**DB Type:**
- `DB_number`: Int32 (0 - 0xFFFF) - Data Block Index
- `start`: Int32 - Offset to start
- `size`: Int32 - Byte size (required for String types)

**IPU/IPI Types:**
- `start`: Int32 - Offset to start
- `size`: Int32 - Byte size (required for String types)

**PLC Type:**
- `operation`: String - Currently accepts "state"

**MISC Type:**
- `operation`: String - Accepts: "job_res" (last job result), "err_text" (error text), "conn_state" (connection state)

---

# S7 Example

## Overview

This documentation covers onboarding an S7 device to the Edge Central S7 Device Service, utilizing an S7 simulator designed for Edge Xrt.

## Prerequisites

**Important Note for Rootless Containers:** When using Podman with rootless containers, the S7 protocol simulator requires port 102. Since Podman cannot bind to ports below 1024 in rootless mode, you must configure: `net.ipv4.ip_unprivileged_port_start=102` in `/etc/sysctl.conf` and execute `sudo sysctl --system`.

## Starting the S7 Device Service

Launch the service with:
```
edgecentral up device-s7
```

## Device Onboarding Methods

### Method 1: Edge Central UI

**Prerequisites:**
- Start the UI: `edgecentral up central-ui`
- Access via browser at `localhost:9090` (credentials: admin/Admin@Edge0)

**Steps:**

1. Upload the device profile from `/usr/share/edgecentral/examples/device-services/s7/Server.yml` using the device profile upload capability

2. Onboard the device with these parameters:

| Field | Example Value | Description | Required |
|-------|---------------|-------------|----------|
| Name | S7-Device | Unique device identifier | Yes |
| Description | Example S7 Server | Additional identification info | No |
| Label | S7 | Additional identification info | No |
| Protocol | S7 | Protocol name | Yes |
| Device Profile | Server | Uploaded profile name | Yes |
| Device Service | device-s7 | Service name | Yes |
| Address | 172.17.0.1 | PLC IP address (adjust for simulator) | Yes |
| Rack | 0 | CPU rack number | Yes |
| Slot | 2 | CPU slot number | Yes |
| Properties | deviceNumber:123 | Extended device fields | No |
| Tags | machineType:appliance | Event distinguisher info | No |
| Auto Events | Interval: 5s, OnChange: false, ResourceName: DB-Test | Automated data retrieval | No |

**Note on Auto Events:** When `OnChange` is `true`, values transmit only upon change. When `false`, values transmit per schedule regardless of changes.

### Method 2: REST API

**Note:** Secure mode requires replacing localhost with the service IP address.

**Upload Device Profile:**
```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/s7/Server.yml"
```

**Onboard Device:**
```bash
curl -X 'POST' \
  'http://localhost:59881/api/v3/device' \
  -H 'Content-Type: application/json' \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "S7-Device",
      "description": "Example S7 Server",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "labels": ["S7"],
      "serviceName": "device-s7",
      "profileName": "Server",
      "autoEvents": [{
        "interval": "5s",
        "onChange": false,
        "sourceName": "DB-Test"
      }],
      "protocols": {
        "S7": {
          "IP": "172.17.0.1",
          "Rack": 0,
          "Slot": 2
        }
      },
      "properties": {
        "IOTech_ProtocolName": "s7"
      }
    }
  }]'
```

## Device Data Flow Verification

After onboarding, verify data flow through:

**Edge Central UI:**
- Use Read/Write functionality in device management
- View readings in the Data Center interface

**REST API/cURL:**

Access device data via:
```
http://localhost:59882/api/v3/device/name/{deviceName}/{commandName}
```

Example:
```bash
curl http://localhost:59882/api/v3/device/name/S7-Device/DB-Test
```

Supports both GET and PUT operations. Refer to the Core Command Microservice documentation for detailed GET/PUT specifications.

## Data Processing

Collected data integrates with Edge Central's broader ecosystem for:
- Export to supporting services
- Processing through application services
- Integration with external systems

Consult Supporting Services and Application Services documentation for advanced data handling options.
