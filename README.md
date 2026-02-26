# Cisco Foundation-Sec 8B on NVIDIA GPU (Bilingual Security Assistant)

[![English](https://img.shields.io/badge/English-blue?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md)

**Maintained by [Willis Chen](mailto:misweyu2007@gmail.com)**

This project is a bilingual (Chinese/English) security analysis smart assistant leveraging the power of **NVIDIA GPUs**. By integrating [Chainlit](https://docs.chainlit.io/) to provide a modern interactive interface, and combining multiple Large Language Models (LLMs) with the Qdrant vector database via a fully containerized Docker architecture, it achieves professional security log analysis and RAG (Retrieval-Augmented Generation) applications.

## Built With

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

## Core Project Components

1. **Frontend Interface**: Uses Chainlit (`cisco_security_chainlit.py`) to build a conversational AI interface, supporting real-time text streaming and chat history.
2. **Multi-language Support**: Handles intent classification, multi-language understanding, and translation through **Llama-3-Taiwan-8B-Instruct**.
3. **Security Expert**: Performs in-depth system and security log analysis through **Foundation-Sec-8B**, fine-tuned specifically for the cybersecurity domain.
4. **Hardware Acceleration**: Integrates NVIDIA CUDA (`cuBLAS`) with `llama-cpp-python` within Docker to maximize inference performance on NVIDIA graphics cards.
5. **Vector Retrieval (RAG)**: Uses **Qdrant** (deployed via Docker Compose) to store and retrieve internal enterprise security documents, thereby enhancing the language model's analysis accuracy and reducing hallucinations.

## System Requirements

- **Operating System**: Linux/Ubuntu highly recommended.
- **Hardware**: NVIDIA GPU with sufficient VRAM. The two Q4_K_M 8B models together require approximately **4–5 GB VRAM** under the default layer configuration. A GPU with at least **6 GB VRAM** (e.g., RTX 2060) is the minimum; 8 GB or more is recommended for headroom.
- **GPU Layer Configuration** — Adjust the number of GPU-offloaded layers to match your own GPU spec via environment variables in `docker-compose.yml`:

  **Parameter Reference** (each model has 32 layers; each layer ≈ 140 MB of VRAM):
  | Environment Variable | Role | Value Meaning |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | Intent classification + Translation | Number of layers on GPU (max 32) |
  | `N_GPU_LAYERS_SEC` | Security log deep analysis | Number of layers on GPU (max 32) |

  **Recommended values by GPU VRAM size**:
  | GPU VRAM | Example GPUs | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | Est. VRAM Used |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `10` | `20` | ~4.2 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `15` | `25` | ~5.6 GB |
  | 10 GB | RTX 3080 | `20` | `30` | ~7.0 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `24` | `32` | ~7.8 GB |
  | 16 GB+ | RTX 4080, A4000 | `32` | `32` | ~9.0 GB (full GPU) |

  > ⚠️ Setting values too high (beyond your VRAM capacity) will cause **CUDA Out-Of-Memory (OOM)**.
  > Quick formula: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **Prerequisites**:
  - [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
  - [NVIDIA Driver](https://www.nvidia.com/Download/index.aspx) installed on the host.
  - [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed (to enable GPU passthrough to Docker).
  - Internet connection (required for downloading models and container images on first launch).

## Project Architecture

Unlike the macOS version, this NVIDIA project uses a fully containerized architecture without needing a local virtual environment:

```text
.
├── docker-compose.yml          # Main Docker orchestration file (Chainlit + Qdrant)
├── Dockerfile                  # Builds the CUDA-enabled Python environment
├── models/                     # GGUF model storage (downloaded automatically)
├── qdrant_storage/             # Persistent storage directory for Qdrant vector database
├── cisco_security_chainlit.py  # Main Chainlit application file
├── download_models.sh          # Auto-downloads required HuggingFace GGUF models
└── (Other Python scripts and configuration files)
```

## How to Run

1. **Open Terminal**, and navigate to this project directory:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **Start Services via Docker Compose**:
   The `docker-compose.yml` file defines everything needed. It will build the image, install CUDA dependencies, download models via `download_models.sh`, and start both the `qdrant` and `security-app` (Chainlit) containers.
   ```bash
   docker compose up -d --build
   ```
   *Note: Building the image and downloading the models for the first time will take several minutes. You can check the progress by omitting the `-d` flag or by checking the logs with `docker compose logs -f`.*

3. **Start Chatting**:
   Once the `security-app-gpu` container is fully running, the Chainlit web UI will be available. Open your browser and navigate to:
   ```
   http://localhost:8000
   ```

## Troubleshooting

- **GPU not detected / Container fails to start**: Ensure the NVIDIA Container Toolkit is installed and configured correctly on the host. The container uses `deploy.resources.reservations.devices` with the `nvidia` driver and `NVIDIA_VISIBLE_DEVICES=all`.
- **Out of memory (OOM) / Frequent crashes**: Each Q4_K_M 8B model has **32 transformer layers**, each consuming ~140 MB of VRAM. The default split (`N_GPU_LAYERS_LLAMA3=10`, `N_GPU_LAYERS_SEC=20`) uses ~4.2 GB total. To reduce pressure, edit these values in `docker-compose.yml`:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=10   # Reduce to 5 if OOM persists
    - N_GPU_LAYERS_SEC=20      # Reduce to 15 if OOM persists
  ```
- **Models failed to download**: If network issues occur during the build process, you can manually execute `./download_models.sh` or restart the build process.

## Development and Advanced Features

- **RAG Text Ingestion**: To import new base security documents into the Qdrant knowledge base, you can execute the ingestion script inside the container:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **Automated Log Translation/Processing**: `translate_logs.py` provides a template for batch processing logs or performing cross-language conversion tests. You can run it inside the container similar to the command above.

---

**Maintained by [Willis Chen](mailto:misweyu2007@gmail.com)**
