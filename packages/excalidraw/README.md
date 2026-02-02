# Excalidraw Diagram Skill

A Claude Code skill for generating professional Excalidraw diagrams, specialized in IT architecture diagrams, flowcharts, system designs, and more.

---

## Features

### Professional Visual Design
- **Hand-drawn Style**: Preserves Excalidraw's signature hand-drawn aesthetic
- **Color Palettes**: Multiple pre-defined professional color schemes (dark-tech, cloud-blue, corporate, etc.)
- **Visual Hierarchy**: Follows the 60-30-10 color ratio principle

### 27 Pre-loaded Component Libraries
- **Cloud Platforms**: AWS, Azure, GCP, Google icons
- **System Architecture**: Software architecture, system design, C4 model
- **Databases**: Database icons, data platform, data visualization
- **Flowcharts**: Flow chart symbols, BPMN, UML/ER diagrams
- **DevOps**: CI/CD icons, Kubernetes, network topology

### Smart Agent Delegation
- Automatically delegates sub-agents for verbose JSON operations
- Prevents main conversation context exhaustion
- Returns concise text summaries

### Complete JSON Specification
- Each element requires 20+ mandatory properties
- `seed` and `versionNonce` must be random positive integers
- See [JSON-SCHEMA.md](JSON-SCHEMA.md) for details

---

## Example Showcase

