<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/opc-ua-server/opc-ua-server-overview.html
    - https://docs.iotechsys.com/edge-central40/opc-ua-server/opc-ua-server-information-modelling.html
    - https://docs.iotechsys.com/edge-central40/opc-ua-server/opc-ua-server-security.html
    - https://docs.iotechsys.com/edge-central40/opc-ua-server/opc-ua-server-env-variables.html
  Synced: 2026-03-07
-->

# Edge Central OPC UA Server

## 目錄

- [Overview](#overview)
  - [Core Features](#core-features)
  - [Startup and Connection](#startup-and-connection)
  - [Device Resource Interaction](#device-resource-interaction)
- [Information Modelling](#information-modelling)
  - [Overview](#overview)
  - [Node Modelling Example](#node-modelling-example)
  - [Key Points](#key-points)
- [Security](#security)
  - [Security Policies](#security-policies)
  - [Self-Signed Certificate Example](#self-signed-certificate-example)
  - [User Authentication](#user-authentication)
- [Environment Variables](#environment-variables)
  - [Core Configuration Parameters](#core-configuration-parameters)
  - [OPCUAServerSecurityPolicy](#opcuaserversecuritypolicy)
  - [OPCUAServerEndpoint](#opcuaserverendpoint)
  - [OPCUAServerAccessControl](#opcuaserveraccesscontrol)
  - [OPCUAServerCertificateVerification](#opcuaservercertificateverification)
  - [Device Service Settings](#device-service-settings)
  - [Configuration Example](#configuration-example)


## Overview

The OPC UA Server feature serves as a centralized interface for accessing aggregated data from southbound devices connected to Edge Central. It functions as a bridge between OPC UA client applications and Device Services (such as Modbus or BACnet), automatically mapping read/write operations to corresponding Device Resources.

The server actively monitors Device Services through the Edge Central message bus to detect changes, maintaining an up-to-date view of connected devices and services.

### Core Features

**Nodeset Loader** - Enables loading OPC UA Nodesets from XML files, allowing users to define custom address spaces for their specific needs.

**Information Mapping** - Facilitates mapping node values within the OPC UA Server to specific Edge Central Device Resources, enabling seamless data synchronization.

**OPC UA PubSub Support** - Support for OPC UA Publish Subscribe functionality can be enabled and configured through the OPC UA Server PubSub Configuration.

**Telemetry Monitoring** - The server monitors internal Device Service data and Auto Events. When receiving Device Resource value updates, it caches these values for a configurable period, reducing unnecessary requests to the Device Service.

**Security Implementation** - Provides standards-compliant security features including authentication, encryption, and certificate-based access control to ensure only authorized OPC UA Clients can establish secure sessions.

### Startup and Connection

**Starting the service:**
```bash
edgecentral up opc-ua-server device-virtual
```

Default address: `opc.tcp://172.17.0.1:4840/`

**Connecting via OPC UA Browser:**
- Pull the Docker image: `docker pull iotechsys/opc-ua-browser`
- Run the container: `docker run -d --name opc-ua-browser -p 8080:8080 iotechsys/opc-ua-browser`
- Access via web browser at `http://localhost:8080`

### Device Resource Interaction

When an OPC UA client sends a read or write request to a Device Resource, the OPC UA Server forwards that request to the corresponding Device Service and Device.

If Auto Events are active, the server processes read requests using the most recent values from those events.

---

## Information Modelling

### Overview

The OPC UA Server enables custom OPC UA Address Space definitions and Device Resource mapping to specific nodes. Users can define custom data models using industry-standard Information Model XML Schema (Nodeset) files and load them into the server.

### Node Modelling Example

This practical example demonstrates mapping two Virtual Device resources to named OPC UA nodes for Temperature and Humidity data.

#### Step 1: Create Nodeset XML File

Define the OPC UA structure with a "virtual" object containing child nodes:

```xml
<?xml version="1.0" encoding="utf-8"?>
<UANodeSet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:uax="http://opcfoundation.org/UA/2008/02/Types.xsd"
           xmlns="http://opcfoundation.org/UA/2011/03/UANodeSet.xsd"
           xmlns:s1="http://iotechsys.com/demo/Types.xsd">

  <NamespaceUris>
    <Uri>http://iotechsys.com/demo/</Uri>
  </NamespaceUris>

  <Models>
    <Model ModelUri="http://iotechsys.com/demo/"
           PublicationDate="2024-03-06T15:03:15Z"
           Version="1.0.0">
      <RequiredModel ModelUri="http://opcfoundation.org/UA/"
                     PublicationDate="2022-11-01T00:00:00Z"
                     Version="1.04"/>
    </Model>
  </Models>

  <Aliases>
    <Alias Alias="Boolean">i=1</Alias>
    <Alias Alias="UInt16">i=5</Alias>
    <Alias Alias="UInt32">i=7</Alias>
    <Alias Alias="Double">i=11</Alias>
    <Alias Alias="String">i=12</Alias>
    <Alias Alias="DateTime">i=13</Alias>
    <Alias Alias="Organizes">i=35</Alias>
    <Alias Alias="HasTypeDefinition">i=40</Alias>
    <Alias Alias="HasProperty">i=46</Alias>
    <Alias Alias="HasComponent">i=47</Alias>
  </Aliases>

  <UAObject NodeId="ns=1;s=virtual" BrowseName="1:virtual">
    <DisplayName>virtual</DisplayName>
    <References>
      <Reference ReferenceType="HasTypeDefinition">i=61</Reference>
      <Reference ReferenceType="Organizes" IsForward="false">i=85</Reference>
      <Reference ReferenceType="Organizes">ns=1;s=Temperature</Reference>
      <Reference ReferenceType="Organizes">ns=1;s=Humidity</Reference>
    </References>
  </UAObject>

  <UAVariable DataType="UInt16" NodeId="ns=1;s=Temperature"
              BrowseName="1:Temperature">
    <DisplayName>Temperature</DisplayName>
    <References>
      <Reference ReferenceType="HasTypeDefinition">i=63</Reference>
      <Reference ReferenceType="Organizes" IsForward="false">ns=1;s=virtual</Reference>
    </References>
    <Value>
      <uax:UInt16>0</uax:UInt16>
    </Value>
  </UAVariable>

  <UAVariable DataType="UInt32" NodeId="ns=1;s=Humidity"
              BrowseName="1:Humidity">
    <DisplayName>Humidity</DisplayName>
    <References>
      <Reference ReferenceType="HasTypeDefinition">i=63</Reference>
      <Reference ReferenceType="Organizes" IsForward="false">ns=1;s=virtual</Reference>
    </References>
  </UAVariable>

</UANodeSet>
```

#### Step 2: Create JSON Mapping File

Map Device Resources to OPC UA nodes:

```json
{
  "apiVersion": "v2",
  "mappings": [
    {
      "nodeIdentifier": "ns=1;s=Temperature",
      "valueMapping": {
        "serverId": "device-virtual",
        "deviceService": "device-virtual",
        "device": "Random-UnsignedInteger-Device",
        "resource": "Uint16"
      }
    },
    {
      "nodeIdentifier": "ns=1;s=Humidity",
      "valueMapping": {
        "serverId": "device-virtual",
        "deviceService": "device-virtual",
        "device": "Random-UnsignedInteger-Device",
        "resource": "Uint32"
      }
    }
  ],
  "namespaceUris": [
    "http://iotechsys.com/demo/"
  ]
}
```

#### Step 3: Configure Docker Compose

Mount the Nodeset and mapping files to the OPC UA Server:

```yaml
services:
  opc-ua-server:
    environment:
      EDGECENTRAL_NODE_SET_PATHS: >
        [
          "/node-modelling/nodeset.xml"
        ]
      EDGECENTRAL_MAPPING_PATHS: >
        [
          "/node-modelling/mapping.json"
        ]
    volumes:
      - /usr/share/edgecentral/examples/opc-ua-server/node-modelling:/node-modelling
```

#### Step 4: Run the Server

```bash
edgecentral up device-virtual opc-ua-server
```

#### Step 5: Verify with OPC UA Client

Using an OPC UA browser client, the virtual object and Temperature/Humidity nodes display the mapped structure.

### Key Points

- **Node Identifiers**: Resources map to specific OPC UA nodes using qualified identifiers (e.g., `ns=1;s=Temperature`)
- **Device Mapping**: Each mapping connects a Device Resource to a corresponding OPC UA node
- **Namespace Configuration**: Custom namespaces require definition in both the Nodeset and mapping files
- **Real-time Updates**: Node requests directly access mapped Device Resources

The example files are provided in the Edge Central installation at `/usr/share/edgecentral/examples/opc-ua-server/node-modelling`.

---

## Security

### Security Policies

The OPC UA Server supports these security policies:

- `None` (default)
- `Basic256`
- `Basic128Rsa15`
- `Basic256Sha256`
- `Aes128Sha256RsaOaep`

And these security modes:

- `None` (default)
- `Sign`
- `SignEncrypt`

Configuration occurs through `EDGECENTRAL_SECURITY_POLICIES` and `EDGECENTRAL_ENDPOINTS` environment variables.

### Self-Signed Certificate Example

To implement Basic256Sha256 security:

1. Clone the open62541 repository and create a certs directory
2. Generate certificate and key files using: `python open62541/tools/certs/create_self-signed.py -u urn:iotechsys:edgecentral certs`
3. Set appropriate file permissions: `chmod 644 server_cert.der server_key.der`
4. Mount the certs directory in your docker-compose file with these environment settings:

```yaml
EDGECENTRAL_SECURITY_POLICIES: >
  [
    {
      "SecurityPolicy": "Basic256Sha256",
      "Certificate": "/certs/server_cert.der",
      "PrivateKey": "/certs/server_key.der"
    },
    {
      "SecurityPolicy": "None"
    }
  ]
EDGECENTRAL_ENDPOINTS: >
  [
    {
      "SecurityPolicy": "Basic256Sha256",
      "MessageSecurityModes": ["SignEncrypt"]
    },
    {
      "SecurityPolicy": "None"
    }
  ]
```

**Note:** A "None" policy endpoint enables OPC UA client discovery. Use `"DiscoveryOnly": true` to restrict it to discovery operations only.

### User Authentication

Supported authentication methods:

- `Anonymous`
- `Username/Password`
- `X.509 Certificate`

Configuration uses the `EDGECENTRAL_ACCESS_CONTROL` environment variable.

#### Username/Password Example

```yaml
EDGECENTRAL_ACCESS_CONTROL: >
  {
    "AccessControlUserPassList": [{"Username":"admin", "Password":"test"}]
  }
```

#### Advanced Options

Disable anonymous authentication and enable X.509 certificates:

```yaml
EDGECENTRAL_ACCESS_CONTROL: >
  {
    "AllowAnonymous": false,
    "EnableX509": true,
    "AccessControlUserPassList": [{"Username":"admin", "Password":"test"}]
  }
```

---

## Environment Variables

### Core Configuration Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `EDGECENTRAL_APPLICATION_NAME` | String | Server instance identifier; defaults to "Edge Central OPC UA Server" |
| `EDGECENTRAL_APPLICATION_URI` | String | Globally unique server identifier; defaults to "urn:iotechsys:edgecentral" |
| `EDGECENTRAL_SERVER_PORT` | Uint16 | Server listening port; defaults to 4840 |
| `EDGECENTRAL_SECURITY_POLICIES` | Array | Security policy configurations |
| `EDGECENTRAL_ENDPOINTS` | Array | Endpoint configurations |
| `EDGECENTRAL_ACCESS_CONTROL` | Object | Authentication and authorization settings |
| `EDGECENTRAL_CERTIFICATE_VERIFICATION` | Object | X509 certificate validation setup |
| `EDGECENTRAL_PUB_SUB` | Object | Publication/subscription module configuration |
| `EDGECENTRAL_NODE_SET_PATHS` | String[] | OPC UA Nodeset XML file locations |
| `EDGECENTRAL_MAPPING_PATHS` | String[] | Node mapping JSON file paths |

### OPCUAServerSecurityPolicy

Defines security policies for server use:

**Fields:**
- **SecurityPolicy** (required): Policy type from supported list
- **Certificate**: Path to certificate file (required for non-None policies)
- **PrivateKey**: Corresponding private key path (required for non-None policies)

**Supported Policy Types:**
- None
- Basic256
- Basic128Rsa15
- Basic256Sha256
- Aes128Sha256RsaOaep

### OPCUAServerEndpoint

Configures server endpoints with specific security and messaging modes:

**Fields:**
- **SecurityPolicy** (required): Must reference configured security policy
- **DiscoveryOnly**: Boolean; restricts to discovery services only (None policy only)
- **MessageSecurityModes**: Array of security modes (None, Sign, SignEncrypt)
- **X509SecurityPolicy**: Overrides policy for X509 authentication
- **UserPassSecurityPolicy**: Overrides policy for username/password authentication

### OPCUAServerAccessControl

Manages session authentication and access rights:

**Fields:**
- **AllowAnonymous**: Boolean enabling anonymous access
- **EnableX509**: Boolean activating certificate authentication
- **AccessControlUserPassList**: Key-value pairs mapping usernames to passwords

### OPCUAServerCertificateVerification

Configures X509 certificate validation:

**Fields:**
- **TrustList**: Array of trusted certificates
- **IssuerList**: CA certificates for chain validation
- **RevocationList**: Revoked certificate identifiers

### Device Service Settings

Device services can include additional environment variables for OPC UA Server interaction:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `XRT_OPCUA_SERVER_REQUEST_TIMEOUT` | Uint32 | 5000 | Request timeout in milliseconds |
| `XRT_OPCUA_SERVER_USE_TELEMETRY_VALUES` | Boolean | true | Enable telemetry value usage |
| `XRT_OPCUA_SERVER_STALE_TELEMETRY_VALUE_TIME` | Uint64 | 15000 | Telemetry value retention duration (ms) |
| `XRT_OPCUA_SERVER_TOPIC_MIDDLEWARE_PREFIX` | String | -- | Topic prefix for subscriptions/publications |
| `XRT_OPCUA_SERVER_USE_MIDDLEWARE_PREFIX_REQUEST` | Boolean | true | Apply prefix to request topics |
| `XRT_OPCUA_SERVER_USE_MIDDLEWARE_PREFIX_REPLY` | Boolean | true | Apply prefix to reply topics |
| `XRT_OPCUA_SERVER_USE_MIDDLEWARE_PREFIX_TELEMETRY` | Boolean | true | Apply prefix to telemetry topics |
| `XRT_OPCUA_SERVER_USE_MIDDLEWARE_PREFIX_EVENT` | Boolean | true | Apply prefix to event topics |
| `XRT_OPCUA_SERVER_USE_MIDDLEWARE_PREFIX_EDGEX_EVENT` | Boolean | true | Apply prefix to EdgeX event topics |
| `XRT_OPCUA_SERVER_EDGEX_EVENT_TOPIC_BASE` | String | edgex | Base EdgeX event topic identifier |

### Configuration Example

Enable the middleware prefix by adding the following environment variable to the docker compose file: `XRT_OPCUA_SERVER_TOPIC_MIDDLEWARE_PREFIX: nodered`
