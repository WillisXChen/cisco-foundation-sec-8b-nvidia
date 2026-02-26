# Cisco Foundation-Sec 8B Native on NVIDIA GPU (雙語資安助手)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-blue?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md)

**維護者：[Willis Chen](mailto:misweyu2007@gmail.com)**

本專案是一個部署在 **NVIDIA GPU** 上的中英雙語資安分析智能助手。透過整合 [Chainlit](https://docs.chainlit.io/) 提供現代化的互動介面，並在全容器化的 Docker 架構下結合多個大型語言模型 (LLMs) 與 Qdrant 向量資料庫，實現了專業的資安日誌分析與 RAG (檢索增強生成) 應用。

## 開發與運行環境

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

## 專案核心組件

1. **前端介面**：使用 Chainlit (`cisco_security_chainlit.py`) 打造對話式 AI 介面，支援即時文字串流與歷史對話記錄。
2. **多語言支援**：透過 **Llama-3-Taiwan-8B-Instruct** 處理意圖分類、多語言理解與翻譯。
3. **資安專家模型**：透過專為網路安全領域微調的 **Foundation-Sec-8B**，進行深度的系統與資安日誌分析。
4. **硬體加速**：在 Docker 內整合 NVIDIA CUDA (`cuBLAS`) 與 `llama-cpp-python`，最大化 NVIDIA 顯示卡的推論效能。
5. **向量檢索 (RAG)**：使用 **Qdrant** (透過 Docker Compose 部署) 儲存並檢索企業內部安全文件，藉此提升語言模型的分析精準度並減少幻覺 (Hallucinations) 的發生。

## 系統需求

- **作業系統**：強烈建議使用 Linux/Ubuntu。
- **硬體效能**：具備足夠 VRAM 的 NVIDIA GPU。兩個 Q4_K_M 8B 模型在預設的 GPU 層數設定下，合計約需要 **4–5 GB VRAM**。最低需求為 **6 GB VRAM**（例如 RTX 2060）；建議 8 GB 以上以保留餘裕。
- **GPU 層數設定** — 可依據自己的 GPU 設備規格，在 `docker-compose.yml` 環境變數中自行調整 GPU 層數：

  **參數說明**（兩個模型各有 32 層，每層約 140 MB）：
  | 環境變數 | 用途 | 數值含義 |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | 意圖分類 + 結果翻譯 | 設為 GPU 上的層數（最大 32）|
  | `N_GPU_LAYERS_SEC` | 資安日誌深度分析 | 設為 GPU 上的層數（最大 32）|

  **依據 GPU VRAM 大小的推薦設定值**：
  | GPU VRAM | 代表型號 | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | 預估 VRAM 經消 |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB（全 GPU）|

  > ⚠️ 數值設定過高（超出 VRAM 容量）將導致 **CUDA Out-Of-Memory (OOM)**。
  > 動式公式：`(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **前置作業**：
  - [Docker](https://docs.docker.com/get-docker/) 與 [Docker Compose](https://docs.docker.com/compose/install/)
  - 主機已安裝 [NVIDIA Driver](https://www.nvidia.com/Download/index.aspx)
  - 已安裝 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (使 Docker 容器能存取硬體 GPU)
  - 網際網路連線 (初次啟動需下載模型與容器映像檔)

## 專案架構

不同於 macOS 版本，本 NVIDIA 專案採用全容器化架構，無需建立本機虛擬環境：

```text
.
├── docker-compose.yml          # 主要的 Docker 編排檔 (包含 Chainlit 與 Qdrant)
├── Dockerfile                  # 用於構建支援 CUDA 的 Python 環境
├── models/                     # GGUF 模型儲存路徑 (自動下載)
├── qdrant_storage/             # Qdrant 向量資料庫的持久化儲存目錄
├── cisco_security_chainlit.py  # Chainlit 應用程式主檔案
├── download_models.sh          # 自動下載所需的 HuggingFace GGUF 模型
└── (其他 Python 腳本與設定檔)
```

## 執行方式

1. **開啟終端機**，並導航至本專案目錄：
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **透過 Docker Compose 啟動服務**：
   `docker-compose.yml` 定義了所有需要的服務。它會自動構建映像檔、設定 CUDA 環境、透過 `download_models.sh` 載入模型，並啟動 `qdrant` 與 `security-app` (Chainlit) 容器。
   ```bash
   docker compose up -d --build
   ```
   *註：初次建立映像檔與下載模型會需要幾分鐘時間。您可以移除 `-d` 參數或是透過 `docker compose logs -f` 來查看即時日誌。*

3. **開始對話**：
   當 `security-app-gpu` 容器啟動完成後，Chainlit Web UI 即會上線。請打開瀏覽器並前往：
   ```
   http://localhost:8000
   ```

## 常見問題與排除

- **找不到 GPU / 容器無法啟動**：請確認主機上已正確安裝 NVIDIA Container Toolkit。容器會在 `docker-compose.yml` 中透過 `deploy.resources` 的 `nvidia` 驅動以及環境變數 `NVIDIA_VISIBLE_DEVICES=all` 來取用 GPU。
- **記憶體不足 (OOM) / 頻繁崩潰**：每個 Q4_K_M 8B 模型共有 **32 個 transformer 層**，每層約 140 MB VRAM。預設配置（`N_GPU_LAYERS_LLAMA3=5`、`N_GPU_LAYERS_SEC=15`）合計約 2.8 GB。若仍 OOM，請修改 `docker-compose.yml` 中的數值：
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # 若仍 OOM 可降至 3
    - N_GPU_LAYERS_SEC=15      # 若仍 OOM 可降至 10
  ```
- **模型下載失敗**：如果在構建過程中遇到網路問題，可隨時重新執行構建流程，或手動執行 `./download_models.sh`。

## 開發與進階功能

- **RAG 文件匯入**：若要將新的基礎資安文件匯入至 Qdrant 知識庫中，您可以在容器內部執行資料處理腳本：
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **日誌自動翻譯/處理**：`translate_logs.py` 提供了一個批次處理日誌或執行跨語言轉換測試的範本，也可比照上述指令於容器內執行。

## 存取控制 — Nginx htpasswd 帳號管理

應用程式透過 Nginx HTTP Basic Authentication 進行保護。使用 `add_user.sh` 管理帳號，每次操作後 nginx 會自動 reload，**不會中斷現有連線**。

> **首次使用** — 只需賦予執行權限一次：
> ```bash
> chmod +x add_user.sh
> ```

### 新增 / 更新帳號

```bash
# 互動式輸入密碼（推薦，密碼不會留在 shell 歷史紀錄）
./add_user.sh add admin

# 直接帶入密碼
./add_user.sh add alice secret123
```

### 刪除帳號

```bash
./add_user.sh del alice
```

### 列出所有帳號

```bash
./add_user.sh list
```

---

**維護者：[Willis Chen](mailto:misweyu2007@gmail.com)**
