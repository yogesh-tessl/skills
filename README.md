# Skills

> **Note:** This repository contains custom skills for Claude Code. For information about the Agent Skills standard, see [agentskills.io](http://agentskills.io).

## What are Skills?

Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks. They teach Claude how to complete specific tasks in a repeatable way.

**Related Resources:**
- [What are skills?](https://support.claude.com/en/articles/12512176-what-are-skills)
- [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
- [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)

## About This Repository

This repository contains custom skills for document processing, visualization, and productivity tasks. Each skill is self-contained in its own folder with a `SKILL.md` file containing instructions and metadata.

## Available Skills

### document-to-markdown

Convert documents and URLs to clean Markdown for LLM/RAG use.

**Supported Formats:**
| Type | Formats |
|------|---------|
| Documents | PDF, DOCX, PPTX, XLSX |
| Images | PNG, JPG, JPEG, WEBP, TIFF (with OCR) |
| Web | HTML, URLs |
| Text | TXT, MD, CSV, JSON, XML |

**Key Features:**
- Multiple backends (pymupdf4llm for speed, marker for scanned docs)
- Batch processing with parallel execution
- RAG-optimized output format
- Structured JSON output for agent integration

### excalidraw

Create professional diagrams and visualizations using Excalidraw JSON format.

**Supported Diagram Types:**
| Category | Types |
|----------|-------|
| IT/Software | System Architecture, Microservices, API Flow, Network Topology, ER Diagram, CI/CD Pipeline |
| General | Flowchart, Mind Map, Org Chart, Timeline, Decision Tree |

**Key Features:**
- 27+ pre-downloaded component libraries (AWS, Azure, GCP, Kubernetes, etc.)
- Curated color palettes for IT/technical diagrams
- Multiple visual styles (hand-drawn, minimalist, blueprint, corporate)
- Subagent delegation pattern to prevent context exhaustion

**Example Showcase:**

The following 5 examples demonstrate the unique capabilities of this skill. Open files at [excalidraw.com](https://excalidraw.com).

#### 📦 Example 1: AWS Serverless Architecture

- ✅ **AWS official colors**: Lambda orange, DynamoDB blue, S3 green
- ✅ **Cloud architecture layout**: Users → CDN → API → Lambda → DB
- ✅ **Hand-drawn style**: Professional yet approachable

![AWS Serverless Architecture](screenshots/en/aws-serverless.png)

#### 🐳 Example 2: Microservices on Kubernetes

- ✅ **DevOps dark theme**: Purple accent + dark background
- ✅ **Kubernetes official blue**: #326CE5
- ✅ **Sync/Async communication**: Solid vs dashed arrows
- ✅ **Service Mesh indication**: Istio sidecar indicators

![Microservices on Kubernetes](screenshots/en/microservices-k8s.png)

#### 🔄 Example 3: CI/CD Pipeline Flowchart

- ✅ **Flowchart symbols**: Rectangle processes, diamond decisions
- ✅ **Success/Failure paths**: Green vs red arrows
- ✅ **Stage grouping**: Build → Test → Deploy
- ✅ **Manual approval gate**: Manual Approval Gate indicator

![CI/CD Pipeline](screenshots/en/cicd-pipeline.png)

#### 🗄️ Example 4: E-Commerce ER Diagram

- ✅ **ER diagram standard symbols**: PK/FK labels, cardinality markers
- ✅ **Crow's Foot notation**: 1:N, 1:1 relationships
- ✅ **Data-flow theme colors**: Cyan palette
- ✅ **Self-referencing relationship**: Category parent-child

![E-Commerce ER Diagram](screenshots/en/ecommerce-erd.png)

#### 🌐 Example 5: Enterprise Network Topology

- ✅ **Cybersecurity dark theme**: Matrix green + dark background
- ✅ **Network zone layering**: Internet → DMZ → Internal → Management
- ✅ **VLAN color coding**: Engineering/Sales/HR each with unique colors
- ✅ **Network device icons**: Firewall, router, switch

![Enterprise Network Topology](screenshots/en/network-topology.png)

**Usage Examples:**

| Diagram Type | Example Prompt |
|-------------|----------------|
| AWS Architecture | `Create AWS Serverless architecture: API Gateway → Lambda → DynamoDB` |
| K8s Microservices | `Design Kubernetes microservices architecture with Ingress, Pods, Service Mesh` |
| CI/CD Flow | `Draw GitLab CI/CD Pipeline with Build, Test, Deploy stages` |
| ER Diagram | `Draw e-commerce ER diagram: User, Order, Product, Payment entities` |
| Network Topology | `Draw enterprise network: Internet → DMZ → Internal Network` |

**Library Quick Reference:**

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

## Installation

### Using Skills CLI (Recommended)

```bash
# Install skills-cli first
pip install git+https://github.com/kcchien/skills-cli.git

# List available skills from this repo
skills-cli list --repo https://github.com/kcchien/skills

# Install skills
skills-cli install --repo https://github.com/kcchien/skills --skills document-to-markdown
skills-cli install --repo https://github.com/kcchien/skills --skills excalidraw
```

### Manual Installation

```bash
git clone https://github.com/kcchien/skills.git
cp -r skills/document-to-markdown ~/.claude/skills/
cp -r skills/excalidraw ~/.claude/skills/
```

That's it! Claude will automatically discover the skill and handle dependencies when needed.

## License

MIT License

---

# 中文說明

> **備註：** 本儲存庫包含 Claude Code 的自訂技能。關於 Agent Skills 標準，請參閱 [agentskills.io](http://agentskills.io)。

## 什麼是 Skills？

Skills 是包含指令、腳本和資源的資料夾，Claude 會動態載入以提升特定任務的表現。它們教導 Claude 如何以可重複的方式完成特定任務。

**相關資源：**
- [什麼是 Skills？](https://support.claude.com/en/articles/12512176-what-are-skills)
- [在 Claude 中使用 Skills](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
- [如何建立自訂 Skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)

## 關於本儲存庫

本儲存庫包含文件處理、視覺化和生產力任務的自訂技能。每個技能都獨立存放於各自的資料夾中，並包含 `SKILL.md` 檔案描述指令和中繼資料。

## 可用技能

### document-to-markdown

將文件和網址轉換為乾淨的 Markdown 格式，適用於 LLM/RAG。

**支援格式：**
| 類型 | 格式 |
|------|------|
| 文件 | PDF、DOCX、PPTX、XLSX |
| 圖片 | PNG、JPG、JPEG、WEBP、TIFF（支援 OCR） |
| 網頁 | HTML、URLs |
| 文字 | TXT、MD、CSV、JSON、XML |

**主要特色：**
- 多後端支援（pymupdf4llm 快速處理、marker 適合掃描文件）
- 批次處理支援平行執行
- RAG 最佳化輸出格式
- 結構化 JSON 輸出方便 Agent 整合

### excalidraw

使用 Excalidraw JSON 格式建立專業圖表和視覺化。

**支援圖表類型：**
| 類別 | 類型 |
|------|------|
| IT/軟體 | 系統架構、微服務、API 流程、網路拓撲、ER 圖、CI/CD 流程 |
| 通用 | 流程圖、心智圖、組織圖、時間軸、決策樹 |

**主要特色：**
- 27+ 預載元件庫（AWS、Azure、GCP、Kubernetes 等）
- 專為 IT/技術圖表設計的配色方案
- 多種視覺風格（手繪、極簡、藍圖、企業）
- 子代理委派模式避免上下文耗盡

**範例展示：**

以下 5 個範例展示此技能的獨特之處，可至 [excalidraw.com](https://excalidraw.com) 開啟檔案查看。

#### 📦 範例 1：AWS Serverless 架構圖

- ✅ **AWS 官方配色**：Lambda 橘、DynamoDB 藍、S3 綠
- ✅ **雲端架構佈局**：Users → CDN → API → Lambda → DB
- ✅ **手繪風格**：保持專業同時具備親和力

![AWS Serverless Architecture](screenshots/zh-TW/aws-serverless.png)

#### 🐳 範例 2：Microservices on Kubernetes

- ✅ **DevOps 深色主題**：紫色主調 + 深色背景
- ✅ **Kubernetes 官方藍**：#326CE5
- ✅ **同步/非同步通訊**：實線 vs 虛線箭頭
- ✅ **Service Mesh 標示**：Istio sidecar 指示器

![Microservices on Kubernetes](screenshots/zh-TW/microservices-k8s.png)

#### 🔄 範例 3：CI/CD Pipeline 流程圖

- ✅ **流程圖符號**：矩形處理、菱形決策
- ✅ **成功/失敗路徑**：綠色 vs 紅色箭頭
- ✅ **階段分組**：Build → Test → Deploy
- ✅ **人工審核閘門**：Manual Approval Gate

![CI/CD Pipeline](screenshots/zh-TW/cicd-pipeline.png)

#### 🗄️ 範例 4：E-Commerce ER 圖

- ✅ **ER 圖標準符號**：PK/FK 標示、基數標記
- ✅ **Crow's Foot 記法**：1:N、1:1 關聯
- ✅ **資料流主題配色**：Cyan 色系
- ✅ **自我參照關聯**：Category 父子關係

![E-Commerce ER Diagram](screenshots/zh-TW/ecommerce-erd.png)

#### 🌐 範例 5：企業網路拓撲圖

- ✅ **資安深色主題**：Matrix 綠 + 深色背景
- ✅ **網路區域分層**：Internet → DMZ → Internal → Management
- ✅ **VLAN 色彩區分**：Engineering/Sales/HR 各有專屬顏色
- ✅ **網路設備圖示**：防火牆、路由器、交換器

![Enterprise Network Topology](screenshots/zh-TW/network-topology.png)

**使用範例：**

| 圖表類型 | 提示詞範例 |
|---------|-----------|
| AWS 架構 | `建立 AWS Serverless 架構：API Gateway → Lambda → DynamoDB` |
| K8s 微服務 | `設計 Kubernetes 微服務架構，包含 Ingress、Pod、Service Mesh` |
| CI/CD 流程 | `畫 GitLab CI/CD Pipeline，包含 Build、Test、Deploy 階段` |
| ER 圖 | `畫電商系統 ER 圖：User、Order、Product、Payment 實體` |
| 網路拓撲 | `畫企業網路架構：Internet → DMZ → Internal Network` |

**元件庫快速參考：**

| 圖表類型 | 推薦元件庫 |
|---------|-----------|
| AWS 架構 | `aws-architecture-icons` |
| Azure 架構 | `azure-cloud-services` |
| GCP 架構 | `gcp-icons`, `google-icons` |
| 系統設計 | `software-architecture`, `system-design` |
| 微服務 | `software-architecture`, `kubernetes-icons` |
| 資料庫/ER 圖 | `database`, `uml-er-library` |
| 流程圖 | `flow-chart-symbols` |
| 業務流程 | `bpmn` |
| 網路拓撲 | `network-topology-icons` |
| CI/CD | `devops-icons`, `technology-logos` |

## 安裝方式

### 使用 Skills CLI（推薦）

```bash
# 先安裝 skills-cli
pip install git+https://github.com/kcchien/skills-cli.git

# 列出此 repo 的可用技能
skills-cli list --repo https://github.com/kcchien/skills

# 安裝技能
skills-cli install --repo https://github.com/kcchien/skills --skills document-to-markdown
skills-cli install --repo https://github.com/kcchien/skills --skills excalidraw
```

### 手動安裝

```bash
git clone https://github.com/kcchien/skills.git
cp -r skills/document-to-markdown ~/.claude/skills/
cp -r skills/excalidraw ~/.claude/skills/
```

完成！Claude 會自動探索此技能，並在需要時處理相依套件。

## 授權

MIT License
