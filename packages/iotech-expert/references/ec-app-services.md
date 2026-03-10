<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/app-services/app-services-overview.html
    - https://docs.iotechsys.com/edge-central40/app-services/edgecentral-app-services.html
    - https://docs.iotechsys.com/edge-central40/app-services/built-in-functions-overview.html
    - https://docs.iotechsys.com/edge-central40/app-services/run-app-services.html
    - https://docs.iotechsys.com/edge-central40/app-services/examples.html
  Synced: 2026-03-07
-->

# Application Services Overview

## 目錄

- [Core Concept](#core-concept)
- [Architecture](#architecture)
- [Deployment Models](#deployment-models)
  - [Configurable Application Service](#configurable-application-service)
  - [Custom Application Service](#custom-application-service)
- [Key Features](#key-features)
- [Migration Note](#migration-note)
- [Overview](#overview)
  - [Key Configuration Concepts](#key-configuration-concepts)
  - [Supported Functions](#supported-functions)
  - [Multiple Pipelines](#multiple-pipelines)
  - [Configuration Files](#configuration-files)
  - [Related Resources](#related-resources)
- [Overview](#overview)
- [Export Functions](#export-functions)
  - [IOTechHTTPExport](#iotechhttpexport)
  - [IOTechMQTTExport](#iotechmqttexport)
  - [KafkaSend](#kafkasend)
  - [InfluxDBSyncWrite](#influxdbsyncwrite)
  - [PostgresWrite](#postgreswrite)
- [Conversion Functions](#conversion-functions)
  - [JavascriptTransform](#javascripttransform)
  - [Data Type Conversion Functions](#data-type-conversion-functions)
  - [Format Conversion Functions](#format-conversion-functions)
  - [Compression Functions](#compression-functions)
  - [File and Data Functions](#file-and-data-functions)
- [Filter Functions](#filter-functions)
  - [FilterByValueMaxMin](#filterbyvaluemaxmin)
  - [FilterByEventTag](#filterbyeventtag)
  - [FilterByReadingTag](#filterbyreadingtag)
- [Core Command Functions](#core-command-functions)
  - [ExecuteCoreCommand](#executecorecommand)
- [Tag Functions](#tag-functions)
  - [IOTechAddTagsFromDeviceResource](#iotechaddtagsfromdeviceresource)
  - [IOTechAddTagsFromDevice](#iotechaddtagsfromdevice)
  - [AddTags](#addtags)
- [Utility Functions](#utility-functions)
  - [SetContextVariable](#setcontextvariable)
  - [PrintDataToLog](#printdatatolog)
  - [Batch](#batch)
- [Overview](#overview)
- [Create and Start the Application Service](#create-and-start-the-application-service)
  - [Create the Application Service](#create-the-application-service)
  - [Start the Application Service](#start-the-application-service)
  - [Restart the Application Service](#restart-the-application-service)
- [Stop and Delete the Application Service](#stop-and-delete-the-application-service)
  - [Stop the Application Service](#stop-the-application-service)
  - [Stop and Delete the Application Service](#stop-and-delete-the-application-service)
  - [Delete the Application Service](#delete-the-application-service)
- [Export the Application Service Logs](#export-the-application-service-logs)
- [Security Considerations](#security-considerations)
- [Available Example Categories](#available-example-categories)


## Core Concept

Edge Central's Application Services enable processing and delivery of data to external systems including analytics platforms, enterprise applications, and cloud infrastructure. The services facilitate data preparation, transformation, and translation before northbound delivery.

## Architecture

Application Services implement a "Functions Pipeline" pattern—a sequential collection of functions that process messages. The first function serves as a trigger (such as a message arrival on the Edge Central message bus) to initiate the pipeline.

## Deployment Models

### Configurable Application Service

Edge Central provides a pre-built configurable service supporting these endpoints:

- AWS IoT Core
- Azure IoT Hub
- InfluxDB
- HTTP endpoints
- MQTT endpoints
- Apache Kafka
- Postgres

"You can simply configure the required function pipelines" using preloaded configuration files requiring only endpoint-specific details like credentials and URLs.

### Custom Application Service

For advanced requirements, developers can build custom services. The documentation references the "EdgeX Foundry Application Functions SDK" for expanded capabilities beyond standard configurable options.

## Key Features

**Bidirectional Data Flow**: The External MQTT Trigger enables both sending data to and receiving data from cloud systems, supporting cloud-to-edge communication patterns.

**Data Processing Capabilities**:
- Filtering and enrichment
- Format transformation
- Compression and encryption
- Custom function pipeline composition

## Migration Note

"Application Services have replaced the Export Services" from earlier Edge Central versions, providing enhanced functionality while maintaining similar core capabilities for data northbound delivery.

---

# App Services Configuration - Edge Central User Guide

## Overview

Application Services require configuration via YAML files to export data to various endpoints. The configuration establishes a processing pipeline of functions that handle messages sequentially.

### Key Configuration Concepts

**Functions Pipeline**: "The messages entering the functions pipeline are received from the Trigger, which could be an event like a message landing in a monitored message queue."

The system processes data through an ordered sequence of functions, where each function transforms or routes data according to specifications. Triggers initiate the pipeline based on events like message arrivals.

### Supported Functions

Edge Central leverages all functions from EdgeX Foundry's Configurable Application Service, plus additional built-in functions for enhanced export capabilities. Available functions are documented in the Application Service SDK reference materials.

### Multiple Pipelines

The platform supports multiple pipelines per topics, allowing deployment of different Application Service containers for distinct purposes. For example: one service exports temperature data to Azure IoT Hub while another sends humidity data to Kafka, each running as independent containers.

### Configuration Files

- Located in: `/usr/share/edgecentral/examples/app-configurable/`
- Format: YAML compliant with EdgeX Foundry standards
- Can specify: endpoints, data selection, transformations, processing order

### Related Resources

- EdgeX Foundry configuration documentation
- Trigger Enhancements documentation
- Built-in Functions overview
- Example configuration files for supported cloud platforms (AWS, Azure, Kafka, HTTP, etc.)

---

# Built-In Functions Overview - Edge Central Application Services

## Overview

Edge Central Application Services are built on the Configurable Application Service framework and support all built-in functions from EdgeX Foundry, plus additional proprietary functions for enhanced functionality.

## Export Functions

### IOTechHTTPExport
Sends data to HTTP endpoints with enhanced features including OAuth2 Client Credentials grant support, extending EdgeX Foundry's HTTPExport capabilities.

### IOTechMQTTExport
Publishes data to MQTT brokers with support for multiple export modes:
- **mqtt**: Regular MQTT broker export
- **awsiotcore**: AWS IoT Core integration
- **awsiotcoreresponse**: AWS IoT Core command response handling
- **azureiothub**: Azure IoT Hub integration
- **azuredirectmethodresponse**: Azure IoT Hub direct method responses

Key parameters include broker address, topic, client ID, QoS settings, authentication modes (none, username/password, client certificate, CA certificate), and connection management options.

### KafkaSend
Uses the sarama library to act as a Kafka producer, sending EdgeX events to specified Kafka topics.

### InfluxDBSyncWrite
Synchronously writes EdgeX events to InfluxDB v2.x using the influxdb-client-go library.

### PostgresWrite
Exports device readings to PostgreSQL databases. Note: Version 2.3+ uses a JSONB `value` column and removes individual typed value columns for improved performance.

## Conversion Functions

### JavascriptTransform
Executes JavaScript code against incoming data with access to `inputObject` and `contextObject`. Results must be explicitly returned for pipeline continuation.

### Data Type Conversion Functions
- **ConvertBoolToIntReading**: Bool to Int8 (true→1, false→0)
- **ConvertBoolToFloatReading**: Bool to Float32 (true→1.0, false→0.0)
- **ConvertIntToFloatReading**: Integer types to Float64 in E-notation
- **ConvertFloatToIntReading**: Float32/Float64 to Int64 (truncates decimals)

### Format Conversion Functions
- **ConvertByteArrayToEvent**: Converts byte arrays to EdgeX events (requires `TargetType: raw`)
- **ConvertDDATAToEvent**: Transforms Sparkplug DDATA messages to EdgeX events
- **EncodeEventToProtobuf**: Converts EdgeX Events to Protocol Buffers format

### Compression Functions
- **Compress**: Supports gzip and zlib algorithms with optional Base64 encoding
- **Decompress**: Reverses compression with Base64 decoding option

### File and Data Functions
- **TransformToParquet**: Converts EdgeX events to Parquet format
- **ReadFile**: Reads binary file data from specified filesystem path
- **Encrypt**: AES256 encryption using keys from Secret Store
- **Decrypt**: AES256 decryption using keys from Secret Store

## Filter Functions

### FilterByValueMaxMin
Removes numeric readings exceeding maximum/minimum bounds defined in device profiles. Ignores non-numeric values and only filters when limits are defined.

### FilterByEventTag
Filters events based on tag matching with two modes:
- FilterOut=false: Pass matching tags
- FilterOut=true: Remove matching tags

### FilterByReadingTag
Filters individual readings within events based on tag values. Terminates pipeline if no readings remain after filtering.

## Core Command Functions

### ExecuteCoreCommand
Parses incoming JSON to extract device name, command name, and request body using GJSON library, then executes through CommandClient. Parameters define JSON paths for data extraction and control command execution behavior (GET/SET methods, event pushing/returning, error handling).

## Tag Functions

### IOTechAddTagsFromDeviceResource
Adds pre-configured device resource tags to event tags. Requires Core Metadata client configuration. Tags are cached at runtime and not refreshed after initialization.

### IOTechAddTagsFromDevice
Adds device-level tags to events. Also requires Core Metadata configuration and performs single-load caching of device tags.

### AddTags
Adds custom tags to events using colon-separated key/value pairs (e.g., `GatewayId:HoustonStore000123`).

## Utility Functions

### SetContextVariable
Extracts values from incoming data using JsonPath and stores in named context variables. Supports `continueOnError` to prevent pipeline interruption.

### PrintDataToLog
Outputs incoming data to console logs for debugging purposes.

### Batch
Holds data before pipeline advancement using three strategies:
- **bytime**: Release after time interval
- **bycount**: Release after item threshold
- **bytimecount**: Release on whichever occurs first

Supports multiple output formats: byte arrays, unmarshaled Events, custom JSON objects, or merged byte arrays.

**Note**: All error conditions cause pipeline termination unless `continueOnError` or similar parameters are explicitly enabled.

---

# Running App Services

## Overview

Application Services in Edge Central require a configuration file before execution. Management is available through the Edge Central UI or CLI.

## Create and Start the Application Service

### Create the Application Service

Use the `up` command with the `app-service` argument and specify the configuration file path:

```bash
edgecentral up app-service --path <path to configuration yaml file>
```

Multiple configuration files can be specified using commas as separators:

```bash
edgecentral up app-service --path=./config-app-1.yaml,./config-app-2.yaml
```

**Important:** "The Application Service takes its name from the configuration file name so these need to be unique."

### Start the Application Service

For subsequent runs, use the `start` command:

```bash
# Start specific service
edgecentral start app-service --path=./config-app-1.yaml

# Start all stopped services
edgecentral start app-service
```

### Restart the Application Service

Use the `restart` command to restart running services:

```bash
# Restart specific service
edgecentral restart app-service --path=./config-app-1.yaml

# Restart all running services
edgecentral restart app-service
```

## Stop and Delete the Application Service

### Stop the Application Service

Use the `stop` command:

```bash
# Stop specific service
edgecentral stop app-service --path=./config-app-1.yaml

# Stop all running services
edgecentral stop app-service
```

### Stop and Delete the Application Service

Use the `down` command:

```bash
# Stop and delete specific service
edgecentral down app-service --path=./config-app-1.yaml

# Stop and delete all services
edgecentral down app-service
```

### Delete the Application Service

Use the `rm` command to delete stopped services:

```bash
edgecentral rm app-service --path=./config-app-1.yaml
```

## Export the Application Service Logs

Export logs using the `logs` command:

```bash
edgecentral logs app-service --path=./config-app-1.yaml -o /tmp
```

## Security Considerations

"The Edge Central Application Services run in the secure mode when the secret store `Vault` is up." When operating in secure mode, all required secrets must be stored in Vault before launching Application Services.

Vault deployment options:
- Using the `--secret` flag
- Using the `--api-gateway` flag with the `up` command

---

# Application Service Examples Overview

## Available Example Categories

The documentation groups examples into the following sections:

**Cloud Platform Integrations:**
- AWS IoT Core and S3 export examples
- Azure Blob Storage, IoT Hub, IoT Edge, and Event Hubs examples

**Data Processing & Storage:**
- Kafka message streaming examples
- InfluxDB time-series database export
- PostgreSQL export (experimental)

**Messaging & Triggers:**
- HTTP endpoint exports
- External MQTT trigger patterns
- Timer-based trigger usage

**Advanced Features:**
- Context variable substitution for dynamic topics and URLs
- JavaScript transformation functions
- Protocol encoding (Protobuf format)

**Note:** "The examples assume that the Edge Central services are running. A suitable command to start all the required services is provided."
