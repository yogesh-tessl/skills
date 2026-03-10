<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/security/security-overview.html
    - https://docs.iotechsys.com/edge-central40/security/nginx.html
    - https://docs.iotechsys.com/edge-central40/security/jwt-authentication.html
    - https://docs.iotechsys.com/edge-central40/security/access-control-list.html
    - https://docs.iotechsys.com/edge-central40/security/secret-store.html
    - https://docs.iotechsys.com/edge-central40/security/secretstore-setup.html
    - https://docs.iotechsys.com/edge-central40/security/get-existed-jwt-authentication.html
    - https://docs.iotechsys.com/edge-central40/security/tls-mqtt-broker.html
    - https://docs.iotechsys.com/edge-central40/security/securing-supporting-services.html
  Synced: 2026-03-07
-->

# Edge Central Security Services

## 目錄

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [API Gateway - Nginx](#api-gateway---nginx)
  - [Introduction](#introduction)
  - [Services Overview](#services-overview)
  - [Security Proxy Auth Configuration](#security-proxy-auth-configuration)
  - [Starting Nginx](#starting-nginx)
  - [API Gateway Routing](#api-gateway-routing)
- [JWT Authentication](#jwt-authentication)
  - [Overview](#overview)
  - [Creating Access Tokens for API Gateway Authentication](#creating-access-tokens-for-api-gateway-authentication)
  - [Token Refresh](#token-refresh)
  - [External JWT Verification](#external-jwt-verification)
  - [Key Configuration Details](#key-configuration-details)
- [Authorization](#authorization)
  - [Overview](#overview)
  - [Authorization Model](#authorization-model)
  - [Role Policy API](#role-policy-api)
- [Secret Store Overview](#secret-store-overview)
  - [Purpose and Function](#purpose-and-function)
  - [Core Components](#core-components)
  - [Rootless Environment Considerations](#rootless-environment-considerations)
- [SecretStore Setup](#secretstore-setup)
  - [Overview](#overview)
  - [Retrieving the Root Token](#retrieving-the-root-token)
  - [Database Access Considerations](#database-access-considerations)
- [Retrieving JWT From Secret Store](#retrieving-jwt-from-secret-store)
  - [Overview](#overview)
  - [Obtaining the Secret Store Token](#obtaining-the-secret-store-token)
  - [Usage](#usage)
- [Securing the Internal MQTT Broker](#securing-the-internal-mqtt-broker)
  - [Overview](#overview)
  - [SSL Record Protocol](#ssl-record-protocol)
  - [TLS with Edge Central Message Bus](#tls-with-edge-central-message-bus)
- [Securing Supporting Services](#securing-supporting-services)
  - [Node-RED Security](#node-red-security)
  - [InfluxDB Security](#influxdb-security)
  - [Grafana Security](#grafana-security)
  - [Service Launch with Security](#service-launch-with-security)


## Table of Contents

- [API Gateway - Nginx](#api-gateway---nginx)
- [JWT Authentication](#jwt-authentication)
- [Authorization](#authorization)
- [Secret Store Overview](#secret-store-overview)
- [SecretStore Setup](#secretstore-setup)
- [Retrieving JWT From Secret Store](#retrieving-jwt-from-secret-store)
- [Securing the Internal MQTT Broker](#securing-the-internal-mqtt-broker)
- [Securing Supporting Services](#securing-supporting-services)

## Overview

The Security Services section of the Edge Central User Guide documents protective infrastructure for IoT deployments. The overview page introduces two primary security components:

**Nginx** - An open-source microservice API gateway and platform that Edge Central leverages as part of its API gateway architecture.

**OpenBao** - The EdgeX secret store, utilized by Edge Central to maintain user credentials securely.

The security documentation is organized into these sections:

- **API Gateway** (covering Nginx and authentication mechanisms)
- **Secret Store** (setup and JWT retrieval procedures)
- **Securing Internal Services** (message bus and supporting service protection)

---

## API Gateway - Nginx

### Introduction

Edge Central uses Nginx as a component of the API gateway. Previously, Kong served this role, but was replaced due to platform limitations and resource constraints. Nginx is lightweight and it supports more architecture which Kong is also built on top of.

The architecture pairs Nginx with the Security Proxy Auth microservice, which handles JWT and LDAP authentication plus role-based access control using Nginx's `http_auth_request_module`.

### Services Overview

| Service | Description |
|---------|-------------|
| nginx | Primary API Gateway component; started with `edgecentral up --api-gateway` |
| Security Proxy Auth | Processes advanced authentication for Nginx; includes secrets-config utility |
| PostgreSQL | Database supporting Security Proxy Auth |

### Security Proxy Auth Configuration

The service manages user accounts and role policies implementing RBAC. Key configuration properties under `TokenInfo`:

| Property | Default | Purpose |
|----------|---------|---------|
| AccessTokenDuration | 10m | JWT expiration period |
| LastChanceReissueDuration | 20m | Window for reissuing expired JWTs |
| Issuer | IOTechSystems | JWT issuer claim |
| DefaultAdminPassword | Admin@Edge0 | Admin user password (must change for production) |
| DefaultUserPassword | Default@Edge0 | Default user password |

### Starting Nginx

Basic command:
```
edgecentral up --api-gateway
```

#### TLS Certificate Requirements

- 證書必須是 X.509 PEM 編碼格式
- 私鑰必須是未加密的 PEM 編碼格式（若使用加密私鑰，API Gateway 將在啟動時掛起）
- 用戶端必須支援伺服器名稱識別（Server Name Identification, SNI）
- 用戶端必須使用 DNS 主機名稱連線，不能使用 IP 位址（API Gateway 使用用戶端提供的主機名稱來決定呈現哪張憑證）

#### Custom TLS Certificate Setup

Replace auto-generated certificates using secrets-config utility:
```
edgecentral run -v `pwd`:/host:ro --entrypoint /edgex/secrets-config \
  proxy-setup -- proxy tls --inCert /host/cert.pem --inKey /host/key.pem
```

Then restart:
```
edgecentral restart nginx
```

Verification command:
```
echo "GET /" | openssl s_client -showcerts -servername edge001.example.com \
  -connect 127.0.0.1:8443
```

### API Gateway Routing

Without API Gateway:
```
curl http://<host>:59880/api/v3/ping
```

With API Gateway and JWT authentication:
```
curl -k -H "Authorization: Bearer <JWT>" \
  https://<host>:8443/core-data/api/v3/ping
```

#### Microservice Path Mapping

The gateway routes requests based on path prefixes:

| Microservice | Path |
|--------------|------|
| Core Data | core-data |
| Core Metadata | core-metadata |
| Core Command | core-command |
| Core Keeper | core-keeper |
| Support Notifications | support-notifications |
| Support Scheduler | support-scheduler |
| Support Rules Engine | support-rulesengine |
| System Management | sys-mgmt |
| Device Services | device-virtual, device-rest, device-mqtt, device-opc-ua, device-bacnet-ip, device-bacnet-mstp, device-modbus, device-s7, device-gps, device-ble, device-onvif-camera, device-usb-camera, device-ethernet-ip, device-canbus, device-file, device-websocket |
| eKuiper | rules-engine |
| OpenBao | secret-store |

---

## JWT Authentication

### Overview

The API gateway requires authentication before forwarding requests to backend microservices. Starting with Edge Central v4.0, the Security Proxy Auth service manages JWT generation and verification, replacing the Vault identity secrets engine.

### Creating Access Tokens for API Gateway Authentication

#### Launch Edge Central

Start Edge Central services with the API Gateway:

```bash
edgecentral up --api-gateway device-virtual
```

#### Admin Login and JWT Retrieval

Obtain a JWT from the admin user account:

```bash
curl -k -X POST 'https://localhost:8443/login' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "admin",
    "password": "Admin@Edge0"
  }'
```

**Important Notes:**
- The default admin password is `Admin@Edge0` and must be changed before starting the service
- The `-k` flag bypasses certificate verification (for demonstration only; use trusted certificates in production)

**Sample Response:**
```json
{
  "apiVersion": "v3",
  "statusCode": 200,
  "jwt": "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9..."
}
```

#### Creating Role Policies

Define access permissions using the POST `/rolepolicy` endpoint:

```bash
curl -k -X POST 'https://localhost:8443/rolepolicy' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer ${jwt}' \
  -d '{
    "apiVersion": "v3",
    "rolePolicy": {
      "role": "device-admin",
      "accessPolicies": [
        {
          "path": "/core-metadata/api/v3/device(/.*)?$",
          "methods": ["GET", "PUT", "POST", "PATCH"],
          "effect": "allow"
        }
      ]
    }
  }'
```

#### Creating Users with Roles

Add a user with specific role assignments:

```bash
curl -k -X POST 'https://localhost:8443/user' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer ${jwt}' \
  -d '[{
    "apiVersion": "v3",
    "user": {
      "name": "deviceAdmin",
      "description": "A device dev user",
      "password": "Mysecret@1",
      "roles": ["device-admin"]
    }
  }]'
```

**Note:** If no role is specified, a default role with GET-only permissions across all APIs is assigned.

#### User Login and Token Generation

Retrieve JWT for a specific user:

```bash
curl -k -X POST 'https://localhost:8443/login' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "deviceAdmin",
    "password": "Mysecret@1"
  }'
```

#### Using JWT for API Calls

Include the JWT in the Authorization header when accessing REST APIs:

```bash
curl -k -H "Authorization: Bearer ${jwt}" \
  https://localhost:8443/<SERVICENAME>/api/v3/version
```

**Example - Create Device:**
```bash
curl -k -X POST 'https://localhost:8443/core-metadata/api/v3/device' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer ${jwt}' \
  -d '[{
    "apiVersion": "v3",
    "device": {
      "name": "testBoolean1",
      "description": "Example of Device Virtual",
      "adminState": "UNLOCKED",
      "operatingState": "UP",
      "labels": ["device-virtual-test"],
      "serviceName": "device-virtual",
      "profileName": "Random-Boolean-Device",
      "protocols": {
        "other": {
          "Address": "device-virtual-bool-01",
          "Port": 302
        }
      },
      "properties": {
        "IOTech_ProtocolName": "virtual"
      }
    }
  }]'
```

### Token Refresh

Tokens expire after 10 minutes with a 20-minute grace period. Refresh using:

```bash
curl -k -H 'Authorization: Bearer ${jwt}' \
  https://localhost:8443/refresh-token
```

If both expiration and grace period exceed, re-authentication is required.

### External JWT Verification

#### Prepare External JWT

**Header:**
```json
{
  "alg": "RS256",
  "typ": "JWT"
}
```

**Payload:**
```json
{
  "iss": "tester",
  "exp": 1859444083000
}
```

#### Generate Signing Keys

```bash
openssl genrsa -out private-key.pem 2048
openssl rsa -in private-key.pem -pubout -out public-key.pem
```

#### Register Verification Key

Add the public key to Security Proxy Auth:

```bash
curl -k --location 'https://localhost:8443/key' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <admin_jwt>' \
  --data '{
    "apiVersion": "v3",
    "keyData": {
      "issuer": "tester",
      "type": "verification",
      "key": "-----BEGIN PUBLIC KEY-----\n<key_content>\n-----END PUBLIC KEY-----\n"
    }
  }'
```

#### Verify External JWT

Test the external token against a service API:

```bash
curl -k -H 'Authorization: Bearer <ExternalJWT>' \
  https://localhost:8443/core-metadata/api/v3/deviceservice/all
```

### Key Configuration Details

- **Default JWT Duration:** 10 minutes
- **Last Chance Reissue Period:** 20 minutes
- **Algorithm:** EdDSA (default)
- **Issuer Required:** "IOTechSystems" (internal), custom for external JWTs

**JWT Claims 完整欄位：**

| Claim | 說明 |
|-------|------|
| `iss` | 簽發者（Issuer），內部預設為 "IOTechSystems" |
| `exp` | 過期時間（Expiration Time） |
| `token_id` | 權杖唯一識別碼 |
| `lcr` | 最後重新簽發機會（Last Chance Reissue），對應 LastChanceReissueDuration 設定 |

---

## Authorization

### Overview

Edge Central implements authorization through an Access Control List (ACL) model using **Casbin**, a powerful open-source access control library. This enables API access management based on user group roles.

### Authorization Model

The default allow-and-deny model is defined in `/res/model.conf` with the following structure:

```
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act, eft, basic_info

[role_definition]
g = _, _

[policy_effect]
e = some(where (p.eft == allow)) && !some(where (p.eft == deny))

[matchers]
m = g(r.sub, p.sub) && regexMatch(r.obj, p.obj) && regexMatch(r.act, p.act)
```

This model evaluates requests based on:
- **Subject (sub)**: User or group identifier
- **Object (obj)**: API resource path
- **Action (act)**: HTTP method or operation
- **Effect (eft)**: Allow or deny decision

### Role Policy API

The Security Proxy Auth service provides REST APIs for dynamic policy management at runtime. Role Policy 支援的 HTTP 方法包含：GET、PUT、POST、PATCH、DELETE。

#### Add a Policy

```bash
curl -X POST '<proxy-auth-ip>:59842/api/v3/rolepolicy' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "apiVersion": "v3",
    "rolePolicy": {
      "role": "new-group",
      "accessPolicies": [
        {
          "path": "/core-data/api/v3",
          "methods": ["GET", "PUT", "POST", "PATCH"],
          "effect": "allow"
        }
      ]
    }
  }'
```

#### Delete a Policy

```bash
curl -X DELETE '<proxy-auth-ip>:59842/api/v3/rolepolicy/role/new-group'
```

---

## Secret Store Overview

### Purpose and Function

The Secret Store serves as a centralized secure repository for sensitive information including tokens, passwords, and certificates used throughout Edge Central.

### Core Components

**Secret Store Service**: The primary service that handles secure storage of secrets.

**Secret Store Setup Service**: Responsible for unsealing and initializing the Secret Store. During initialization, it generates client tokens for each Edge Central microservice, enabling secure access when services operate in secure mode.

The Secret Store activates automatically when deploying with the `--secret` or `--api-gateway` flags using the `edgecentral up` command.

### Rootless Environment Considerations

#### Limitation

In rootless environments, the Secret Store normally attempts to lock memory to prevent sensitive data from being written to disk. This typically requires the `--cap-add=IPC_LOCK` flag. However, running as a non-root user can trigger this error:

"unable to set CAP_SETFCAP effective capability: Operation not permitted"

#### Solution

To address this limitation, memory locking is disabled and replaced with memory constraints. Setting both memory and memory-swap limits to identical values prevents swap space usage.

Two environment variables manage this configuration:

- `EDGECENTRAL_SER_MEM_LIMIT`: Sets container memory limit
- `EDGECENTRAL_SER_MEM_SWAP_LIMIT`: Sets memory swap limit

Example deployment with 500MB limits:
```bash
export EDGECENTRAL_SER_MEM_LIMIT=500m
export EDGECENTRAL_SER_MEM_SWAP_LIMIT=500m
edgecentral up --secret
```

Memory values require positive integers followed by b, k, m, or g suffixes (bytes, kilobytes, megabytes, gigabytes).

---

## SecretStore Setup

### Overview

The SecretStore Setup service in Edge Central performs two critical security functions:

1. **Token Creation**: Generates tokens enabling each microservice to access the Secret Store
2. **Password Generation**: Creates random Redis passwords for microservice database access

### Retrieving the Root Token

To obtain the root token for Secret Store access, follow these steps:

#### Step 1: Configure Environment Variables

Modify your local `docker-compose-security.yml` file to add environment settings:

```yaml
services:
  secret-store:
    ports:
      - "8200:8200"
  secretstore-setup:
    environment:
      SECRETSTORE_REVOKEROOTTOKENS: "false"
```

**Note**: Refer to docker-compose override documentation for proper environment variable configuration procedures.

#### Step 2: Extract Root Token

Execute this command to access the initialization response file:

```bash
docker run --rm -ti -v edgecentral_secret-store-config:/openbao/config:ro alpine:latest cat /openbao/config/assets/resp-init.json
```

This command retrieves the JSON output containing the `root_token` field value needed for Secret Store access.

### Database Access Considerations

**Important**: The SecretStore Setup microservice does not generate external service tokens. To access the database directly, retrieve the password from the Secret Store itself. For workarounds and additional information, consult the Known Issues documentation.

---

## Retrieving JWT From Secret Store

### Overview

This documentation covers obtaining JWT from the Secret Store for accessing Edge Central REST APIs when deployed with security enabled via the `--secret` flag.

This is for internal testing purpose. When Edge Central deploys with `--secret` but without an API Gateway, services are only accessible locally, and all REST APIs require JWT authentication.

**Deployment command:**
```
edgecentral up --secret
```

### Obtaining the Secret Store Token

Follow these three steps to retrieve a JWT:

#### Step 1: Extract Secret Store Credentials

Access credentials stored in `/tmp/edgex/secrets` (example uses core-metadata service):

```bash
username=$(sudo cat /tmp/edgex/secrets/core-metadata/secrets-token.json | jq -r '.auth.metadata.username')
secret_store_token=$(sudo cat /tmp/edgex/secrets/core-metadata/secrets-token.json | jq -r '.auth.client_token')
```

#### Step 2: Locate Secret Store IP

```bash
secret_store_ip=$(edgecentral ip | grep secret-store | cut -d '|' -f2)
```

#### Step 3: Generate JWT Token

```bash
jwt=$(curl -ks -H "Authorization: Bearer ${secret_store_token}" "http://${secret_store_ip}:8200/v1/identity/oidc/token/${username}" | jq -r '.data.token')
```

### Usage

Apply the JWT token in API requests through the Authorization header:

```bash
metadata_ip=$(edgecentral ip | grep core-metadata | cut -d '|' -f2)
curl -k -H "Authorization: Bearer ${jwt}" http://${metadata_ip}:59881/api/v3/version
```

---

## Securing the Internal MQTT Broker

### Overview

Transport Layer Security (TLS) is a cryptographic protocol that provides communications security over computer networks, using public-key cryptography for authentication and secret-key cryptography for privacy and data integrity.

### SSL Record Protocol

The SSL Record Protocol delivers two key services:

- **Confidentiality**: Encrypts data fragments using the Master Secret
- **Message Integrity**: Adds Message Authentication Code to each data fragment

### TLS with Edge Central Message Bus

In Edge Central, the CA certificate is created and signed by the SecretStore-Setup microservice using the OpenSSL utility. The SecretStore-Setup is responsible for creating the necessary keys, certificates, and Mosquitto configuration files, then sharing them with the MQTT broker and other Edge Central services.

#### Enabling TLS on the Message Bus

By default, the internal MQTT broker operates without TLS. To enable TLS-enabled `mqtt-broker` as the internal message bus, set these environment variables before executing `edgecentral up --secret`:

```bash
export EDGECENTRAL_MESSAGEBUS_MQTT_TLS=true
export EDGECENTRAL_MESSAGEBUS_PROTOCOL=tcps
export EDGECENTRAL_MESSAGEBUS_PORT=8883
export EDGECENTRAL_MESSAGEBUS_AUTHMODE=clientcert
```

For Application Services using the default Edge Central Message Bus:

```bash
export TRIGGER_EDGEXMESSAGEBUS_SUBSCRIBEHOST_PROTOCOL=tcps
export TRIGGER_EDGEXMESSAGEBUS_SUBSCRIBEHOST_PORT=8883
export TRIGGER_EDGEXMESSAGEBUS_PUBLISHHOST_PROTOCOL=tcps
export TRIGGER_EDGEXMESSAGEBUS_PUBLISHHOST_PORT=8883
export TRIGGER_EDGEXMESSAGEBUS_OPTIONAL_AUTHMODE=clientcert
```

#### Retrieving MQTT Client Credentials

After running `edgecentral up --secret`, retrieve credentials from the "edgecentral_mqtt-client-cert" volume:

```bash
docker volume inspect edgecentral_mqtt-client-cert
```

The output shows the Mountpoint location. List the contents:

```bash
sudo ls /var/lib/docker/volumes/edgecentral_mqtt-client-cert/_data
```

This directory contains: `ca.crt`, `mqtt.crt`, `mqtt.csr`, and `mqtt.key`.

Copy the credentials to your desired location:

```bash
sudo cp -r /var/lib/docker/volumes/edgecentral_mqtt-client-cert/_data /your/path/to/another/directory
```

#### Using App Services with TLS

Create an App Service using the MQTT function pipeline with these settings:

| Field | Value |
|-------|-------|
| Broker Address | tls://mqtt-broker:8883 |
| Topic | your-topic |
| Authentication Mode | Client Cert |
| CA Cert | ca.crt file |
| Client Key | mqtt.key file |
| Client Cert | mqtt.crt file |

#### Using Node-Red with TLS

Within Node-Red containers, TLS credentials are located at `/edgex/secrets/mqtt-client/`:

- **Certificate**: `/edgex/secrets/mqtt-client/mqtt.crt`
- **Private Key**: `/edgex/secrets/mqtt-client/mqtt.key`
- **CA Certificate**: `/edgex/secrets/mqtt-client/ca.crt`

Configure MQTT nodes by selecting "Use key and certificates from local files" and entering these file paths when adding `tls-config`.

---

## Securing Supporting Services

This documentation explains how to enable TLS for three supporting services in Edge Central: Node-RED, InfluxDB, and Grafana.

### Node-RED Security

To activate TLS on the Node-RED server, configure the environment variable on your host system:

```bash
export EDGECENTRAL_NODERED_TLS=true
```

### InfluxDB Security

For securing the InfluxDB server with TLS, set the corresponding environment variable:

```bash
export EDGECENTRAL_INFLUXDB_TLS=true
```

### Grafana Security

To protect Grafana communications with TLS, configure its environment variable:

```bash
export EDGECENTRAL_GRAFANA_TLS=true
```

### Service Launch with Security

Once you've configured the environment variables for your chosen services, Edge Central must be started using the `--secret` flag to properly initialize the TLS configuration.

**Example command** to launch a secure Node-RED instance:

```bash
edgecentral up --secret nodered
```

This approach ensures encrypted communication channels for the supporting services, enhancing overall system security when working with Edge Central deployments.
