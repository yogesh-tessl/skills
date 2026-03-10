<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/supporting-services/rulesengine.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/kuiper.html
    - https://docs.iotechsys.com/edge-central40/supporting-services/nodered.html
  Synced: 2026-03-07
-->

# Rules Engine Overview

## Key Content

### Rules Engine Purpose

"A rules engine allows you to filter, transform and extract data at the edge before you send it to the cloud for processing." By processing at the edge, organizations can achieve reduced latency, lower bandwidth consumption, decreased storage costs, and enhanced security.

### Available Rules Engine Options

Edge Central supports multiple processing frameworks:

**eKuiper**
- Lightweight, open-source IoT edge analytics platform
- Enables stream processing on resource-constrained edge devices
- Supports SQL-based rule writing
- Suitable for rapid data processing at network boundaries

**Node-RED**
- Browser-based flow editor for visual development
- JavaScript-based API support
- Bidirectional communication with Edge Central
- Live dashboard capabilities
- Enables device command execution through rules

### Integration Capabilities

Node-RED provides two-way integration: it receives data from Edge Central and can send commands back to device services, enabling closed-loop edge automation scenarios.

---

# LF Edge eKuiper

## Overview

LF Edge eKuiper is a lightweight, SQL-based rules engine for IoT data analytics and streaming at the edge. It's integrated into Edge Central as part of the distribution.

## Architecture Components

eKuiper operates on three core components:

1. **Source**: Origin of stream data (e.g., MQTT servers, EdgeX message bus)
2. **SQL**: Business logic processing using SQL statements for extraction, filtering, and transformation
3. **Sink**: Destination for analysis results (e.g., Core Command, MQTT broker, cloud services)

## Configuration

Default eKuiper environment variables are configured in the docker-compose file:

| Parameter | Default | Description |
|-----------|---------|-------------|
| EDGEX__DEFAULT__PORT | 1883 | Edge Central message bus port |
| EDGEX__DEFAULT__PROTOCOL | tcp | Protocol for message bus connection |
| EDGEX__DEFAULT__SERVER | mqtt-broker | Core Data service address |
| EDGEX__DEFAULT__TOPIC | edgex/events/# | Message bus topic subscription |
| EDGEX__DEFAULT__TYPE | mqtt | Message bus type (zero, mqtt, redis) |
| EDGEX__DEFAULT__OPTIONAL__KEEPALIVE | 50 | Keepalive ping interval in seconds |
| EDGEX__DEFAULT__MESSAGETYPE | request | Message model type (event or request) |
| KUIPER__BASIC__CONSOLELOG | true | Console logging toggle |
| KUIPER__BASIC__RESTPORT | 59720 | eKuiper API server port |
| KUIPER__BASIC__DEBUG | false | Debug logging toggle |

## Implementation Steps

To use eKuiper with Edge Central:

1. Create a stream specifying the data source
2. Write a rule containing:
   - SQL for data analysis
   - Sink target for results
3. Deploy and run the rule

## REST API Examples

**Create a Stream:**
```bash
curl -X POST http://localhost:59720/streams \
  -H 'Content-Type: application/json' \
  -d '{"sql": "create stream demo() WITH (FORMAT=\"JSON\", TYPE=\"edgex\")"}'
```

**Create a Rule:**
```bash
curl -X POST http://localhost:59720/rules \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "rule1",
    "sql": "SELECT * FROM demo",
    "actions": [
      {"mqtt": {"server": "tcp://mqtt-broker:1883", "topic": "result", "clientId": "demo_001"}},
      {"log": {}}
    ]
  }'
```

## CLI Operations

Enter the eKuiper container:
```bash
docker exec -it kuiper /bin/sh
```

Create a stream via CLI:
```bash
bin/kuiper create stream demo'() WITH (FORMAT="JSON", TYPE="edgex")'
```

## Key Notes

- eKuiper API runs on port 59720 (not the default 9081)
- Supports three message bus types: ZeroMQ, Redis Pub/Sub, and MQTT
- For secure mode deployments, replace localhost with the service's IP address
- Results can be monitored using MQTT client tools like Eclipse Mosquitto

---

# Node-RED

## Overview

Node-RED is a browser-based flow editor that allows users to wire together flows using nodes from the Node-RED palette. The documentation demonstrates how to integrate Edge Central with Node-RED for data delivery, rule creation, and analytics.

## Architecture & Integration

The example workflow involves:

1. **Edge Central Services** - Starting with Virtual Device Service, MQTT broker, and Node-RED
2. **Data Export** - Using Application Service to send events to an MQTT broker
3. **Subscription Setup** - Configuring Node-RED to receive and process data

## Setup Instructions

### Starting Edge Central

Launch the required services with:
```
edgecentral up nodered mqtt-broker device-virtual sys-mgmt central-ui
```

### Exporting to MQTT via Application Service

**Steps:**

1. Access Edge Central UI at `localhost:9090`
2. Navigate to App Services → **Add App Service**
3. Enter "Node-RED" as the name
4. In the Functions Pipeline, add MQTT with these settings:

| Parameter | Value |
|-----------|-------|
| Broker Address | `tcp://mqtt-broker:1883` |
| Topic | `MyTopic` |

### Node-RED Configuration

**Setup Steps:**

1. Open Node-RED at `localhost:1880`
2. Drag **mqtt-in** node from network options to the canvas
3. Configure the MQTT server:
   - Name: `mqtt`
   - Server: `mqtt-broker`
4. Set Topic to: `MyTopic`
5. Add downstream nodes:
   - **json** parser node
   - **debug** output node
6. Connect nodes in sequence: mqtt-in → json → debug
7. Click **Deploy**
8. View incoming data in the Debug panel

## Data Flow

The system architecture channels Virtual Device data through Edge Central's Application Service to the MQTT broker, where Node-RED subscribes to the published messages for further processing and visualization.
