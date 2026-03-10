<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/introduction/introduction.html
    - https://docs.iotechsys.com/edge-central40/introduction/architecture.html
  Synced: 2026-03-07
-->

# What is Edge Central

## Edge Central Overview

Edge Central is a flexible, platform-independent, highly scalable and industrial-grade edge software platform. It facilitates the integration of operational technology devices and sensors with edge analytics, decision-making systems, and cloud infrastructure.

The platform employs a modular microservices design, enabling interoperability across diverse industrial edge applications.

## Based on EdgeX Foundry

Edge Central builds upon the Linux Foundation's open-source EdgeX Foundry platform. It adds commercial-grade enhancements, including extended key features, easy-to-use tooling, and full technical support.

This approach aims to reduce risks associated with open-source adoption in mission-critical environments while leveraging established EdgeX technology.

## Key Features

The platform provides:

- **Architecture**: Loosely-coupled microservices design that is hardware and operating system agnostic
- **Protocol Support**: Integration with industrial protocols (Modbus, BACnet, OPC UA, BLE, Siemens S7, EtherNet/IP, and others)
- **Edge Services**: Analytics, decision-making, control, and visualization capabilities
- **Data Management**: Edge alarms and long-term storage via edge historian
- **Cloud Connectivity**: Data sharing to AWS and Microsoft Azure services
- **Extensibility**: SDKs for creating custom OT and IT connectors
- **Security**: Critical security features for safe platform operation
- **Administration**: Advanced tooling for testing, deployment, and system management

---

# Edge Central Architecture

## Overview

Edge Central employs a layered microservices architecture designed to manage IoT edge devices and process data across multiple service tiers. The system separates southbound device communication from northbound cloud integration through specialized service layers.

## Architecture Layers

### Device Services Layer

This layer manages direct communication with physical IoT devices using native protocols. The Device Services layer interacts with the physical edge devices and sensors. The data collected from the devices is delivered to the Core Services layer for normalization and aggregation.

Multiple protocol implementations are available, including:
- Modbus
- BACnet
- OPC UA
- EtherNet/IP
- MQTT
- REST
- CANbus
- BLE
- S7
- WebSocket
- ONVIF Camera
- USB Camera
- GPS
- File-based devices
- Virtual devices

Custom device services can be developed using C or Go SDKs.

### Core Services Layer

Core Services function as the system's integration hub. These services separate the Southbound (edge devices) and the Northbound (Cloud or Enterprise system) layers at the edge and aggregate data received from different edge devices.

Core services include:
- **Core Data/Edge Historian**: Stores and manages time-series data with event filtering capabilities
- **Core Metadata**: Manages device profiles and configuration
- **Core Command**: Handles device command execution
- **Config & Registry**: Centralized configuration management
- **Database**: PostgreSQL backend with external storage options

### Supporting Services Layer

This layer provides processing and infrastructure capabilities:

- **Rules Engine**: Decision-making via Kuiper or Node-RED
- **Time-series Storage**: InfluxDB integration
- **Visualization**: Grafana dashboarding
- **Alerting & Notifications**: Multi-channel alert distribution
- **Alarm Service**: Unified, standards-based alarm management
- **Scheduling**: Event and data collection scheduling
- **Provisioning**: Device onboarding automation
- **Sparkplug**: MQTT-based messaging standards support
- **OPC UA Server**: Northbound OPC UA server providing information modeling and security capabilities
- **AI Inference**: Resource Auto Tagging functionality for automated resource classification

### Application Services Layer

Application Services deliver data to external systems through configurable pipelines. Each pipeline chains functions together, starting with a trigger (message arrival, timer, etc.), followed by processing functions (filtering, transformation) and export functions.

Export destinations supported include:
- AWS IoT Core and S3
- Azure IoT Hub, Event Hubs, Blob Storage, and IoT Edge
- InfluxDB
- Kafka
- HTTP endpoints
- PostgreSQL (experimental)

Custom functions can be created using the Application Functions SDK.

### Security Services Layer

Security components protect platform integrity:

- **API Gateway (Nginx)**: Request authorization and authentication
- **JWT Authentication**: Token-based access control
- **Secret Store**: Encrypted credential and certificate management
- **Role-Based Access Control (RBAC)**: Granular privilege management
- **Authorization (Access Control Lists)**: Fine-grained resource-level access policies
- **TLS**: Encryption for internal message bus communications

### System Management Layer

Operational management capabilities include:
- Service state visualization and control
- Configuration parameter management
- Performance metrics and health monitoring
- Health checks for service availability verification
- Executor functionality for service lifecycle operations (start, stop, restart)
- Service logging and diagnostics
- Remote deployment via Edge Manager

## Deployment Model

Edge Central consists of Docker-based microservices deployable locally or remotely. IOTech's Edge Manager provides centralized lifecycle management for multi-node deployments.

## Key Architectural Principles

The architecture maintains interoperability through standardized, open APIs. This design allows microservice enhancements or replacements without disrupting system operations, as each layer maintains consistent interfaces regardless of underlying implementation changes.
