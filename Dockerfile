# 使用 NVIDIA 官方提供的 CUDA 開發版映像檔作為基底
# 我們需要 devel 版本因為安裝 llama-cpp-python 時需要編譯 CUDA 相關的 C/C++ 程式碼
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

# 設定環境變數以防止 apt 安裝過程中出現互動式提示
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安裝 Python, pip, 以及必要的編譯工具 (包含 wget 與 curl 供網路下載使用)
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3-dev \
    git \
    wget \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 將 python3 設為預設的 python 指令
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# 建立並設定工作目錄
WORKDIR /app

# 將 requirements 檔案複製進容器
COPY requirements.txt .

# 設定環境變數以啟用 llama-cpp-python 的 CUDA (cuBLAS) 支援
ENV CMAKE_ARGS="-DLLAMA_CUBLAS=on"
ENV FORCE_CMAKE=1

# 安裝 Python 依賴包
RUN pip install --no-cache-dir -r requirements.txt

# 複製模型下載腳本並給予執行權限
COPY download_models.sh .
RUN chmod +x download_models.sh

# 在建立 Image 的過程中預先下載模型 (這會花一些時間，但能確保啟動時不用等)
RUN ./download_models.sh

# 複製其餘的應用程式碼進容器
COPY . .

# 預設執行一個持續運行的程序，讓你之後可以 bash 進去測試
# 也可以改成 CMD ["python3", "translate_logs.py"] 或是其他你想直接啟動的服務
CMD ["tail", "-f", "/dev/null"]
