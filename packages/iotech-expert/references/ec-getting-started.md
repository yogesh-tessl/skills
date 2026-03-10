<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-central40/installation/overview.html
    - https://docs.iotechsys.com/edge-central40/installation/prerequisites/docker-installation.html
    - https://docs.iotechsys.com/edge-central40/installation/prerequisites/podman-installation.html
    - https://docs.iotechsys.com/edge-central40/installation/installation.html
    - https://docs.iotechsys.com/edge-central40/installation/upgrade.html
    - https://docs.iotechsys.com/edge-central40/installation/licensing.html
  Synced: 2026-03-07
-->

# Installation and Licensing Overview

## 目錄

- [Architecture Support](#architecture-support)
- [Container Management Requirements](#container-management-requirements)
- [Prerequisites](#prerequisites)
  - [Required Versions](#required-versions)
  - [Installation Method](#installation-method)
  - [Important Notes](#important-notes)
- [Optional: Rootless Mode](#optional-rootless-mode)
- [Environment](#environment)
- [Prerequisites](#prerequisites)
  - [Podman Installation](#podman-installation)
  - [Docker Compose](#docker-compose)
  - [Podman API Configuration](#podman-api-configuration)
  - [Container Registry Setup](#container-registry-setup)
  - [Docker Hub Authentication](#docker-hub-authentication)
  - [User Namespace Configuration](#user-namespace-configuration)
- [Caution](#caution)
- [Download Edge Central](#download-edge-central)
- [Install Edge Central](#install-edge-central)
  - [Debian Package Installation](#debian-package-installation)
  - [RPM Package Installation](#rpm-package-installation)
- [Verify Installation](#verify-installation)
- [License Installation](#license-installation)
  - [Security Requirement for Deployment Licenses](#security-requirement-for-deployment-licenses)
- [Uninstall Edge Central](#uninstall-edge-central)
  - [Debian Package](#debian-package)
  - [RPM Package](#rpm-package)
- [Overview](#overview)
- [Upgrade Edge Central Installation](#upgrade-edge-central-installation)
- [Upgrade Container Images](#upgrade-container-images)
- [Remove Container Images](#remove-container-images)
- [Overview](#overview)
- [License Management Commands](#license-management-commands)
- [Obtaining Licenses](#obtaining-licenses)
- [File Permissions Requirements](#file-permissions-requirements)
- [Installation Procedure](#installation-procedure)
- [Validation Process](#validation-process)
- [Viewing Installed Licenses](#viewing-installed-licenses)
- [License Removal](#license-removal)
- [Complete Volume Deletion](#complete-volume-deletion)


## Architecture Support

Edge Central is compatible with ARM (32 and 64-bit) and x86 (64-bit) architectures on Linux-based systems. The platform is distributed in two package formats:

- **Debian (DEB)** packages for Debian-based systems like Ubuntu
- **RPM packages** for Red Hat, CentOS, and similar distributions

## Container Management Requirements

The system deploys microservices as containers managed through either Docker or Podman. Prior to installation, one container management tool must be selected and configured.

---

# Docker Installation

## Prerequisites

Edge Central requires specific Docker and Docker Compose versions to ensure compatibility and avoid potential issues.

### Required Versions

- Docker version `27.3.1` or later
- Docker Compose version `2.24.7` or later

Both components are included when installing Docker Desktop or Docker Server.

### Installation Method

The documentation emphasizes using the official Docker installation guides rather than operating system package managers. A provided installation script automates the setup process:

1. Download and extract the installation script from the provided source
2. Execute `./install_docker.sh`
3. Verify successful installation — the script confirms completion with version information
4. Reboot the system to apply Docker permission configurations

### Important Notes

**Version Compatibility Warning:** Installing Docker through snap or similar package managers may result in unsupported versions that cause compatibility problems with Edge Central.

**Command Deprecation:** The `docker-compose` command is deprecated in favor of `docker compose` (V2). While Edge Central supports both for backward compatibility, only the newer syntax will be maintained in future releases.

**Architecture Limitation:** The provided installation script does not support ARM 32-bit architecture; users on this platform should reference Docker's official documentation for alternative methods.

## Optional: Rootless Mode

Users can enable Docker's rootless mode to enhance security by restricting daemon privileges. The Edge Central CLI automatically detects this configuration and deploys services accordingly.

---

# Podman Installation

## Environment

This guide covers Podman installation for **Red Hat Enterprise Linux 9 (RHEL)**.

## Prerequisites

### Podman Installation

Install the required Podman packages:

```bash
sudo yum install -y podman-4.2.0-11.el9_1.x86_64
sudo yum install -y podman-remote-4.2.0-11.el9_1.x86_64
sudo yum install -y podman-plugins
```

The `dnsname plugin` (included in `podman-plugins`) enables containers to communicate using hostnames.

### Docker Compose

Install Docker Compose v2.24.7 or later:

```bash
sudo curl -SL https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**Note:** Version 2.24.7 or higher prevents Docker Compose pull issues. Earlier versions may trigger errors.

### Podman API Configuration

Activate the Podman API socket:

```bash
systemctl --user enable --now podman.socket
```

### Container Registry Setup

Update `/etc/containers/registries.conf` to specify Docker Hub:

```
unqualified-search-registries = ["docker.io"]
```

### Docker Hub Authentication

Log in to access Edge Central images:

```bash
podman login --authfile ~/.docker/config.json docker.io
```

### User Namespace Configuration

Verify UID/GID settings for rootless operation:

```bash
grep <current_username> /etc/subuid /etc/subgid
```

Expected output:
```
/etc/subuid:<current_username>:100000:65536
/etc/subgid:<current_username>:100000:65536
```

If no output appears, enable user namespaces following the Podman rootless tutorial.

## Caution

**Critical Limitation:** Podman operates in a rootless environment by default. Running Edge Central commands with `sudo` or as root will fail with this error:

```
ERROR: unrecognized command `podman-remote compose`
podman-remote: exit status 125
```

Do not attempt commands like `sudo edgecentral license install <license>` when using Podman.

---

# Edge Central Installation

## Download Edge Central

**For Customers with Support Contracts:**
Active Edge Central support customers can download installation packages from the IOTech Support Portal. Log in and navigate to Downloads to select your version and package type.

**For Evaluators:**
Those evaluating Edge Central can obtain packages from the IOTech website, which provides the most recent version for evaluation purposes only.

**Licensing Requirement:**
A valid license file defining available microservices must accompany your installation.

## Install Edge Central

### Debian Package Installation
```bash
sudo dpkg -i edgecentral-<version_number>_amd64.deb
```

### RPM Package Installation
```bash
sudo rpm -ivh edgecentral-<version_number>.x86_64.rpm
```

**Critical Prerequisite:**
Docker or Podman must be running before installation. If not running, the package installation will fail with an error indicating the Docker daemon is unreachable.

## Verify Installation

```bash
edgecentral -v
```

## License Installation

After successful installation verification, install your license:

```bash
edgecentral license install <your Edge Central license>
```

### Security Requirement for Deployment Licenses

Deployment licenses require overriding the default admin password before starting the Security Proxy Auth service. Production environments cannot use default credentials.

**Configuration Example:**
Use Docker Compose override to set a new password:

```yaml
services:
  proxy-auth:
    environment:
      EDGECENTRAL_DEFAULTADMINPASSWORD: <your_new_pwd>
```

This password applies to Edge Central UI and API Gateway access.

## Uninstall Edge Central

### Debian Package
```bash
sudo apt remove edgecentral
```

### RPM Package
```bash
sudo rpm -evh edgecentral
```

---

# Upgrading Edge Central

## Overview

This section outlines the process for upgrading Edge Central to a newer version, including installation updates and container image management.

## Upgrade Edge Central Installation

The upgrade process involves three primary steps:

1. **Download Latest Version**: Obtain the newest Edge Central version following the standard download procedures outlined in the installation documentation.
2. **Remove Existing Installation**: Uninstall the current Edge Central deployment using the removal process detailed in the installation guide.
3. **Install and Verify**: Deploy the latest version and perform verification checks to ensure successful installation.

## Upgrade Container Images

Even after installing a new Edge Central release, you must ensure fresh container images are in use:

**Pull Latest Images:**
```bash
edgecentral pull --all
```

**Deploy Updated Containers:**
```bash
edgecentral up {{ services }}
```

**Verify Image Versions:**
```bash
edgecentral image version
```

This command displays current versions of deployed images, such as core services and dependencies (mosquitto, redis, etc.).

## Remove Container Images

**Stop and Delete Containers:**
```bash
edgecentral rm
```

**Verify Removal:**
```bash
edgecentral status
```

**Delete Old Images:**

For Docker:
```bash
docker image rm $(docker images | grep edgecentral)
```

For Podman:
```bash
podman image rm $(podman images | grep edgecentral)
```

**Note**: Third-party software (nodered, influxdb, grafana, portainer, timescaledb, kuiper, eclipse-mosquitto) must be manually removed based on your deployment configuration.

---

# Licensing

## Overview

Before operating Edge Central, you must install and validate a license. The system validates the license each time an Edge Central service starts.

License management uses a Docker volume to store license files, accessed via command-line tools.

## License Management Commands

The `edgecentral license [<option>]` command provides these functions:

| Command | Purpose |
|---------|---------|
| `install` | Add licenses to the volume |
| `uninstall` | Remove a specific license |
| `view` | Display all installed licenses |
| `check` | Validate installed licenses |
| `clean` | Remove the license volume entirely |

## Obtaining Licenses

**Active Customers**: Download from the IOTech Support Portal by logging in and navigating to "My License Keys."

**Evaluators**: Request an evaluation license by completing the downloads form on the IOTech website.

## File Permissions Requirements

The license file requires read access for the "Other" user permission set. Verify permissions with:

```bash
ls -l <path>/<license file>
```

If the third character group lacks 'r', grant read access:

```bash
chmod +r <path>/<license file>
```

Without proper permissions, Edge Central services cannot access the license file.

## Installation Procedure

1. Open a terminal
2. Execute: `edgecentral license install <path>/<license file>`
3. Confirm successful installation with the output message

## Validation Process

1. Open a terminal
2. Run: `edgecentral license check`
3. Successful validation displays: "Signature valid" and "License valid"

## Viewing Installed Licenses

Execute: `edgecentral license view`

This lists all currently installed licenses in the volume.

## License Removal

Execute: `edgecentral license uninstall <license file>`

Successful removal returns a confirmation message.

## Complete Volume Deletion

Execute: `edgecentral license clean`

When prompted, enter `y` to confirm deletion of the license-data volume and clear all licenses.
