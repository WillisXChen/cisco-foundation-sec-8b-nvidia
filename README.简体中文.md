# Cisco Foundation-Sec 8B on NVIDIA GPU (双语安全助手)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-blue?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-gray?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-gray?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-gray?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-gray?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-gray?style=for-the-badge)](README.TiengViet.md)

**维护者：[Willis Chen](mailto:misweyu2007@gmail.com)**

本项目是一个部署在 **NVIDIA GPU** 上的中英双语安全分析智能助手。通过整合 [Chainlit](https://docs.chainlit.io/) 提供现代化的交互界面，并在全容器化的 Docker 架构下结合多个大型语言模型 (LLMs) 与 Qdrant 向量数据库，实现了专业的安全日志分析与 RAG (检索增强生成) 应用。

## 开发与运行环境

<div align="center">
  <h3>
    <img src="https://img.shields.io/badge/NVIDIA-76B900?style=for-the-badge&logo=nvidia&logoColor=white" height="28" alt="NVIDIA GPU">
    <img src="https://img.shields.io/badge/CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white" height="28" alt="CUDA">
    <img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" height="28" alt="Ubuntu">
    <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" height="28" alt="Python">
    <img src="https://img.shields.io/badge/LLaMA_C++-FF7F50?style=for-the-badge&logo=meta&logoColor=white" height="28" alt="LLaMA C++">
    <img src="https://img.shields.io/badge/Chainlit-4A25E1?style=for-the-badge&logo=chainlit&logoColor=white" height="28" alt="Chainlit">
    <img src="https://img.shields.io/badge/Qdrant-1B053A?style=for-the-badge&logo=qdrant&logoColor=white" height="28" alt="Qdrant">
    <img src="https://img.shields.io/badge/FastEmbed-FF4B4B?style=for-the-badge&logo=python&logoColor=white" height="28" alt="FastEmbed">
    <br><br>
    <img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white" height="28" alt="Docker">
    <img src="https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" height="28" alt="Docker Compose">
    <img src="https://img.shields.io/badge/Hugging_Face-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black" height="28" alt="Hugging Face">
  </h3>
</div>

## 项目核心组件

1. **前端界面**：使用 Chainlit (`cisco_security_chainlit.py`) 打造对话式 AI 界面，支持实时文字流与历史对话记录。
2. **多语言支持**：通过 **Llama-3-Taiwan-8B-Instruct** 处理意图分类、多语言理解与翻译。
3. **安全专家模型**：通过专为网络安全领域微调的 **Foundation-Sec-8B**，进行深度的系统与安全日志分析。
4. **硬件加速**：在 Docker 内整合 NVIDIA CUDA (`cuBLAS`) 与 `llama-cpp-python`，最大化 NVIDIA 显卡的推理性能。
5. **向量检索 (RAG)**：使用 **Qdrant** (通过 Docker Compose 部署) 存储并检索企业内部安全文件，借此提升语言模型的分析精准度并减少幻觉 (Hallucinations) 的发生。
6. **优化用户体验**：包含定制化的品牌视觉 (Logo、深色/浅色主题)、本地化的欢迎界面，以及实时追踪模型生成的思考时间 ("Thought for X seconds") 与 Token 消耗状况。

## 系统需求

- **操作系统**：强烈建议使用 Linux/Ubuntu。
- **硬件性能**：具备足够 VRAM 的 NVIDIA GPU。两个 Q4_K_M 8B 模型在默认的 GPU 层数设定下，合计约需要 **4–5 GB VRAM**。最低需求为 **6 GB VRAM**（例如 RTX 2060）；建议 8 GB 以上以保留余裕。
- **GPU 层数设定** — 可依据自己的 GPU 设备规格，在 `docker-compose.yml` 环境变量中自行调整 GPU 层数：

  **参数说明**（两个模型各有 32 层，每层约 140 MB）：
  | 环境变量 | 用途 | 数值含义 |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | 意图分类 + 结果翻译 | 设为 GPU 上的层数（最大 32）|
  | `N_GPU_LAYERS_SEC` | 安全日志深度分析 | 设为 GPU 上的层数（最大 32）|

  **依据 GPU VRAM 大小的推荐设定值**：
  | GPU VRAM | 代表型号 | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | 预估 VRAM 消耗 |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ 数值设定过高（超出 VRAM 容量）将导致 **CUDA Out-Of-Memory (OOM)**。
  > 快速公式：`(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **前置作业**：
  - [Docker](https://docs.docker.com/get-docker/) 与 [Docker Compose](https://docs.docker.com/compose/install/)
  - 主机已安装 [NVIDIA Driver](https://www.nvidia.com/Download/index.aspx)
  - 已安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (使 Docker 容器能访问硬件 GPU)
  - 互联网连接 (初次启动需下载模型与容器镜像)

## 项目架构

不同于 macOS 版本，本项目采用全容器化架构，无需建立本地虚拟环境：

```text
.
├── docker-compose.yml          # 主要的 Docker 编排文件 (包含 Chainlit 与 Qdrant)
├── Dockerfile                  # 用于构建支持 CUDA 的 Python 环境
├── models/                     # GGUF 模型存储路径 (自动下载)
├── qdrant_storage/             # Qdrant 向量数据库的持久化存储目录
├── public/                     # 定制 UI 资源 (Logo、CSS、主题设置)
├── cisco_security_chainlit.py  # Chainlit 应用程序主文件
├── playbooks.json              # 统一管理的资安 SOP，供 RAG 写入读取使用
├── download_models.sh          # 自动下载所需的 HuggingFace GGUF 模型
└── htpasswd_user.sh            # Nginx 身份验证账号管理脚本
```

## 运行方式

1. **打开终端**，并导航至本项目目录：
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **通过 Docker Compose 启动服务**：
   `docker-compose.yml` 定义了所有需要的服务。它会自动构建镜像文件、设置 CUDA 环境、通过 `download_models.sh` 加载模型，并启动 `qdrant` 与 `security-app` (Chainlit) 容器。
   ```bash
   docker compose up -d --build
   ```
   *注：初次建立镜像文件与下载模型会需要几分钟时间。您可以移除 `-d` 参数或是通过 `docker compose logs -f` 来查看实时日志。*

3. **开始对话**：
   当 `security-app-gpu` 容器启动完成后，Chainlit Web UI 即会上线。请打开浏览器并前往：
   ```
   http://localhost:8000
   ```

## 常见问题与排除

- **找不到 GPU / 容器无法启动**：请确认主机上已正确安装 NVIDIA Container Toolkit。容器会在 `docker-compose.yml` 中通过 `deploy.resources` 的 `nvidia` 驱动以及环境变量 `NVIDIA_VISIBLE_DEVICES=all` 来取用 GPU。
- **内存不足 (OOM) / 频繁崩溃**：每个 Q4_K_M 8B 模型共有 **32 个 transformer 层**，每层约 140 MB VRAM。默认配置（`N_GPU_LAYERS_LLAMA3=5`、`N_GPU_LAYERS_SEC=15`）合计约 2.8 GB。若仍 OOM，请修改 `docker-compose.yml` 中的数值：
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # 若仍 OOM 可降至 3
    - N_GPU_LAYERS_SEC=15      # 若仍 OOM 可降至 10
  ```
- **模型下载失败**：如果在构建过程中遇到网络问题，可随时重新执行构建流程，或手动执行 `./download_models.sh`。

## 开发与进阶功能

- **RAG 文件导入**：基础的安全 SOP 统一记录在 `playbooks.json` 中。若要将这些文件导入至 Qdrant 知识库中，您可以在容器内部执行数据处理脚本：
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **日志自动翻译/处理**：`translate_logs.py` 提供了一个批次处理日志或执行跨语言转换测试的范本，也可比照上述指令在容器内执行。

## 访问控制 — Nginx htpasswd 账号管理

应用程序通过 Nginx HTTP Basic Authentication 进行保护。使用 `htpasswd_user.sh` 管理账号，每次操作后 nginx 会自动 reload，**不会中断现有连接**。

> **首次使用** — 只需赋予执行权限一次：
> ```bash
> chmod +x htpasswd_user.sh
> ```

### 新增 / 更新账号

```bash
# 交互式输入密码（推荐，密码不会留在 shell 历史记录）
./htpasswd_user.sh add admin

# 直接带入密码
./htpasswd_user.sh add alice secret123
```

### 删除账号

```bash
./htpasswd_user.sh del alice
```

### 列出所有账号

```bash
./htpasswd_user.sh list
```

---

**维护者：[Willis Chen](mailto:misweyu2007@gmail.com)**
