<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/overview/mqtt-overview.html
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/overview/asyncread.html
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/overview/getcommand.html
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/overview/setcommand.html
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/mqtt-sim.html
    - https://docs.iotechsys.com/edge-central40/device-services/mqtt/mqtt-example.html
  Synced: 2026-03-07
-->

# MQTT Device Service

## 目錄

- [Overview](#overview)
  - [Three Operational Modes](#three-operational-modes)
  - [MQTT Broker Configuration](#mqtt-broker-configuration)
  - [AuthMode Options](#authmode-options)
  - [Configuration Examples](#configuration-examples)
  - [Supported Data Types](#supported-data-types)
  - [Device Profile Attributes](#device-profile-attributes)
  - [Protocol Properties](#protocol-properties)
  - [Default Broker](#default-broker)
- [MQTT Asynchronous Read](#mqtt-asynchronous-read)
  - [Case 1: Binary Payload with Simple Values](#case-1-binary-payload-with-simple-values)
  - [Case 2: JSON-Formatted String Payload](#case-2-json-formatted-string-payload)
  - [Sequence Flow](#sequence-flow)
- [MQTT Get Command](#mqtt-get-command)
  - [Required Attributes](#required-attributes)
  - [Device Profile Example](#device-profile-example)
  - [Process Flow](#process-flow)
- [MQTT Set Command](#mqtt-set-command)
  - [Case 1: Simple Value (Binary)](#case-1-simple-value-binary)
  - [Case 2: JSON String](#case-2-json-string)
- [MQTT Simulator](#mqtt-simulator)
  - [Simulated Values](#simulated-values)
  - [Deployment](#deployment)
- [MQTT Example](#mqtt-example)
  - [Start Service](#start-service)
  - [Onboard via REST API](#onboard-via-rest-api)
  - [Onboard via UI](#onboard-via-ui)
  - [Verify](#verify)


## Overview

The MQTT Device Service enables Edge Central to subscribe to data and send commands to MQTT devices. Built on Eclipse Paho, an open-source MQTT implementation in Go.

### Three Operational Modes

1. **Asynchronous Read**: Consume data from MQTT topics as devices publish
2. **Get Command**: Send read requests and listen for responses on separate topics
3. **Set Command**: Send write requests to device-listening topics

> Choosing between Asynchronous Read and GET command depends on how your MQTT device is designed to operate.

### MQTT Broker Configuration

| Setting | Purpose | Default |
|---------|---------|---------|
| Scheme | Connection protocol | tcp |
| Host | Broker address | mqtt-broker |
| Port | Connection port | 1883 |
| QoS | Message delivery guarantee | 0 |
| KeepAlive | Heartbeat interval (seconds) | 30 |
| ConnWaitTimeout | Connection timeout (seconds) | 5 |
| GetCmdTimeout | Response wait time (seconds) | 5 |
| AuthMode | Authentication method | none |
| SecretName | Secret provider reference | mqtt |
| SkipCertVerify | Skip certificate validation | false |
| RetryDuration | Total retry window (seconds) | 120 |
| RetryInterval | Retry delay (seconds) | 10 |

### AuthMode Options

- `none`: No authentication
- `cacert`: CA certificate validation
- `usernamepassword`: Credentials-based
- `clientcert`: Mutual TLS authentication

### Configuration Examples

Username/Password (Non-Secure):
```yaml
services:
  device-mqtt:
    environment:
      MQTTBROKERINFO_AUTHMODE: "usernamepassword"
      WRITABLE_INSECURESECRETS_MQTT_SECRETDATA_USERNAME: "<username>"
      WRITABLE_INSECURESECRETS_MQTT_SECRETDATA_PASSWORD: "<password>"
```

TLS with CA Certificate:
```yaml
services:
  device-mqtt:
    environment:
      MQTTBROKERINFO_SCHEME: tcps
      MQTTBROKERINFO_AUTHMODE: "cacert"
```

Client Certificate:
```yaml
services:
  device-mqtt:
    environment:
      MQTTBROKERINFO_SCHEME: tcps
      MQTTBROKERINFO_AUTHMODE: "clientcert"
```

### Supported Data Types

- **Primitive**: Bool, String, Int8-64, Uint8-64, Float32, Float64
- **Arrays**: BoolArray, StringArray, Int8Array-64Array, Uint8Array-64Array, Float32Array, Float64Array

### Device Profile Attributes

| Attribute | Description |
|-----------|-------------|
| `subTopic` | Topic subscription path |
| `pubTopic` | Publishing topic |
| `reqTopic` | Request topic for device commands |
| `resTopic` | Response topic subscription |
| `reqTemp` | Request template (supports UUID matching) |
| `jsonPath` | Field extraction from JSON payload |
| `msgFormat` | Message parsing format |
| `qos` | Quality of Service level |

### Protocol Properties

| Property | Purpose | Example |
|----------|---------|---------|
| `TopicReplacement` | Dynamic topic substitution | device-identifier |
| `HeartbeatResource` | Liveness indicator | status_resource |
| `HeartbeatTimeout` | Inactivity threshold | "30s", "10m" |

### Default Broker

```bash
edgecentral up mqtt-broker
```

---

## MQTT Asynchronous Read

The service subscribes to specified topics and passively waits for incoming device messages. Upon receipt, it parses the payload, converts to event data, and publishes to the EdgeX Message Bus.

**Important:** Since the service doesn't actively request values, GET commands cannot retrieve resource values. Mark asynchronously-read resources with `isHidden: true`.

### Case 1: Binary Payload with Simple Values

```yaml
name: "MQTT-Device-Simulator-AsyncRead-Binary"
manufacturer: "IOTech"
deviceResources:
  - name: "temperature"
    isHidden: true
    attributes:
      subTopic: "${deviceName}/temp"
      qos: "0"
    properties:
      valueType: "Float64"
      readWrite: "R"
  - name: "humidity"
    isHidden: true
    attributes:
      subTopic: "${deviceName}/humidity"
      qos: "0"
    properties:
      valueType: "Int16"
      readWrite: "R"
```

### Case 2: JSON-Formatted String Payload

```yaml
name: "MQTT-Device-Simulator-AsyncRead-JSON"
deviceResources:
  - name: "humidity"
    isHidden: true
    attributes:
      subTopic: "${deviceName}/room"
      qos: "0"
      msgFormat: "json"
      jsonPath: "humidity"
    properties:
      valueType: "Float32"
      readWrite: "R"
  - name: "temperatures"
    isHidden: true
    attributes:
      subTopic: "${deviceName}/room/metric"
      qos: "0"
      msgFormat: "json"
      jsonPath: "temps"
    properties:
      valueType: "Float32Array"
      readWrite: "R"
```

### Sequence Flow

1. Device MQTT Service subscribes to configured topics
2. Physical device publishes message to subscribed topic
3. Service receives and parses payload
4. Service transforms decoded/extracted values into EdgeX event
5. Event publishes to EdgeX Message Bus
6. Core Data service stores readings

---

## MQTT Get Command

A Request/Response pattern where the MQTT device subscribes to a request topic to receive a JSON request payload and publishes the response to a separate response topic.

### Required Attributes

- **`reqTopic`**: Request topic for publishing to a device
- **`resTopic`**: Response topic for subscribing to responses
- **`reqTemp`**: Request template; must contain a `UUID` field to correlate request/response
- **`msgFormat`**: Response message format (set to `json`)
- **`jsonPath`**: Target JSON field of the response message

### Device Profile Example

```yaml
name: "MQTT-Device-Simulator"
manufacturer: "IOTech"
model: "MQTT-Device"
deviceResources:
  - name: "switchbutton"
    isHidden: true
    attributes:
      reqTopic: "${deviceName}/Switch/Req"
      reqTemp: '{ "reqId":"${uuid}" }'
      resTopic: "${deviceName}/Switch/Res"
      msgFormat: "json"
      jsonPath: "switch"
      qos: "0"
    properties:
      valueType: "String"
      readWrite: "RW"
deviceCommands:
  - name: "switch"
    readWrite: "R"
    resourceOperations:
      - { deviceResource: "switchbutton", mappings: {"true": "ON", "false": "OFF"}}
```

### Process Flow

1. User executes GET command via UI or REST API
2. Device Service subscribes to `${deviceName}/Switch/Res`
3. Device Service replaces `${uuid}` and publishes to `${deviceName}/Switch/Req`
4. MQTT device receives request
5. Device publishes response with matching reqId to response topic
6. Service parses value, applies mappings, returns result

---

## MQTT Set Command

The Device Service publishes messages to an MQTT broker on specified topics.

### Case 1: Simple Value (Binary)

```yaml
name: "MQTT-Device-Simulator-SET-Binary"
deviceResources:
  - name: "temperature"
    isHidden: true
    attributes:
      pubTopic: "${deviceName}/room/temperature"
    properties:
      valueType: "Float32"
      readWrite: "W"
  - name: "humidity"
    isHidden: true
    attributes:
      pubTopic: "${deviceName}/room/humidity"
    properties:
      valueType: "Int16"
      readWrite: "W"
deviceCommands:
  - name: "room"
    isHidden: false
    readWrite: "W"
    resourceOperations:
      - { deviceResource: "humidity" }
```

Execute:
```bash
curl -X PUT http://localhost:59882/api/v3/device/name/MQTT_Device_A/room \
  -H "Content-Type:application/json" \
  -d '{"humidity":"26"}'
```

### Case 2: JSON String

```yaml
name: "MQTT-Device-Simulator"
deviceResources:
  - name: "switchbutton"
    properties:
      valueType: "String"
      readWrite: "W"
    attributes:
      pubTopic: "${deviceName}/Switch/Set"
deviceCommands:
  - name: "switch"
    isHidden: false
    readWrite: "W"
    resourceOperations:
      - { deviceResource: "switchbutton",
          mappings: {"true": "ON", "false": "OFF"}}
```

Execute:
```bash
curl http://localhost:59882/api/v3/device/name/MQTT_Device_A/switch \
  -H "Content-Type:application/json" -X PUT \
  -d '{ "switchbutton" : "{\"n\":\"device-1-switch\", \"switch\":\"on\"}" }'
```

---

## MQTT Simulator

Node.js-based script simulation using mqtt-scripts.

**Location:** `/usr/share/edgecentral/examples/device-services/mqtt/simulator/mqtt-scripts/room.js`

### Simulated Values

| Resource | Access |
|----------|--------|
| `switch` | Read only |
| `temperature` | Read only |
| `humidity` | Read only |
| `number` | Read and Write |

Publishes sensor telemetry at 30-second intervals.

### Deployment

```bash
# Find broker IP
edgecentral ip | grep mqtt-broker

# Launch simulator
docker run -d --restart=always --name=mqtt-scripts --network=host \
  -v /usr/share/edgecentral/examples/device-services/mqtt/simulator/mqtt-scripts:/scripts \
  dersimn/mqtt-scripts --url mqtt://172.20.0.3 --dir /scripts

# Verify
docker logs mqtt-scripts
```

**Device Name Requirement:** Use `MQ_DEVICE` when onboarding, matching the identifier in `room.js`.

---

## MQTT Example

### Start Service

```bash
edgecentral up device-mqtt
```

### Onboard via REST API

```bash
# Upload profile
curl http://localhost:59881/api/v3/deviceprofile/uploadfile \
  -F "file=@/usr/share/edgecentral/examples/device-services/mqtt/simulator/simulator.profile.yml"

# Onboard device
curl -X 'POST' 'http://localhost:59881/api/v3/device' \
  -H 'Content-Type: application/json' \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "MQ_DEVICE",
      "description": "Simulated MQTT Device",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "labels": ["MQTT", "room sensor"],
      "serviceName": "device-mqtt",
      "profileName": "MQTT-Device-Simulator",
      "properties": {"IOTech_ProtocolName": "mqtt"},
      "autoEvents": [{"interval": "30s", "onChange": false, "sourceName": "roomNumber"}],
      "protocols": {"MQTT": {}}
    }
  }]'
```

### Onboard via UI

| Field | Value |
|-------|-------|
| Name | MQ_DEVICE |
| Protocol | MQTT |
| Device Profile | MQTT-Device-Simulator |
| Device Service | device-mqtt |
| Auto Events | Interval: 30s, ResourceName: roomNumber |

### Verify

```bash
curl http://localhost:59882/api/v3/device/name/MQ_DEVICE/roomNumber
```
