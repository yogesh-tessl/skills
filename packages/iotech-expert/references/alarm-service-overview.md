<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-alarm10/
  Synced: 2026-03-07
-->

# IOTech Alarm Service Overview

The IOTech Alarm Service is a centralized alarm management system that standardizes alarm processing across diverse edge environments. It implements the OPC UA Alarms and Conditions specification (Release 1.05.03, 2023-12-31) to normalize alarm data from devices, MQTT sources, and OPC UA nodes.

## Core Capabilities

### Alarm Configuration and Event Generation

The service supports four standard OPC UA alarm types:

- **Level Alarms**: Monitor process variables against configured thresholds (e.g., temperature sensors, pressure gauges)
- **Deviation Alarms**: Track variance between setpoint and actual values
- **Rate of Change Alarms**: Detect rapid value changes over time
- **Discrete Alarms**: Handle binary conditions (running/stopped, open/closed)

Alarms can be configured at device profile, device instance, MQTT source, or individual OPC UA node levels through the UI, bootstrap files, or API.

### Alarm Management Operations

The system provides comprehensive lifecycle control following OPC UA standards:

- **Acknowledge**: Marks alarm state as operator-reviewed
- **Confirm**: Indicates alarm resolution and return to normal state
- **Shelving**: Temporarily suppresses notifications while maintaining alarm state
- **Suppression**: Disables specific alarm instances

Real-time updates via Server-Sent Events (SSE) deliver alarm events without polling overhead.

### Alarm Routing

The routing system delivers notifications through multiple configurable actions:

**Available Actions:**
- Email
- SMS messaging
- Telegram bot integration
- Webhook
- MQTT publishing
- Phone calls

**Features:**
- User customizable templating for all actions
- Filtering by device, severity, and alarm state transitions
- Event batching and scheduling capabilities
- Retry logic and delivery confirmation

## System Architecture

The service integrates with:
- EdgeX Foundry devices
- Standalone MQTT sources
- PostgreSQL database
- REST API interface
- Web UI
- Multiple external notification endpoints

## Documentation Organization

- **Getting Started**: Tutorials and quick start guides
- **Concepts**: Architecture and core modeling framework
- **Configuration**: Service and alarm setup procedures
- **REST API**: Complete API reference
- **UI Guide**: Web interface documentation
- **Security**: Authentication and authorization setup
