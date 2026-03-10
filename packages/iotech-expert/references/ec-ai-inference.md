<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/ai-inference/overview.html
    - https://docs.iotechsys.com/edge-central40/ai-inference/getting-started.html
    - https://docs.iotechsys.com/edge-central40/ai-inference/ui.html
  Synced: 2026-03-07
-->

# Edge Central AI Inference Service

## Overview

The AI Inference Service is a microservice component within Edge Central that enables machine-learning inference capabilities for edge deployments. It functions as a Python application that loads trained ML models and exposes REST APIs for submitting and retrieving inference job results.

### Device-Resource Tag Prediction

The service utilizes a fine-tuned RoBERTa model to automatically infer semantic tags for device-resource names. This functionality supports standardization of point naming conventions across deployments.

### Architecture

The service operates through a straightforward asynchronous workflow:

1. Client submits an inference job via REST API
2. Service validates and queues the incoming request
3. ML model executes the prediction operation
4. Client retrieves results using the provided request identifier

The architecture emphasizes lightweight operation and scalable processing of concurrent inference requests.

### Operational Context

The AI Inference Service deploys alongside existing Edge Central environments. Users can interact with the service through:
- Edge Central UI interface
- Direct REST API calls

---

## Getting Started

### Service Configuration Options

The service exposes environment variables controlling concurrency, threading, and cache behavior. The following defaults apply when not explicitly set:

| Variable | Default | Purpose |
|----------|---------|---------|
| MAX_CONCURRENT_TASKS | 5 | Maximum parallel tagging tasks |
| INFERENCE_THREADS | 2 | CPU threads for inference execution |
| CONCURRENT_PREDICT_THRESHOLD | 5 | Minimum items for concurrent processing |
| MAX_CACHE_TASK_SIZE | 256 | Completed tasks retained in memory |
| REQUEST_TIMEOUT | 15 | HTTP request timeout (seconds) |
| INFERENCE_TASK_TIMEOUT | 30 | Task execution timeout (minutes) |
| LOG_LEVEL | INFO | Output granularity |

#### Docker Compose Configuration Override

Customize settings by specifying environment variables in your Docker Compose file:

```yaml
ai-inference:
  environment:
    MAX_CONCURRENT_TASKS: 5
    INFERENCE_THREADS: 2
    CONCURRENT_PREDICT_THRESHOLD: 5
    MAX_CACHE_TASK_SIZE: 256
    REQUEST_TIMEOUT: 15
    INFERENCE_TASK_TIMEOUT: 30
```

### Launching the Service

Start the AI Inference service with Edge Central UI using:

```bash
edgecentral up central-ui ai-inference
```

### REST API Usage

#### Initiate Inference Task

Submit a POST request to begin resource-tag inference:

**Endpoint:** `POST {baseUrl}/inference/resource_tag_points`

**Request Body:**
```json
{
  "input": {
    "resourceNames": [
      "02HX01TWP_MINOFF",
      "02HX01P3ST",
      "02HX01DPLP_TR"
    ],
    "ontology": "eo66"
  }
}
```

**Response:**
```json
{
  "apiVersion": "v3",
  "requestId": "fc29dc20-e4de-4fb4-a7f8-d69075390c70"
}
```

#### Retrieve Results

Use the request ID to fetch inference results:

**Endpoint:** `GET {baseUrl}/result/{requestId}`

**Sample Response Structure:**
```json
{
  "apiVersion": "v3",
  "output": {
    "predictedResults": [
      {
        "confidence": 0.148,
        "normalizedPoint": "0 2 Heat Exchanger...",
        "predicted": "eo66:mixedTempLoSp",
        "resourceName": "02HX01TWP_MINOFF",
        "tagMetadata": [...]
      }
    ],
    "processedItemCount": 3,
    "totalItemCount": 3
  }
}
```

---

## Running Resource Auto Tagging in Edge Central UI

### View All Resource Auto Tagging Jobs

Navigate to **Devices > Device Profiles > Resource Auto Tagging** to see all profiles supporting automatic resource tag generation. These profiles correspond to those listed on the main Profiles page.

### Generate Predicted Tags

1. Click the **magic wand icon** to initiate tag generation for profile resources
2. Monitor progress as the system processes resources (example: "70 / 156 resources processed")

### Review Predicted Tags

1. Click the **edit (pen) icon** to open the **Edit Resource Tags** page
2. Use the **Show/Hide Columns** button to customize visible columns
3. Modify tags using these methods:

#### Manual Editing
- Directly edit individual resource tags in the interface

#### Apply Tags
- Copy all predicted values to the **Tag** column for selected resources
- Use column header checkbox to select and apply tags in batch mode

#### Clear Tags
- Remove tag values for selected resources
- Use column header checkbox for batch clearing

#### CSV File Management
- **Download**: Export resource tags as a CSV file
- **Edit**: Modify the downloaded CSV in any editor, updating the tags column as needed
- **Upload**: Reimport the edited CSV file to update tags
- **Validate**: Only `resourceName` and `tags` columns are validated during upload

### Sync Tags to Profile

After finalizing resource tags:

1. Click **Sync Profile** to synchronize updated tags back to the associated device profile
2. This ensures resource definitions and applied tags remain consistent in core-metadata
3. Applied tags become visible in the device profile's details page

**Note**: The sync operation applies only to resources with non-empty **Tag** field values.
