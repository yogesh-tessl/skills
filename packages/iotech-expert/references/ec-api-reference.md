<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/api/api-overview.html
    - https://docs.iotechsys.com/edge-central40/api/api-core-data.html
    - https://docs.iotechsys.com/edge-central40/api/api-core-metadata.html
    - https://docs.iotechsys.com/edge-central40/api/api-core-command.html
    - https://docs.iotechsys.com/edge-central40/api/api-core-keeper.html
    - https://docs.iotechsys.com/edge-central40/api/api-edge-historian.html
    - https://docs.iotechsys.com/edge-central40/api/api-support-notifications.html
    - https://docs.iotechsys.com/edge-central40/api/api-support-scheduler.html
    - https://docs.iotechsys.com/edge-central40/api/api-support-sparkplug.html
    - https://docs.iotechsys.com/edge-central40/api/api-system-management.html
    - https://docs.iotechsys.com/edge-central40/api/api-app-functions-sdk.html
    - https://docs.iotechsys.com/edge-central40/api/api-device-sdk.html
    - https://docs.iotechsys.com/edge-central40/api/api-proxy-auth.html
    - https://docs.iotechsys.com/edge-central40/api/api-ai-inference.html
  Synced: 2026-03-07
-->

# Edge Central API Reference

## 目錄

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
  - [Timestamp Precision](#timestamp-precision)
  - [Max Result Count Configuration](#max-result-count-configuration)
- [Overview](#overview)
- [Core Concepts](#core-concepts)
  - [Events](#events)
  - [Readings](#readings)
  - [Filters](#filters)
- [API Endpoints](#api-endpoints)
  - [Event Management](#event-management)
  - [Reading Management](#reading-management)
  - [Filter Management](#filter-management)
  - [Service Endpoints](#service-endpoints)
- [Data Type Support](#data-type-support)
- [Filter Specifications](#filter-specifications)
- [Common Headers](#common-headers)
- [Overview](#overview)
- [Core Concepts](#core-concepts)
  - [Devices](#devices)
  - [Device Profiles](#device-profiles)
  - [Device Services](#device-services)
  - [Provision Watchers](#provision-watchers)
- [API Endpoints](#api-endpoints)
  - [Devices](#devices)
  - [Device Profiles](#device-profiles)
  - [Device Services](#device-services)
  - [Provision Watchers](#provision-watchers)
  - [Utility Endpoints](#utility-endpoints)
- [Data Types](#data-types)
  - [AutoEvent](#autoevent)
  - [ResourceProperties](#resourceproperties)
  - [DeviceCommand](#devicecommand)
  - [ResourceOperation](#resourceoperation)
- [Query Parameters](#query-parameters)
- [Status Code Summary](#status-code-summary)
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
  - [Device Command Execution](#device-command-execution)
  - [Device Command Discovery](#device-command-discovery)
  - [Service Management](#service-management)
- [Overview](#overview)
- [Key-Value Storage Endpoints](#key-value-storage-endpoints)
  - [GET /kvs/key/{key}](#get-kvskeykey)
  - [PUT /kvs/key/{key}](#put-kvskeykey)
  - [DELETE /kvs/key/{key}](#delete-kvskeykey)
- [Service Registration Endpoints](#service-registration-endpoints)
  - [POST /registry](#post-registry)
  - [PUT /registry](#put-registry)
  - [GET /registry/serviceId/{serviceId}](#get-registryserviceidserviceid)
  - [DELETE /registry/serviceId/{serviceId}](#delete-registryserviceidserviceid)
  - [GET /registry/all](#get-registryall)
- [Core Data Models](#core-data-models)
- [Overview](#overview)
- [Core Data Models](#core-data-models)
  - [Event](#event)
  - [Reading](#reading)
  - [Filter](#filter)
  - [Retention Policy](#retention-policy)
- [API Endpoints](#api-endpoints)
  - [Event Management](#event-management)
  - [Reading Management](#reading-management)
  - [Filter Management](#filter-management)
  - [Retention Policy Management](#retention-policy-management)
- [Key Features](#key-features)
- [Overview](#overview)
- [Core Concepts](#core-concepts)
  - [Notifications](#notifications)
  - [Subscriptions](#subscriptions)
  - [Transmissions](#transmissions)
- [API Endpoints](#api-endpoints)
  - [Notification Management](#notification-management)
  - [Subscription Management](#subscription-management)
  - [Transmission Management](#transmission-management)
  - [Maintenance](#maintenance)
- [Channel Types](#channel-types)
  - [REST Address](#rest-address)
  - [Email Address](#email-address)
  - [MQTT Publish Address](#mqtt-publish-address)
  - [ZeroMQ Address](#zeromq-address)
- [Notification Severity Levels](#notification-severity-levels)
- [Key Features](#key-features)
- [Overview](#overview)
- [Core Concepts](#core-concepts)
- [API Endpoints](#api-endpoints)
  - [Job Management](#job-management)
  - [Action Records](#action-records)
- [Schema Definitions](#schema-definitions)
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
  - [GET /ping](#get-ping)
  - [GET /version](#get-version)
  - [GET /config](#get-config)
  - [GET /metrics](#get-metrics)
  - [POST /secret](#post-secret)
- [Overview](#overview)
- [Core Data Models](#core-data-models)
  - [MicroService](#microservice)
  - [OperationRequest](#operationrequest)
- [API Endpoints](#api-endpoints)
  - [Health Management](#health-management)
  - [Metrics & Configuration](#metrics-configuration)
  - [Service Operations](#service-operations)
  - [Microservice Management](#microservice-management)
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
  - [GET /config](#get-config)
  - [GET /ping](#get-ping)
  - [POST /secret](#post-secret)
  - [POST /trigger](#post-trigger)
  - [GET /version](#get-version)
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
  - [Device Command Operations](#device-command-operations)
  - [Secret Management](#secret-management)
  - [Device Discovery](#device-discovery)
  - [Profile Scanning](#profile-scanning)
  - [Service Information](#service-information)
- [HTTP Status Codes](#http-status-codes)
- [Overview](#overview)
- [Core Features](#core-features)
- [API Endpoints](#api-endpoints)
  - [User Management](#user-management)
  - [Authentication & Authorization](#authentication-authorization)
  - [Role-Based Access Control](#role-based-access-control)
  - [Key Management](#key-management)
  - [Common HTTP Status Codes](#common-http-status-codes)
- [Data Models](#data-models)
  - [User](#user)
  - [RolePolicy](#rolepolicy)
  - [AccessPolicy](#accesspolicy)
- [Overview](#overview)
- [Endpoints](#endpoints)
  - [POST `/inference/resource_tag_points`](#post-inferenceresource_tag_points)
  - [GET `/inference/result/{requestId}`](#get-inferenceresultrequestid)
  - [GET `/ping`](#get-ping)
- [Processing States](#processing-states)


## Table of Contents

- [Core Data API](#core-data-api)
- [Core Metadata API](#core-metadata-api)
- [Core Command API](#core-command-api)
- [Core Keeper API](#core-keeper-api)
- [Edge Historian API](#edge-historian-api)
- [Support Notifications API](#support-notifications-api)
- [Support Scheduler API](#support-scheduler-api)
- [Support Sparkplug API](#support-sparkplug-api)
- [System Management API](#system-management-api)
- [Application Services API](#application-services-api)
- [Device Service API](#device-service-api)
- [Proxy Authentication API](#proxy-authentication-api)
- [AI Inference API](#ai-inference-api)

## Overview

Edge Central offers comprehensive API documentation covering multiple service categories:

**Core Services APIs:**
- Core Data
- Core Metadata
- Core Command
- Core Keeper

**Support Services APIs:**
- Support Notifications
- Support Scheduler

**Additional APIs:**
- System Management
- Application Services
- Device Service
- Proxy Authentication
- Edge Historian
- Support Sparkplug
- AI Inference

### Timestamp Precision

Several data models include a timestamp field, but the precision varies. For detailed specifications, consult the EdgeX Foundry timestamp precision documentation.

### Max Result Count Configuration

The `MaxResultCount` parameter controls API response limits with a default value of 1024. This threshold can be modified through two approaches:

**Method 1: Docker Compose Override**

Add environment variables to your compose configuration:
```yaml
services:
  core-common-config-bootstrapper:
    environment:
      ALL_SERVICES_SERVICE_MAXRESULTCOUNT: 2048
```

**Method 2: Central UI**

Access via the Service Control panel in the UI interface. Navigate to "Edit Common Config" and adjust the "Max Result Count" field directly.

**Important Note:** If the service was not started initially and the default `MaxResultCount` value has already been stored in the Configuration Provider, users must set `EDGEX_OVERWRITE_CONFIG: "true"` to ensure environment variables override stored settings.

---

# Core Data API

## Overview

The Core Data API is part of the EdgeX Foundry IoT microservice platform, responsible for storing event and reading data from edge devices. The API operates at version 4.0.0 and runs locally on `http://localhost:59880/api/v3`.

## Core Concepts

### Events
An event represents a discrete occurrence containing one or more readings from a device. Each event includes metadata like device name, profile name, source name, origin timestamp, and associated readings.

### Readings
Readings are individual data points within an event. They support multiple data types including Bool, String, numeric types (Int8-Int64, Uint8-Uint64, Float32, Float64), arrays of these types, Binary data, and Object data.

### Filters
Filters enable selective persistence of events and readings based on device name, event source name, and resource name patterns. They support both inclusion (IN) and exclusion (OUT) modes, plus conditional persistence based on value changes.

## API Endpoints

### Event Management

#### POST `/event/{serviceName}/{profileName}/{deviceName}/{sourceName}`
Ingests new event/reading data. The deviceName and profileName in the request must match path parameters.

**Request Body:**
```json
{
  "apiVersion": "v3",
  "event": {
    "apiVersion": "v3",
    "deviceName": "Random-Boolean-Device",
    "profileName": "Random-Boolean-Device",
    "sourceName": "Bool",
    "id": "563513b3-f020-46fa-ae44-0fdd1d129185",
    "origin": 1692721935934211905,
    "readings": [
      {
        "deviceName": "Random-Boolean-Device",
        "resourceName": "Bool",
        "profileName": "Random-Boolean-Device",
        "origin": 1692721935934211905,
        "valueType": "Bool",
        "value": "false"
      }
    ]
  }
}
```

**Responses:**
- 201 Created: Event successfully added
- 400 Bad Request: Invalid request state
- 409 Conflict: Event ID must be universally unique
- 500 Server Error: Unexpected error

#### GET `/event/all`
Returns paginated events sorted by origin descending.

**Query Parameters:**
- `offset`: Items to skip (default: 0, -1 skips count)
- `limit`: Items to return (default: 20, -1 returns all)
- `numeric`: Return numeric values as numbers instead of strings

**Responses:**
- 200 OK: Returns MultiEventsResponse with totalCount and events array
- 400 Bad Request: Invalid parameters
- 416 Range Not Satisfiable: Offset/limit out of range
- 500 Server Error

#### GET `/event/id/{id}`
Retrieves a specific event by UUID.

**Responses:**
- 200 OK: Returns EventResponse with single event
- 404 Not Found: Event doesn't exist
- 500 Server Error

#### DELETE `/event/id/{id}`
Deletes an event by UUID.

**Responses:**
- 200 OK: Deletion successful
- 404 Not Found: Event doesn't exist
- 500 Server Error

#### GET `/event/count`
Returns total count of all stored events.

#### GET `/event/count/device/name/{name}`
Returns event count for a specific device.

#### GET `/event/device/name/{name}`
Retrieves events from a specific device with pagination.

**Query Parameters:** offset, limit, numeric

#### DELETE `/event/device/name/{name}`
Deletes all events for a specified device.

**Response Codes:** 202 (Accepted), 400, 500

#### GET `/event/start/{start}/end/{end}`
Retrieves events within a time range (Unix timestamps in nanoseconds).

**Query Parameters:** offset, limit, numeric

#### DELETE `/event/age/{age}`
Removes events older than specified age (nanoseconds).

**Response Codes:** 202 (Accepted), 400, 500

### Reading Management

#### GET `/reading/all`
Returns all readings with pagination and optional aggregation.

**Query Parameters:**
- `offset`, `limit`, `numeric`
- `aggregateFunc`: MIN, MAX, COUNT, SUM, AVG (case insensitive)

#### GET `/reading/count`
Returns total reading count.

#### GET `/reading/count/device/name/{name}`
Returns reading count for a device.

#### GET `/reading/device/name/{name}`
Retrieves readings from a device with optional aggregation.

**Query Parameters:** offset, limit, numeric, aggregateFunc

#### GET `/reading/resourceName/{resourceName}`
Retrieves readings by resource name with optional aggregation.

#### GET `/reading/device/name/{deviceName}/resourceName/{resourceName}`
Retrieves readings by device and resource with optional aggregation.

#### GET `/reading/start/{start}/end/{end}`
Retrieves readings within time range with optional aggregation.

#### GET `/reading/resourceName/{resourceName}/start/{start}/end/{end}`
Retrieves readings by resource name and time range.

#### GET `/reading/device/name/{deviceName}/resourceName/{resourceName}/start/{start}/end/{end}`
Retrieves readings by device, resource, and time range.

#### GET `/reading/device/name/{deviceName}/start/{start}/end/{end}`
Retrieves readings by device and time range, optionally filtered by resource names in request body.

### Filter Management

#### POST `/filter`
Adds one or more filters for selective event/reading persistence.

**Request Body:**
```json
[
  {
    "requestId": "e6e8a2f4-eb14-4649-9e2b-175247911369",
    "apiVersion": "v3",
    "filter": {
      "type": "IN",
      "deviceName": "^device+",
      "eventSourceName": "^sensor+",
      "onChange": true,
      "onChangeThreshold": 5
    }
  }
]
```

**Response Codes:** 207 (Multi-Status), 400, 500

#### GET `/filter/id/{id}`
Retrieves a filter by UUID.

#### PUT `/filter/id/{id}`
Updates an existing filter.

#### DELETE `/filter/id/{id}`
Deletes a filter by UUID.

#### GET `/filter/deviceName/{deviceName}`
Retrieves filters for a specific device name.

#### DELETE `/filter/deviceName/{deviceName}`
Deletes all filters for a device name.

#### GET `/filter/all`
Retrieves all filters.

#### PUT `/filter/all`
Replaces all existing filters with new ones.

**Response Codes:** 207 (Multi-Status), 400, 500

#### DELETE `/filter/all`
Deletes all filters.

### Service Endpoints

#### GET `/config`
Returns current service configuration.

#### GET `/ping`
Health check endpoint.

**Response:**
```json
{
  "apiVersion": "v3",
  "timestamp": "Mon, 02 Jan 2006 15:04:05 MST",
  "serviceName": "core-data"
}
```

#### GET `/version`
Returns service version.

#### POST `/secret`
Adds exclusive service secrets to the Secret Store.

**Request Body:**
```json
{
  "requestId": "e6e8a2f4-eb14-4649-9e2b-175247911369",
  "apiVersion": "v3",
  "secretName": "credentials",
  "secretData": [
    {
      "key": "secret-key",
      "value": "secret-value"
    }
  ]
}
```

## Data Type Support

The Reading schema supports the following value types:
- **Scalar:** Bool, String, Uint8, Uint16, Uint32, Uint64, Int8, Int16, Int32, Int64, Float32, Float64
- **Arrays:** BoolArray, StringArray, Uint8Array through Uint64Array, Int8Array through Int64Array, Float32Array, Float64Array
- **Complex:** Binary (with mediaType and binaryValue), Object (with objectValue)

## Filter Specifications

**Filter Properties:**
- `type`: IN (include) or OUT (exclude)
- `deviceName`: Regex pattern for device filtering
- `eventSourceName`: Regex pattern for source filtering
- `resourceName`: Regex pattern for resource filtering
- `onChange`: Persist only on value changes (default: false)
- `onChangeThreshold`: Threshold for numeric value changes (default: 0)

## Common Headers

**Request Header:**
- `X-Correlation-ID`: UUID for request tracing

**Response Header:**
- `X-Correlation-ID`: Returns the correlation ID from request

---

# Core Metadata API

## Overview

The EdgeX Foundry Core Metadata API manages provisioned devices and their associated services. The API runs locally on `http://localhost:59881/api/v3`.

## Core Concepts

### Devices
A device represents a physical or virtual entity managed by EdgeX. Each device:
- Associates with exactly one Device Service
- Conforms to a Device Profile
- Supports auto-generated events
- Contains protocol-specific communication details

### Device Profiles
Profiles define device classes with their capabilities and data formats. They include:
- Device Resources (readable/writable values)
- Device Commands (composed operations)
- Manufacturer and model information

### Device Services
Services proxy connectivity between devices and EdgeX core services. Each service:
- Has a unique name
- Maintains a base address (fully qualified URI)
- Can include transformation scripts
- Has administrative state (LOCKED/UNLOCKED)

### Provision Watchers
Watchers define auto-discovery filtering criteria with:
- Identifier patterns to match
- Blocking identifiers to exclude
- Associated device profiles for discovered devices

## API Endpoints

### Devices

#### POST /device
Create new devices in bulk.

**Parameters:**
- `X-Correlation-ID` (header, optional): UUID for request tracing
- `bypassValidation` (query, optional): Skip Device Service validation
- `force` (query, optional): Force add if device name exists

**Request Body:**
Array of device creation requests containing:
- `name` (required): Unique device identifier
- `adminState` (required): LOCKED or UNLOCKED
- `operatingState` (required): UP, DOWN, or UNKNOWN
- `serviceName` (required): Associated Device Service
- `profileName`: Associated Device Profile
- `protocols` (required): Map of supported protocols
- `autoEvents`: Automatic event generation rules
- `labels`: Search/identification tags
- `location`: Service-specific location data
- `properties`: Device-specific addressing properties
- `tags`: Custom key-value pairs

**Responses:**
- 207 Multi-Status: Partial success; check individual status codes
- 400 Bad Request: Invalid request
- 500 Internal Server Error

#### PATCH /device
Update existing devices.

#### GET /device/all
Retrieve all devices with pagination and filtering.

**Parameters:**
- `offset` (query, default: 0): Number of items to skip
- `limit` (query, default: 20): Items to return (-1 returns all)
- `labels` (query, optional): Filter by comma-delimited labels
- `descendantsOf` (query, optional): Filter by parent device name
- `maxLevels` (query, default: 0): Maximum hierarchy depth (0=unlimited)

#### GET /device/check/name/{name}
Check device existence by name.

#### GET /device/name/{name}
Retrieve device details by name.

#### DELETE /device/name/{name}
Remove device by name.

#### GET /device/profile/name/{name}
List all devices assigned to a specific profile.

#### GET /device/service/name/{name}
List all devices assigned to a specific service.

### Device Profiles

#### POST /deviceprofile
Create new device profiles.

**Request Body:**
Array of profile creation requests:
- `name` (required): Unique profile identifier
- `description`: Profile description
- `manufacturer`: Device manufacturer
- `model`: Device model
- `labels`: Search/categorization tags
- `deviceResources` (optional): Array of readable/writable resources
- `deviceCommands` (optional): Array of composed operations

#### PUT /deviceprofile
Update existing device profiles.

#### POST /deviceprofile/uploadfile
Create profile from YAML file upload.

#### PUT /deviceprofile/uploadfile
Update profile from YAML file upload.

#### GET /deviceprofile/all
Retrieve all profiles with pagination.

#### GET /deviceprofile/name/{name}
Retrieve profile by name.

#### DELETE /deviceprofile/name/{name}
Remove profile by name.

#### POST /deviceprofile/{name}/resource
Add resource to existing profile.

#### PATCH /deviceprofile/{name}/resource
Update existing resource.

#### DELETE /deviceprofile/{name}/resource/{resourcename}
Remove resource from profile.

#### POST /deviceprofile/{name}/devicecommand
Add device command to profile.

#### PATCH /deviceprofile/{name}/devicecommand
Update device command.

#### DELETE /deviceprofile/{name}/devicecommand/{commandname}
Remove device command.

#### PATCH /deviceprofile/{name}/basicinfo
Update profile basic information.

#### PATCH /deviceprofile/{name}/tags
Update tags on resources and commands.

### Device Services

#### POST /deviceservice
Create new device services.

**Request Body:**
Array of service creation requests:
- `name` (required): Unique service identifier
- `adminState` (required): LOCKED or UNLOCKED
- `baseAddress` (required): Fully qualified URI (protocol://host:port/path)
- `description`: Service description
- `labels`: Categorization tags
- `transformScript`: Optional Lua transformation functions

#### PATCH /deviceservice
Update existing device services.

#### GET /deviceservice/all
List all device services with pagination.

#### GET /deviceservice/name/{name}
Retrieve service by name.

#### DELETE /deviceservice/name/{name}
Remove service by name.

### Provision Watchers

#### POST /provisionwatcher
Create provision watchers for device auto-discovery.

#### PUT /provisionwatcher
Update existing provision watchers.

#### GET /provisionwatcher/all
List all provision watchers.

#### GET /provisionwatcher/name/{name}
Retrieve watcher by name.

#### DELETE /provisionwatcher/name/{name}
Remove provision watcher.

### Utility Endpoints

#### GET /ping
Health check endpoint.

#### GET /version
Retrieve latest supported API version.

#### GET /config
Get service configuration.

#### GET /unitsofmeasure
Retrieve units of measure definitions.

#### POST /secret
Store secret credentials.

## Data Types

### AutoEvent
Defines automatic event generation:
- `interval`: Duration string (e.g., "100ms", "24h")
- `onChange`: Generate events only on value change
- `onChangeThreshold`: Numeric threshold for change detection
- `sourceName`: Resource/command name
- `retention`: Event retention policies (maxCap, minCap, duration)

### ResourceProperties
Constraints for device values:
- `valueType` (required): Bool, String, Uint8-64, Int8-64, Float32-64, Binary, or array variants
- `readWrite` (required): R, W, or RW
- `units`: Measurement units (e.g., "deg/s", "Fahrenheit")
- `minimum`/`maximum`: Value bounds
- `defaultValue`: Initial value
- `mask`: Integer bit mask
- `shift`: Post-mask offset
- `scale`: Multiplicative factor
- `offset`: Additive factor
- `base`: Power operation base
- `assertion`: Error-checking required value
- `mediaType`: For binary data types

### DeviceCommand
Composed device operation:
- `name` (required): Command identifier
- `readWrite` (required): R, W, or RW
- `resourceOperations` (required): Array of operations
- `isHidden`: Visibility in CoreCommand service
- `tags`: Additional metadata

### ResourceOperation
Single command operation:
- `deviceResource` (required): Referenced resource name
- `defaultValue`: Compatible with resource type
- `mappings`: String-type value mappings

## Query Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| offset | 0 | Number of items to skip |
| limit | 20 | Items per response (-1=all) |
| labels | - | Comma-delimited label filter |
| descendantsOf | - | Parent device name filter |
| maxLevels | 0 | Hierarchy depth limit |
| bypassValidation | false | Skip service validation |
| force | false | Override duplicate checking |

## Status Code Summary

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 207 | Multi-status partial success |
| 400 | Invalid request |
| 404 | Not found |
| 409 | Conflict/duplicate |
| 416 | Range unsatisfiable |
| 423 | Locked/restricted |
| 500 | Server error |

---

# Core Command API

## Overview

The Core Command API manages command definitions and executes reads/writes against target devices within the EdgeX Foundry IoT microservice platform.

**API Version:** 4.0.0
**Base URL:** `http://localhost:59882/api/v3`

## API Endpoints

### Device Command Execution

#### GET `/device/name/{name}/{command}`
Execute a read command against a specific device.

**Parameters:**
- `name` (path, required): Device identifier
- `command` (path, required): Command name
- `ds-pushevent` (query): Push event to EdgeX system (true/false, default: false)
- `ds-returnevent` (query): Include Event in response (true/false, default: true)
- `jsonObject` (query): Base64-encoded JSON for additional parameters
- `X-Correlation-ID` (header): Request correlation identifier

**Responses:**
- 200 OK: EventResponse with command results
- 400 Bad Request: Invalid request state
- 404 Not Found: Device or command unavailable
- 423 Locked: Device administratively locked or non-operational
- 500 Internal Server Error
- 503 Service Unavailable

#### PUT `/device/name/{name}/{command}`
Execute a write command against a specific device.

**Request Body:**
```json
{
  "ResourceName": "value",
  "AnotherResource": "value"
}
```

**Responses:**
- 200 OK: BaseResponse confirmation
- 400 Bad Request
- 404 Not Found
- 423 Locked
- 500 Internal Server Error
- 503 Service Unavailable

### Device Command Discovery

#### GET `/device/name/{name}`
Retrieve all commands associated with a specified device.

**Example Response:**
```json
{
  "apiVersion": "v3",
  "statusCode": 200,
  "deviceCoreCommand": {
    "deviceName": "testDevice",
    "profileName": "testProfile",
    "coreCommands": [
      {
        "name": "coolingpoint1",
        "get": true,
        "path": "/api/v3/device/name/testDevice/command/coolingpoint1",
        "url": "http://localhost:59882",
        "parameters": [{"resourceName": "resource1", "valueType": "Int32"}]
      }
    ]
  }
}
```

#### GET `/device/all`
Retrieve paginated list of all device commands system-wide.

**Query Parameters:**
- `offset` (default: 0): Number of items to skip
- `limit` (default: 20): Items to return (-1 returns all)

### Service Management

#### GET `/config`
Retrieve current service configuration.

#### GET `/ping`
Health check endpoint.

#### GET `/version`
Retrieve service version information.

#### POST `/secret`
Store service-exclusive secrets.

---

# Core Keeper API

## Overview

The Core Keeper API is part of the EdgeX Foundry IoT microservice platform (v4.0.0). It manages key-value storage and service registration functionality.

**Base URL:** `http://localhost:59890/api/v3`

## Key-Value Storage Endpoints

### GET /kvs/key/{key}
Retrieves values associated with a specified key prefix.

**Parameters:**
- `key` (path, required): Unique identifier for the key
- `plaintext` (query, optional): Returns unencoded values when true; defaults to false
- `keyOnly` (query, optional): Returns only keys without values when true

### PUT /kvs/key/{key}
Creates or updates key-value pairs at a specified path.

**Parameters:**
- `key` (path, required): Target key location
- `flatten` (query, optional): Flattens JSON object before storage when true

**Request Body:**
```json
{
  "value": {}
}
```

### DELETE /kvs/key/{key}
Removes a specific key or all keys matching a prefix.

**Parameters:**
- `key` (path, required): Target key identifier
- `prefixMatch` (query, optional): Deletes all matching prefixes when true; defaults to false

## Service Registration Endpoints

### POST /registry
Registers a new service in the system.

**Request Body:**
```json
{
  "apiVersion": "v3",
  "registration": {
    "serviceId": "service-name",
    "status": "UNKNOWN",
    "host": "hostname",
    "port": 59882,
    "healthCheck": {
      "interval": "10s",
      "path": "/api/v3/ping",
      "type": "http"
    }
  }
}
```

### PUT /registry
Updates an existing service registration.

### GET /registry/serviceId/{serviceId}
Retrieves registration details for a specific service.

### DELETE /registry/serviceId/{serviceId}
Deregisters a service from the system.

### GET /registry/all
Retrieves all service registrations.

**Parameters:**
- `deregistered` (query, optional): Includes halted services when true; defaults to false

## Core Data Models

**Registration Object:**
- `created`: Timestamp of creation (milliseconds)
- `modified`: Timestamp of last modification (milliseconds)
- `serviceId`: Unique service identifier
- `status`: Health status (UP, DOWN, UNKNOWN, HALT)
- `host`: Service address
- `port`: Service port number
- `healthCheck`: Health check configuration
- `lastConnected`: Last response timestamp (milliseconds)

**HealthCheck Object:**
- `interval`: Check frequency interval
- `path`: Health check endpoint path
- `type`: Protocol type (required field)

**KeyValue Object:**
- `created`: Storage timestamp
- `modified`: Last modification timestamp
- `key`: Storage path
- `value`: Stored data

---

# Edge Historian API

## Overview

The Edge Historian API is part of the EdgeX Foundry IoT microservice platform, designed to handle storage and retrieval of event and reading data from edge devices.

**Base URL:** `http://localhost:59926/api/v3`
**API Version:** 4.0.0

## Core Data Models

### Event
A discrete event containing one or more readings with metadata:
- `id` (UUID): Unique identifier
- `deviceName` (string): Source device
- `profileName` (string): Device profile reference
- `sourceName` (string): Resource or command name
- `origin` (integer): Unix timestamp in nanoseconds
- `readings` (array): Collection of reading objects
- `tags` (object): Optional metadata (location, gateway info, etc.)

### Reading
Individual data point within an event:
- `deviceName`: Source device identifier
- `resourceName`: Device resource name
- `profileName`: Device profile name
- `origin`: Timestamp in nanoseconds
- `valueType`: Data type (Bool, String, Int8-64, Uint8-64, Float32-64, Binary, Object, or array variants)
- `value`: String representation of data
- `binaryValue` (optional): Byte array for binary data
- `mediaType` (optional): MIME type for binary content
- `objectValue` (optional): Complex structured data

### Filter
Event filtering mechanism with pattern matching:
- `id` (UUID): Filter identifier
- `type`: IN (include) or OUT (exclude)
- `deviceName`: Device pattern (regex supported)
- `eventSourceName`: Source pattern (regex supported)
- `resourceName`: Resource pattern (regex supported)
- `onChange` (boolean): Persist only on value changes
- `onChangeThreshold` (number): Numeric change threshold for numeric types

### Retention Policy
Data lifecycle management:
- `id` (UUID): Policy identifier
- `deviceName`: Target device pattern (regex)
- `sourceName`: Target source pattern (regex)
- `duration`: Retention period (format: "1.5h", "7d")

## API Endpoints

### Event Management

#### POST `/event/{serviceName}/{profileName}/{deviceName}/{sourceName}`
Ingest new event/reading data

#### GET `/event/all`
Retrieve paginated events sorted by origin (descending)

#### GET `/event/id/{id}`
Retrieve specific event by UUID

#### DELETE `/event/id/{id}`
Remove event by UUID

#### GET `/event/count`
Get total event count in database

#### GET `/event/count/device/name/{name}`
Get event count for specific device

#### GET `/event/device/name/{name}`
Retrieve paginated events from specific device

#### DELETE `/event/device/name/{name}`
Remove all events for device

**Response Codes:** 202 (Accepted), 400, 500

#### GET `/event/start/{start}/end/{end}`
Retrieve events within time range

#### DELETE `/event/age/{age}`
Remove old events based on age threshold

**Response Codes:** 202 (Accepted), 400, 500

### Reading Management

#### GET `/reading/all`
Retrieve all readings with pagination and optional aggregation

**Query Parameters:**
- `offset`, `limit`, `numeric`
- `aggregateFunc`: MIN, MAX, COUNT, SUM, AVG (case-insensitive; numeric fields only)

#### GET `/reading/count`
Get total reading count

#### GET `/reading/count/device/name/{name}`
Get reading count for device

#### GET `/reading/device/name/{name}`
Retrieve readings from specific device with aggregation support

#### GET `/reading/resourceName/{resourceName}`
Retrieve readings by resource name

#### GET `/reading/device/name/{deviceName}/resourceName/{resourceName}`
Retrieve readings by device and resource with aggregation

#### GET `/reading/start/{start}/end/{end}`
Retrieve readings within time range

#### GET `/reading/resourceName/{resourceName}/start/{start}/end/{end}`
Retrieve readings by resource and time range

#### GET `/reading/device/name/{deviceName}/resourceName/{resourceName}/start/{start}/end/{end}`
Retrieve readings with all filtering criteria

#### GET `/reading/device/name/{deviceName}/start/{start}/end/{end}`
Retrieve device readings within time range

### Filter Management

#### POST `/filter`
Add one or more filters

**Response Codes:** 207 (Multi-Status), 400, 500

#### GET `/filter/all`
Retrieve all filters

#### GET `/filter/id/{id}`
Retrieve filter by ID

#### PUT `/filter/id/{id}`
Update existing filter

#### DELETE `/filter/id/{id}`
Remove filter by ID

#### GET `/filter/deviceName/{deviceName}`
Retrieve filters by exact device name match

#### DELETE `/filter/deviceName/{deviceName}`
Remove all filters for device

#### PUT `/filter/all`
Replace all filters with new ones

**Response Codes:** 207 (Multi-Status), 400, 500

#### DELETE `/filter/all`
Remove all filters

### Retention Policy Management

#### POST `/retentionpolicy`
Add one or more retention policies

#### GET `/retentionpolicy/id/{id}`
Retrieve policy by ID

#### PUT `/retentionpolicy/id/{id}`
Update existing policy

#### DELETE `/retentionpolicy/id/{id}`
Remove policy by ID

## Key Features

- **Aggregation Support:** Numeric readings support MIN, MAX, COUNT, SUM, and AVG calculations across filtered datasets.
- **Flexible Filtering:** Regex pattern matching on device names, event sources, and resource names with include/exclude logic.
- **Retention Management:** Policy-based automatic deletion of old events using duration specifications.
- **Value Change Detection:** Filters can persist readings only when values change or exceed defined thresholds.
- **Time-Range Queries:** All timestamp parameters use Unix nanoseconds for precision.

---

# Support Notifications API

## Overview

The Support Notifications API is part of the EdgeX Foundry IoT microservices platform, enabling notification distribution through email and REST protocols. The service operates at `http://localhost:59860/api/v3`.

## Core Concepts

### Notifications
Notifications represent messages to be sent, containing content, metadata, and processing status. They progress through states: NEW, PROCESSED, or ESCALATED, with optional acknowledgment tracking.

### Subscriptions
Subscriptions define delivery preferences for specific parties, linking recipients to notification categories via multiple channel types (REST, EMAIL, MQTT, ZeroMQ).

### Transmissions
Transmissions record individual delivery attempts for each notification-subscription pairing, tracking success/failure with detailed records.

## API Endpoints

### Notification Management

**POST /notification** - Add one or more notifications
- Accepts array of notification requests
- Returns 207 multi-status response
- Required fields: content, sender, severity

**GET /notification** - Query notifications with filters
- Supports category, timestamp range filtering
- Pagination via offset/limit parameters

**GET /notification/start/{start}/end/{end}** - Time-range query

**GET /notification/category/{category}** - Filter by category

**GET /notification/label/{label}** - Filter by label

**GET /notification/status/{status}** - Filter by status (NEW, PROCESSED, ESCALATED)

**GET /notification/subscription/name/{name}** - Subscription-linked notifications

**GET /notification/id/{id}** - Single notification retrieval

**DELETE /notification/id/{id}** - Remove notification and transmissions

**DELETE /notification/ids/{ids}** - Batch deletion

**PUT /notification/acknowledge/ids/{ids}** - Acknowledge notifications

**PUT /notification/unacknowledge/ids/{ids}** - Reverse acknowledgment

**DELETE /notification/age/{age}** - Cleanup processed notifications

### Subscription Management

**POST /subscription** - Create subscriptions
- Required: name, channels, receiver, adminState

**PATCH /subscription** - Update existing subscriptions

**GET /subscription/all** - Retrieve all subscriptions

**GET /subscription/category/{category}** - Filter by category

**GET /subscription/label/{label}** - Filter by label

**GET /subscription/receiver/{receiver}** - Filter by receiver

**GET /subscription/name/{name}** - Single subscription retrieval

**DELETE /subscription/name/{name}** - Remove subscription

### Transmission Management

**GET /transmission/all** - Retrieve all transmissions

**GET /transmission/id/{id}** - Single transmission retrieval

**GET /transmission/subscription/name/{name}** - Filter by subscription

**GET /transmission/start/{start}/end/{end}** - Time-range query

**GET /transmission/status/{status}** - Filter by status

**GET /transmission/notification/id/{id}** - Filter by notification

**DELETE /transmission/age/{age}** - Cleanup old transmissions

### Maintenance

**DELETE /cleanup** - Complete cleanup (removes all notifications and transmissions)

**DELETE /cleanup/age/{age}** - Age-based cleanup

## Channel Types

### REST Address
- Host, port, path parameters
- HTTP method selection
- Optional EdgeX JWT authentication injection

### Email Address
- Array of email targets

### MQTT Publish Address
- Connection scheme, host, port configuration
- Topic and quality-of-service settings
- Optional username/password authentication
- TLS certificate verification options

### ZeroMQ Address
- Host, port, and topic parameters

## Notification Severity Levels
MINOR, NORMAL, CRITICAL

## Key Features
- Acknowledgment Tracking
- Resend Capability (configurable retry limits and intervals)
- Admin State Control (LOCKED/UNLOCKED)
- Label-Based Organization
- Timestamp Filtering
- Multi-Channel Delivery
- Credential Management

---

# Support Scheduler API

## Overview

The Support Scheduler service within EdgeX Foundry enables scheduling of various actions across the IoT microservice platform. This API (version 4.0.0) operates on `http://localhost:59863/api/v3`.

## Core Concepts

**Schedule Jobs**: Tasks configured to execute at specified intervals or according to cron expressions. Each job contains one or more actions and a schedule definition.

**Schedule Actions**: Executable tasks that can be one of three types:
- REST: HTTP endpoint calls
- EDGEXMESSAGEBUS: Message publishing to EdgeX topics
- DEVICECONTROL: Direct device manipulation

**Schedule Definitions**: Either interval-based (repeating at fixed durations) or cron-based (following cron syntax with timezone support).

**Action Records**: Transaction logs documenting when scheduled actions executed, including their success/failure status.

## API Endpoints

### Job Management

#### POST /job
Creates one or more new schedule jobs with unique names.

**Example Request**:
```json
{
  "apiVersion": "v3",
  "scheduleJob": {
    "name": "test_job_1",
    "definition": {
      "type": "CRON",
      "crontab": "CRON_TZ=Asia/Taipei 0 0 1 1 *"
    },
    "actions": [{
      "type": "REST",
      "address": "http://localhost:59881/api/v3/ping",
      "method": "GET",
      "contentType": "application/json"
    }],
    "adminState": "UNLOCKED",
    "autoTriggerMissedRecords": true
  }
}
```

#### PATCH /job
Updates existing schedule jobs identified by ID or name.

#### GET /job/all
Retrieves all schedule jobs with pagination and filtering.

#### GET /job/name/{name}
Retrieves a specific schedule job by name.

#### DELETE /job/name/{name}
Removes a schedule job and halts associated actions.

#### POST /job/trigger/name/{name}
Manually initiates execution of a specified job.

### Action Records

#### GET /scheduleactionrecord/all
Retrieves all execution records across all jobs.

#### GET /scheduleactionrecord/status/{status}
Filters action records by execution outcome (SUCCEEDED, FAILED, or MISSED).

#### GET /scheduleactionrecord/job/name/{name}
Retrieves all execution records for a specific job.

#### GET /scheduleactionrecord/job/name/{name}/status/{status}
Combines job name and status filtering.

#### GET /scheduleactionrecord/latest/job/name/{name}
Returns the most recent action records for a job.

## Schema Definitions

**ScheduleJob**: Contains name, actions array, schedule definition, admin state (LOCKED/UNLOCKED), auto-trigger flag, labels, and custom properties.

**CronScheduleDef**: Extends ScheduleDef with `crontab` expression supporting timezone syntax.

**IntervalScheduleDef**: Extends ScheduleDef with `interval` duration string (e.g., "10m").

**ScheduleAction**: Base action with type, contentType, and payload; extended by REST, EdgeXMessageBus, and DeviceControl variants.

**ScheduleActionRecord**: Immutable transaction log with action details, job name, creation/execution timestamps, and status.

---

# Support Sparkplug API

## Overview

The Edge Central Support Sparkplug API (v4.0.0) enables communication with Sparkplug-enabled applications like SCADA/IIOT systems. The service operates as a Sparkplug B Edge of Network node.

**Base URL:** `http://localhost:59996/api/v3`

## API Endpoints

### GET /ping
Health check endpoint.

### GET /version
Reports current service version supported.

### GET /config
Retrieves service configuration details.

### GET /metrics
Obtains CPU and memory utilization statistics.

**Example Response:**
```json
{
  "apiVersion": "v3",
  "metrics": {
    "memAlloc": 877192,
    "cpuBusyAvg": 2.25
  }
}
```

### POST /secret
Adds service-exclusive secrets to the Secret Store.

**Request Body:**
```json
{
  "apiVersion": "v3",
  "path": "/vault/path",
  "secretData": [
    {
      "key": "cacert",
      "value": "cacert-value"
    }
  ]
}
```

---

# System Management API

## Overview

The Edge Central System Management API provides endpoints for managing EdgeX microservices and supported infrastructure. The API base URL is `http://localhost:58890/api/v3`.

**API Version:** 4.0.0

## Core Data Models

### MicroService
Container information object with properties:
- `id`: Container identifier
- `names`: Array of assigned container names
- `image`: Docker image name
- `created`: Container creation timestamp
- `ports`: Exposed port mappings (ip, privatePort, publicPort, type)
- `labels`: User-defined metadata
- `state`: Container state (created, restarting, running, removing, paused, exited, dead)
- `ipAddress`: Container IPv4 address

### OperationRequest
Service operation instruction:
- `action` (enum): Operation type — start, stop, restart, rm, or inspect
- `serviceName` (string): Target service name

## API Endpoints

### Health Management

**GET /system/health**
Obtain health information from the targeted service.
- Parameters: `services` (query, required) - Comma-separated service names
- Response: 207 Multi-Status

**GET /ping**
Health check endpoint.

**GET /version**
Version endpoint.

### Metrics & Configuration

**GET /system/metrics**
Obtain metrics information from the targeted service(s).
- Parameters: `services` (query, required)

**GET /system/config**
Obtain configuration from the targeted service(s).
- Parameters: `services` (query, required)

**GET /config**
Returns the current configuration of the service.

### Service Operations

**POST /system/operation**
Issue a start, stop or restart action to the targeted service.
- Request Body: Array of OperationRequest objects

**POST /system/app/name/{name}**
Create app-service container named 'app-service-{name}' with configuration.
- Request Body: YAML-formatted configuration object

**POST /system/app/operation**
Issue a start, stop, restart, rm or inspect action to the targeted application service.

### Microservice Management

**GET /system/microservices**
Returns a list of microservices.
- Parameter: `all` (query, optional, boolean, default: false)

**GET /system/microservices/name/{name}/logs**
Get logs from the specified container.
- Parameters:
  - `name` (path, required): Microservice name
  - `since` (query, optional, integer): Beginning timestamp
  - `until` (query, optional, integer): Ending timestamp
  - `tail` (query, optional, integer, default: 200, minimum: -1): Number of log lines
  - `timestamps` (query, optional, boolean, default: false): Add timestamps

---

# Application Services API

## Overview

The Application Services API facilitates processing/transforming/exporting data out of EdgeX within the EdgeX Foundry IoT platform. The API operates on version 4.0.0.

## API Endpoints

### GET /config
Retrieves current service configuration.

### GET /ping
Health check endpoint.

### POST /secret
Stores secrets to the service's Secret Store.

### POST /trigger
Initiates HTTP-triggered function pipeline. Activates when 'http' trigger type is configured; processes submitted data through the defined pipeline.

**Request Body:** JSON object matching the Application Service's Target Type (defaults to EdgeX Events model)

**Responses:**
- 200 OK: Returns optional pipeline output data
- 400 Bad Request
- 422 Unprocessable Entity: Processing error
- 500 Internal Server Error

### GET /version
Returns service version and SDK information.

---

# Device Service API

## Overview

The EdgeX Foundry Device Service API (v4.0.0) enables IoT device management within the EdgeX Foundry microservice platform. Device services handle reading acquisition and value writing to target devices.

**Base URL:** `http://0:49999/api/v3`

## API Endpoints

### Device Command Operations

#### GET `/device/name/{name}/{command}`
Retrieves current or new event/reading values for a specified device and command.

**Parameters:**
- `name` (path): Device identifier
- `command` (path): Command identifier
- `ds-pushevent` (query): Push events to EdgeX system (default: false)
- `ds-returnevent` (query): Return Event in response (default: true)
- `ds-regexcmd` (query): Treat command as regex (default: true)
- `jsonObject` (query): Base64-encoded JSON for additional parameters

#### PUT `/device/name/{name}/{command}`
Triggers actions or sets values on actuator resources.

**Request Body:**
```json
{
  "ResourceName": "value_string",
  "AnotherResource": "another_value"
}
```

### Secret Management

#### POST `/secret`
Stores encrypted credentials in the secure Secret Store.

### Device Discovery

#### POST `/discovery`
Initiates device discovery process.

**Response Codes:** 202 (Accepted), 423 (Locked), 500, 503

#### DELETE `/discovery`
Stops ongoing discovery process.

#### DELETE `/discovery/requestId/{requestId}`
Stops discovery process with specified request identifier.

### Profile Scanning

#### POST `/profilescan`
Generates device profile through automated scanning.

**Request Body:**
```json
{
  "apiVersion": "v3",
  "deviceName": "TestDevice",
  "profileName": "TestDevice_profile_timestamp",
  "options": {
    "DiscoverMode": "All"
  }
}
```

**Response Codes:** 202 (Accepted), 400, 404, 409 (Conflict), 423 (Locked), 500, 501 (Not Implemented)

#### DELETE `/profilescan/device/name/{name}`
Stops profile scanning for specific device.

### Service Information

#### GET `/config`, GET `/ping`, GET `/version`
Standard service information endpoints.

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Successful GET/PUT operation |
| 201 | Resource created successfully |
| 202 | Request accepted for async processing |
| 400 | Malformed request |
| 404 | Resource not found |
| 405 | Operation unsupported for resource |
| 409 | Conflict (duplicate profile name) |
| 423 | Device or service administratively locked |
| 500 | Unexpected server error |
| 501 | Operation not implemented |
| 503 | Service unavailable |

---

# Proxy Authentication API

## Overview

The Edge Central Proxy Authentication API (v4.0.0) provides comprehensive authentication, authorization, user management, and role-based access control capabilities. The service runs locally on `http://localhost:59842/api/v3`.

## Core Features

- **User Management**: Create, update, retrieve, and delete user accounts
- **Authentication**: Login with credentials and JWT token refresh
- **Authorization**: Role-based access control with granular policy definitions
- **Session Management**: Logout and token lifecycle management
- **Key Management**: Store and retrieve cryptographic keys for verification and signing
- **Secret Storage**: Secure storage of sensitive data
- **GraphQL Support**: Authorization checks for GraphQL operations

## API Endpoints

### User Management

#### POST `/user`
Creates one or more new user accounts with role assignments.

#### PATCH `/user`
Modifies existing user details, roles, or credentials.

#### GET `/user/all`
Retrieves paginated list of all users, sorted by last modification descending.

#### GET `/user/name/{name}`
Retrieves specific user information by username.

#### DELETE `/user/name/{name}`
Removes a user account from the system.

### Authentication & Authorization

#### POST `/login`
Authenticates a user with credentials and returns a JWT token.

#### POST `/logout`
Invalidates the user session and revokes the current token.

#### POST `/auth`
Validates JWT and checks authorization for a specific URI and method.

**Headers:**
- `Authorization`: Bearer token (required)
- `X-Forwarded-Uri`: Original request URI
- `X-Forwarded-Method`: Original HTTP method

#### POST `/auth-routes`
Batch authorization check for multiple URI/method combinations.

#### POST `/auth/graphql`
Specialized authorization endpoint for GraphQL operations (QUERY, MUTATION, SUBSCRIPTION).

#### POST `/refresh-token`
Reissues an expired JWT token if within the grace period.

### Role-Based Access Control

#### POST `/rolepolicy`
Defines a new role with associated access policies.

#### GET `/rolepolicy/all`
Retrieves paginated list of all defined roles.

#### GET `/rolepolicy/role/{role}`
Retrieves specific role policy definition.

#### PUT `/rolepolicy/role/{role}`
Modifies an existing role's access policies.

#### DELETE `/rolepolicy/role/{role}`
Removes a role from the access control model.

### Key Management

#### POST `/key`
Stores a cryptographic key with issuer information.

#### GET `/key/verification/issuer/{issuer}`
Retrieves a verification key by issuer name.

### Common HTTP Status Codes

- **200**: Successful retrieval
- **201**: Resource created successfully
- **204**: Successful operation with no content
- **207**: Multi-status response (batch operations)
- **400**: Invalid request parameters
- **401**: Authentication failure
- **403**: Authorization denied
- **404**: Resource not found
- **409**: Resource conflict
- **416**: Requested range unsatisfiable
- **500**: Server error

## Data Models

### User
Contains: id, name, displayName, description, password, roles array, created/modified timestamps

### RolePolicy
Contains: role name, description, access policies array, created/modified timestamps

### AccessPolicy
Defines: API path, allowable HTTP methods, effect (allow/deny)

---

# AI Inference API

## Overview

The AI Inference service provides resource tagging capabilities through asynchronous prediction tasks. The system accepts device resource names and returns predicted tags with confidence scores and metadata.

**API Version:** 4.0.0
**Base URL:** `http://localhost:59997/api/v3`

## Endpoints

### POST `/inference/resource_tag_points`
Submit a prediction task for device resource tags using trained models.

**Request Body:**
```json
{
  "apiVersion": "v3",
  "input": {
    "resourceNames": ["02HX01TWP_MINOFF", "02HX01P3ST"],
    "ontology": "eo66"
  }
}
```

**Responses:**

| Status | Description |
|--------|-------------|
| 202 | Request accepted |
| 400 | Invalid request state |
| 500 | Server error |

### GET `/inference/result/{requestId}`
Retrieve prediction results or progress for a submitted task.

**Response Structure:**
- `apiVersion`: API version
- `requestId`: Task identifier
- `processedItemCount`: Completed items
- `totalItemCount`: Total items submitted
- `output`: Contains `tagMetadataHeader` array and `predictedResults` array

**Predicted Result Fields:**
- `resourceName`: Input resource identifier
- `predicted`: Tag prediction (e.g., "eo66:mixedTempLoSp")
- `confidence`: Prediction confidence (0-1 range)
- `normalizedPoint`: Normalized representation string
- `tagMetadata`: Array describing tag characteristics

### GET `/ping`
Health check endpoint for service availability.

## Processing States

Tasks progress through three states:
1. **In Progress:** `processedItemCount < totalItemCount`
2. **Complete:** `processedItemCount == totalItemCount` with full results
3. **Partial Failure:** Some items return "predicted_unknown" with zero confidence
