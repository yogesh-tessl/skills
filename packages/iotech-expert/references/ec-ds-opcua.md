<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-security.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-discovery.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-profile-generation.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-browse-service.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-monitored-items.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-prosys.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-general-example.html
    - https://docs.iotechsys.com/edge-central40/device-services/opc-ua/opc-ua-security-example.html
  Synced: 2026-03-07
-->

# OPC UA Device Service

## 目錄

- [Overview](#overview)
  - [Key Features](#key-features)
  - [Subscriptions](#subscriptions)
  - [Supported Data Types](#supported-data-types)
  - [Device Profile Attributes](#device-profile-attributes)
  - [Example Device Resource](#example-device-resource)
  - [Protocol Properties](#protocol-properties)
- [OPC UA Security](#opc-ua-security)
  - [Secure Connection Policies](#secure-connection-policies)
  - [Keys and Certificates](#keys-and-certificates)
  - [Certificate Trust Configuration](#certificate-trust-configuration)
  - [File Permissions](#file-permissions)
- [OPC UA Discovery](#opc-ua-discovery)
  - [Configuration](#configuration)
  - [Deploy LDS](#deploy-lds)
  - [Deploy OPC UA Simulator](#deploy-opc-ua-simulator)
  - [Onboard the LDS](#onboard-the-lds)
  - [Custom Provision Watchers](#custom-provision-watchers)
  - [DNS Troubleshooting](#dns-troubleshooting)
- [OPC UA Profile Auto Generation](#opc-ua-profile-auto-generation)
  - [Via REST API](#via-rest-api)
- [OPC UA Browse Service](#opc-ua-browse-service)
  - [BrowsePath Structure](#browsepath-structure)
  - [NodeId Formats](#nodeid-formats)
  - [RelativePath String Format (BNF)](#relativepath-string-format-bnf)
  - [Browse Without Known NodeIds](#browse-without-known-nodeids)
  - [Generic Device Profiles](#generic-device-profiles)
- [OPC UA Monitored Items](#opc-ua-monitored-items)
  - [Data Change Monitored Items](#data-change-monitored-items)
  - [Event Monitored Items](#event-monitored-items)
- [OPC UA and Prosys](#opc-ua-and-prosys)
  - [Device Resource Attributes Mapping](#device-resource-attributes-mapping)
- [General OPC UA Example](#general-opc-ua-example)
  - [Start Service](#start-service)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Verify](#verify)
- [Secure OPC UA Example](#secure-opc-ua-example)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Verify](#verify)


## Overview

The OPC UA Device Service enables integration of OPC UA devices with Edge Central. It is based on open62541, an open-source implementation of the IEC-62541 OPC UA standard.

### Key Features

- Secure and insecure connections to remote OPC UA servers
- Reading and writing OPC UA nodes
- Monitored Item Service for monitoring Data Change and Event Items
- Browse Service capabilities
- Discovery of OPC UA endpoints

### Subscriptions

OPC UA subscriptions allow the monitoring of nodes in a remote server. Each connection establishes a distinct Subscription Item containing one or more Monitored Items. When monitored items change, the server notifies the Device Service, which returns updated values via POST command to Edge Central.

### Supported Data Types

| OPC UA Data Type | Edge Central Data Type |
|---|---|
| UA_Boolean | Bool |
| UA_Byte | Uint8 |
| UA_DateTime | Int64 |
| UA_Double | Float64 |
| UA_Float | Float32 |
| UA_Int8 | Int8 |
| UA_Int16 | Int16 |
| UA_Int32 | Int32 |
| UA_Int64 | Int64 |
| UA_String | String |
| UA_UInt16 | Uint16 |
| UA_UInt32 | Uint32 |
| UA_UInt64 | Uint64 |

### Device Profile Attributes

| Attribute | Description | Mandatory |
|---|---|---|
| `nodeAttribute` | Node attribute the resource references | Yes (unless `browseStartNodeId` defined) |
| `nodeId` | Node identifier in OPC UA server | Yes (unless `browseStartNodeId` defined) |
| `dataTypeId` | Node identifier of OPC UA data type | No (required if `nodeAttribute` = "value") |
| `browseStartNodeId` | Root node information | No |
| `browsePath` | Child node name qualified with namespace URI | No (required if `browseStartNodeId` set) |
| `browsePathNamespaceIndex` | Namespace index of node | No (required if `browseStartNodeId` set) |

### Example Device Resource

```yaml
- description: A Simulated Counter
  name: Counter1
  isHidden: false
  properties:
    valueType: Uint32
    readWrite: R
    units: String
    defaultValue: "0"
  attributes:
    dataTypeId:
      identifier: 4
      identifierType: NUMERIC
      namespaceIndex: 0
    nodeAttribute: value
    nodeId:
      identifier: Int16
      identifierType: STRING
      namespaceIndex: 5
```

### Protocol Properties

| Parameter | Type | Description | Default |
|---|---|---|---|
| Address | String | **Mandatory** - OPC UA server URI: `<address>:<port><path>` | N/A |
| SecurityPolicy | String | None, Basic256, Basic128Rsa15, Basic256Sha256, Aes128Sha256RsaOaep | None |
| Username | String | Username for authentication | N/A |
| Password | String | Password for authentication | N/A |
| SecurityMode | String | None, Sign, SignEncrypt | None |
| Certificate | String | DER file name for certificate | N/A |
| PrivateKey | String | DER file name for private key | N/A |
| ApplicationUri | String | URI associated with certificate | Empty |
| RequestedSessionTimeout | UInt32 | Inactive session timeout (ms) | 1200000 |
| SessionKeepAliveInterval | Float64 | Keep-alive interval (ms) | 1000 |
| RootNode | String | Starting point for Browse Service | Server's root folder node |
| ConnectionReadingPostDelay | UInt64 | Delay (ms) for monitored items after device addition | 0 |
| ReadBatchSize | UInt16 | Batch size for read requests | 10 |
| WriteBatchSize | UInt16 | Batch size for write requests | 10 |
| NodesPerBrowse | UInt16 | Nodes per browse request | 5 |

---

## OPC UA Security

### Secure Connection Policies

Five security levels: None (default), Basic256, Basic128Rsa15, Basic256Sha256, Aes128Sha256RsaOaep.

Each security policy corresponds to an OPC Foundation Profile identifier:

| Security Policy | OPC Foundation Profile |
|---|---|
| Basic128Rsa15 | 2061 |
| Basic256 | 2062 |
| Basic256Sha256 | 2059 |
| Aes128Sha256RsaOaep | 913 |

> **注意**：即使 SecurityPolicy 設為 None，部分 OPC UA 伺服器在使用者名稱/密碼驗證時仍要求金鑰與憑證，以加密傳輸過程中的認證資訊。在這些情境下，OPC UA Device Service 仍必須提供金鑰和憑證。

### Keys and Certificates

Security credentials must be provided as `.der` files in the `/keys` directory within the OPC UA Device Service container.

#### Certificate Generation

憑證產生需同時下載 `create_self-signed.py` 與 `localhost.cnf` 設定檔（皆來自 Open62541 OPC UA 函式庫的 GitHub 儲存庫）。

```bash
python3 create_self-signed.py
```

#### Docker Configuration

```yaml
services:
  device-opc-ua:
    volumes:
      - /your/path/to/keys:/keys
```

### Certificate Trust Configuration

OPC UA servers typically reject initial connection attempts until the certificate is explicitly trusted. In Prosys, navigate to Expert Mode Options -> Certificates, then trust the certificate. Restart the device service:

```bash
edgecentral restart device-opc-ua
```

### File Permissions

```bash
chmod 644 server_cert.der
chmod 644 server_key.der
```

---

## OPC UA Discovery

The OPC UA Device Service enables automatic discovery of OPC UA endpoints, generates device profiles, and onboards new devices. Requires an OPC UA Local Discovery Server (LDS). Discovery 預設探索間隔為 30 秒。

### Configuration

```yaml
services:
  device-opc-ua:
    environment:
      LDSName: LDS
      DEVICE_DISCOVERY_ENABLED: 'true'
      XRTCONTROL_DISCOVERY_IDENTIFIER: 'Address'
      XRTCONTROL_DISCOVERY_AUTOPROFILESCAN: 'true'
```

### Deploy LDS

```bash
docker run --rm -d --network=host --hostname=192.168.1.101 \
  --name opc-ua-lds iotechsys/opc-ua-lds:1.3
```

For secure servers:
```bash
docker run --rm -it --network=host --name opc-ua-lds \
  -v /path/to/keys:/keys/ iotechsys/opc-ua-lds:1.3 \
  urn:open62541.server.application /keys/server_cert.der /keys/server_key.der
```

### Deploy OPC UA Simulator

```bash
docker run --rm -d --network=host --hostname=192.168.1.102 \
  --name opc-ua-sim iotechsys/opc-ua-sim:1.3 \
  -l /example-scripts/simulation.lua \
  --discovery-url=opc.tcp://192.168.1.101:4840
```

### Onboard the LDS

Create LDS profile:
```bash
curl http://192.168.1.103:59881/api/v3/deviceprofile \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "profile": {
      "name": "LDS_profile",
      "apiVersion": "v3",
      "description": "LDS profile",
      "deviceResources": [{
        "attributes": {
          "nodeId": {
            "identifierType": "NUMERIC",
            "identifier": 2259,
            "namespaceIndex": 0
          },
          "nodeAttribute": "value",
          "dataTypeId": {
            "identifierType": "NUMERIC",
            "identifier": 852,
            "namespaceIndex": 0
          }
        },
        "description": "The Server State",
        "name": "ServerState",
        "properties": {
          "readWrite": "R",
          "valueType": "Int32"
        }
      }],
      "labels": ["opc-ua"]
    }
  }]'
```

Register LDS device:
```bash
curl http://192.168.1.103:59881/api/v3/device \
  -H "Content-Type:application/json" -X POST \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "LDS",
      "serviceName": "device-opc-ua",
      "profileName": "LDS_profile",
      "protocols": {
        "OPC-UA": {
          "Address": "192.168.1.101:4840/",
          "Security": "None"
        }
      },
      "properties": { "IOTech_ProtocolName": "opc-ua" },
      "adminState": "UNLOCKED",
      "operatingState": "UP"
    }
  }]'
```

### Custom Provision Watchers

```bash
curl --request POST 'http://192.168.1.101:59881/api/v3/provisionwatcher' \
  --header 'Content-Type: application/json' \
  --data-raw '[{
    "provisionwatcher": {
      "apiVersion": "v3",
      "name": "device-opc-ua-provisionWatcher",
      "adminState": "LOCKED",
      "identifiers": { "Address": "172.17.0.1:49947" },
      "serviceName": "device-opc-ua",
      "discoveredDevice": {
        "adminState": "LOCKED",
        "properties": {
          "IOTech_ProtocolName": "opc-ua",
          "IOTech_ProfileLabels": ["Auto-Discovered", "{{Address}}"],
          "IOTech_ProfileScanOptions": {
            "generationRequests": [{
              "browseStartNodeId": "ns=3;s=Simulation",
              "nodeAttributeWhiteList": ["nodeClass"]
            }]
          }
        }
      }
    },
    "apiVersion": "v3"
  }]'
```

### DNS Troubleshooting

```yaml
services:
  device-opc-ua:
    extra_hosts:
      machine-name: "172.17.0.1"
```

---

## OPC UA Profile Auto Generation

The service automatically generates device profiles for OPC UA endpoints by scanning nodes with specified filters.

### Via REST API

```bash
curl -X 'POST' \
  'http://localhost:59953/api/v3/profilescan' \
  -H 'Content-Type: application/json' \
  -d '{
    "apiVersion": "v3",
    "deviceName": "opc-ua-sim",
    "options": {
      "generationRequests": [
        {
          "nodeAttributeWhiteList": ["displayName", "value"],
          "browseStartNodeId": "ns=3;s=85/0:Simulation"
        }
      ]
    }
  }'
```

---

## OPC UA Browse Service

The Browse Service leverages BrowseName attributes to navigate the OPC UA Address Space without explicitly defining node identifiers.

### BrowsePath Structure

**StartingNode** (Optional): Defines where to begin browsing. Uses NodeId format. Defaults to RootNode.

**RelativePath** (Required): Sequence of References and BrowseNames.

### NodeId Formats

String: `ns=<namespaceindex>;<type>=<value>` (e.g., `i=13`, `ns=10;s=Hello:World`)

Object:
| Field | Type | Required |
|-------|------|----------|
| namespaceIndex | Number | Yes |
| identifier | String/Number | Yes |
| identifierType | STRING/NUMERIC/BYTESTRING/GUID | Yes |

### RelativePath String Format (BNF)

```
/3:Simulation/3:Counter
```

### Browse Without Known NodeIds

```yaml
browsePath:
  StartingNode:
    identifier: 85
    identifierType: NUMERIC
    namespaceIndex: 0
  RelativePath:
    Elements:
      - TargetName:
          namespaceIndex: 3
          name: Simulation
      - TargetName:
          namespaceIndex: 3
          name: Counter
```

### Generic Device Profiles

Create reusable profiles by omitting StartingNode and specifying RootNode per device instance:

**Profile:**
```yaml
name: AirConditioner
deviceResources:
  - name: Temperature
    properties:
      valueType: Float64
      readWrite: R
    attributes:
      browsePath:
        RelativePath:
          Elements:
            - TargetName:
                namespaceIndex: 3
                name: Temperature
```

**Device:**
```json
{
  "device": {
    "name": "AirConditioner1",
    "protocols": {
      "OPC-UA": {
        "Address": "opcuaserver.com:48010",
        "RootNode": "ns=3;s=AirConditioner_1"
      }
    },
    "profileName": "AirConditioner"
  }
}
```

---

## OPC UA Monitored Items

### Data Change Monitored Items

Monitor changes to Variable Value attributes. The server polls monitored items at a configurable interval.

```json
{
  "properties": {
    "IOTech_OPC-UA-Subscriptions": [
      {
        "resources": ["SimuCounter", "SimuRandom"],
        "interval": 3000
      }
    ]
  }
}
```

**Regex subscription:** `"resources": ["Simu*"]`

**Global subscription:** `"resources": [".*"]`

> The polling rate is ultimately decided by the server, meaning it can ignore this value.

### Event Monitored Items

Monitor Object events on origin nodes:

```json
{
  "properties": {
    "IOTech_OPC-UA-Subscriptions": [
      {
        "resources": ["i=2253:event"],
        "interval": 3000
      }
    ]
  }
}
```

---

## OPC UA and Prosys

The Prosys OPC UA Simulation Server is used in Edge Central examples. Switch to Expert Mode to access Address Space and retrieve node details.

### Device Resource Attributes Mapping

```yaml
attributes:
  dataTypeId:
    identifier: [numeric value]
    identifierType: NUMERIC
    namespaceIndex: [numeric value]
  nodeAttribute: value
  nodeId:
    identifier: [numeric value]
    identifierType: NUMERIC
    namespaceIndex: [numeric value]
```

> If the node information for device resources does not match the objects in the server, any requests made to them will fail.

---

## General OPC UA Example

Onboarding the Prosys OPC UA Simulation Server with an insecure connection.

### Start Service

```bash
edgecentral up device-opc-ua
```

### Onboard via REST API

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/opc-ua/prosys-opc-ua-simulation-server-profile.yaml"

curl -X POST 'http://localhost:59881/api/v3/device' \
  -H 'Content-Type: application/json' \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "Prosys-OPC-UA-Simulation-Server",
      "description": "Example OPCUA Server",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "serviceName": "device-opc-ua",
      "profileName": "Prosys-OPC-UA-Simulation-Server-Profile",
      "autoEvents": [{"interval": "5s", "onChange": false, "sourceName": "Counter1"}],
      "protocols": {
        "OPC-UA": {
          "Address": "172.17.0.1:53530/OPCUA/SimulationServer",
          "BrowseDepth": 0,
          "RequestedSessionTimeout": 1200000,
          "SecurityPolicy": "None"
        }
      },
      "properties": {"IOTech_ProtocolName": "opc-ua"}
    }
  }]'
```

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/Prosys-OPC-UA-Simulation-Server/Counter1
```

---

## Secure OPC UA Example

Connecting with Basic256Sha256 Sign and Encrypt policy.

### Onboard via REST API

```bash
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/opc-ua/prosys-opc-ua-simulation-server-profile.yaml"

curl -X 'POST' 'http://localhost:59881/api/v3/device' \
  -H 'Content-Type: application/json' \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "Prosys-OPC-UA-Simulation-Server-SECURITY",
      "description": "Example OPCUA Server",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "labels": ["OPCUA"],
      "serviceName": "device-opc-ua",
      "profileName": "Prosys-OPC-UA-Simulation-Server-Profile",
      "autoEvents": [{"interval": "5s", "onChange": false, "sourceName": "Counter1"}],
      "protocols": {
        "OPC-UA": {
          "Address": "172.17.0.1:53530/OPCUA/SimulationServer",
          "BrowseDepth": 0,
          "Certificate": "/keys/server_cert.der",
          "PrivateKey": "/keys/server_key.der",
          "ApplicationURI": "urn:open62541.server.application",
          "RequestedSessionTimeout": 1200000,
          "SecurityPolicy": "Basic256Sha256",
          "SecurityMode": "SignEncrypt"
        }
      },
      "properties": {"IOTech_ProtocolName": "opc-ua"}
    }
  }]'
```

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/Prosys-OPC-UA-Simulation-Server-SECURITY/Counter1
```