The following 5 examples demonstrate the unique capabilities of this skill. Open files at [excalidraw.com](https://excalidraw.com).

---

### Example 1: AWS Serverless Architecture

**File**: `examples/en/aws-serverless.excalidraw`

**Highlights**:
- AWS official colors: Lambda orange, DynamoDB blue, S3 green
- Cloud architecture layout: Users → CDN → API → Lambda → DB
- Hand-drawn style: Professional yet approachable

![AWS Serverless Architecture](../screenshots/en/aws-serverless.png)

---

### Example 2: Microservices on Kubernetes

**File**: `examples/en/microservices-k8s.excalidraw`

**Highlights**:
- DevOps dark theme: Purple accent + dark background
- Kubernetes official blue: #326CE5
- Sync/Async communication: Solid vs dashed arrows
- Service Mesh indication: Istio sidecar indicators

![Microservices on Kubernetes](../screenshots/en/microservices-k8s.png)

---

### Example 3: CI/CD Pipeline Flowchart

**File**: `examples/en/cicd-pipeline.excalidraw`

**Highlights**:
- Flowchart symbols: Rectangle processes, diamond decisions
- Success/Failure paths: Green vs red arrows
- Stage grouping: Build → Test → Deploy
- Manual approval gate: Manual Approval Gate indicator

![CI/CD Pipeline](../screenshots/en/cicd-pipeline.png)

---

### Example 4: E-Commerce ER Diagram

**File**: `examples/en/ecommerce-erd.excalidraw`

**Highlights**:
- ER diagram standard symbols: PK/FK labels, cardinality markers
- Crow's Foot notation: 1:N, 1:1 relationships
- Data-flow theme colors: Cyan palette
- Self-referencing relationship: Category parent-child

![E-Commerce ER Diagram](../screenshots/en/ecommerce-erd.png)

---

### Example 5: Enterprise Network Topology

**File**: `examples/en/network-topology.excalidraw`

**Highlights**:
- Cybersecurity dark theme: Matrix green + dark background
- Network zone layering: Internet → DMZ → Internal → Management
- VLAN color coding: Engineering/Sales/HR each with unique colors
- Network device icons: Firewall, router, switch

![Enterprise Network Topology](../screenshots/en/network-topology.png)

---

## Skill Summary

| Feature | Description |
|---------|-------------|
| **27 Pre-loaded Libraries** | AWS, Azure, GCP, Kubernetes, DevOps, UML, etc. |
| **Hand-drawn Style** | Preserves Excalidraw's signature aesthetic |
| **Professional Colors** | IT-optimized color palettes |
| **JSON Specification** | Complete property support for compatibility |
| **Smart Delegation** | Sub-agent handles complex JSON operations |
| **Multiple Diagram Types** | Architecture, flowchart, ER, topology diagrams |

---

## How to Use

### Basic Prompt Format

```
Create a [diagram type] that includes:
- [Component 1]
- [Component 2]
- ...
Use [style/color] theme
```

### Prompt Examples

| Diagram Type | Example Prompt |
|-------------|----------------|
| AWS Architecture | `Create AWS Serverless architecture: API Gateway → Lambda → DynamoDB` |
| K8s Microservices | `Design Kubernetes microservices architecture with Ingress, Pods, Service Mesh` |
| CI/CD Flow | `Draw GitLab CI/CD Pipeline with Build, Test, Deploy stages` |
| ER Diagram | `Draw e-commerce ER diagram: User, Order, Product, Payment entities` |
| Network Topology | `Draw enterprise network: Internet → DMZ → Internal Network` |

---

## Advanced Usage

### Custom Color Palette

```
Use the following custom colors:
- Primary: #FF6B6B (coral red)
- Secondary: #4ECDC4 (teal)
- Background: #2C3E50 (dark blue-gray)
- Accent: #F7DC6F (gold)
```

### Specify Visual Style

```
Use minimalist style:
- Thin lines (strokeWidth: 1)
- No hand-drawn effect (roughness: 0)
- Solid fill (fillStyle: solid)
```

### Mix Multiple Libraries

```
Combine the following libraries:
- AWS icons for cloud services
- Kubernetes icons for container orchestration
- DevOps icons for CI/CD pipelines
```

### Modify Existing Diagrams

```
Modify examples/my-diagram.excalidraw:
- Rename "Service A" to "User Service"
- Add a "Cache Layer" before the database
- Apply dark mode color scheme
```

---

## Library Quick Reference

| Diagram Type | Recommended Library |
|-------------|---------------------|
| AWS Architecture | `aws-architecture-icons` |
| Azure Architecture | `azure-cloud-services` |
| GCP Architecture | `gcp-icons`, `google-icons` |
| System Design | `software-architecture`, `system-design` |
| Microservices | `software-architecture`, `kubernetes-icons` |
| Database/ER | `database`, `uml-er-library` |
| Flowchart | `flow-chart-symbols` |
| Business Process | `bpmn` |
| Network Topology | `network-topology-icons` |
| CI/CD | `devops-icons`, `technology-logos` |
| Data Pipeline | `data-platform`, `database` |
| Wireframe | `basic-ux-wireframing`, `web-kit`, `mobile-kit` |

---

## Color Palette Quick Reference

### IT/Technical Styles

| Name | Primary | Background | Use Case |
|------|---------|------------|----------|
| `dark-tech` | #3B82F6 | #0F172A | System architecture, API |
| `cybersecurity` | #22C55E | #020617 | Security diagrams |
| `cloud-blue` | #0EA5E9 | #FFFFFF | Cloud architecture |
| `devops` | #8B5CF6 | #0F0A29 | CI/CD pipelines |
| `data-flow` | #06B6D4 | #042F2E | ETL, data architecture |

### Professional Business Styles

| Name | Primary | Background | Use Case |
|------|---------|------------|----------|
| `corporate` | #1E40AF | #FFFFFF | Business presentations |
| `minimal` | #18181B | #FAFAFA | Documentation |
| `dark-mode` | #E2E8F0 | #0F172A | Dark mode |

---

## File Structure

```
~/.claude/skills/excalidraw/
├── README.md              # This file (English)
├── SKILL.md               # Skill entry point
├── JSON-SCHEMA.md         # JSON format specification (required reading)
├── ELEMENTS.md            # Element type reference
├── PALETTES.md            # Color palette definitions
├── STYLES.md              # Visual style guide
├── IT-DIAGRAMS.md         # IT diagram templates
├── TEMPLATES.md           # General templates
├── LIBRARIES.md           # Component library reference
├── ICONS.md               # Custom icon patterns
├── examples/
│   ├── en/                # English examples
│   │   ├── aws-serverless.excalidraw
│   │   ├── microservices-k8s.excalidraw
│   │   ├── cicd-pipeline.excalidraw
│   │   ├── ecommerce-erd.excalidraw
│   │   └── network-topology.excalidraw
│   └── zh-TW/             # Chinese examples
│       └── ...
└── libraries/             # 27 pre-loaded component libraries
    ├── aws-architecture-icons.excalidrawlib
    ├── software-architecture.excalidrawlib
    ├── kubernetes-icons.excalidrawlib
    └── ...
```

---

## FAQ

### Q: How do I open generated .excalidraw files?

**A**: Several options:
1. Go to [excalidraw.com](https://excalidraw.com), click menu (top-left) → Open → Select file
2. Install the Excalidraw extension in VS Code
3. Use the Excalidraw plugin in Obsidian

### Q: Can I export to other formats?

**A**: After opening in Excalidraw, you can export to:
- PNG (transparent or white background)
- SVG (vector graphics)
- Copy to clipboard

### Q: What if the libraries aren't enough?

**A**: In order of priority:
1. Use pre-loaded libraries in the `libraries/` folder
2. Search and download from [libraries.excalidraw.com](https://libraries.excalidraw.com)
3. Compose using basic shapes

### Q: How do I modify an existing diagram?

**A**: Just tell Claude what to change:
```
Modify examples/my-diagram.excalidraw:
- Rename "Service A" to "User Service"
- Add a "Cache Layer" before the database
- Apply dark mode color scheme
```

---

## License

This skill is open source. Feel free to use and modify.

Component libraries source: [libraries.excalidraw.com](https://libraries.excalidraw.com)
