# 使用 NVIDIA 官方提供的 CUDA 開發版映像檔作為基底
# 我們需要 devel 版本因為安裝 llama-cpp-python 時需要編譯 CUDA 相關的 C/C++ 程式碼
FROM nvidia/cuda:12.6.3-devel-ubuntu24.04

# 設定環境變數以防止 apt 安裝過程中出現互動式提示
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安裝 Python, pip, 以及必要的編譯工具 (包含 wget 與 curl 供網路下載使用)
# Ubuntu 24.04 預設即有較新穩定的 Python3，直接安裝 python3 即可
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python-is-python3 \
    python3-venv \
    git \
    wget \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# 建立並設定工作目錄
WORKDIR /app

# 將 requirements 檔案複製進容器
COPY requirements.txt .

# 這是針對 Ubuntu 24.04 / Python 3.12 引入的 PEP 668 規範
# 我們必須在虛擬環境中安裝 pip 套件以避免破壞系統套件
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 安裝 wheel 與編譯所需的基本 py 套件
RUN pip install --no-cache-dir --upgrade pip wheel setuptools

# 設定環境變數以啟用 llama-cpp-python 的 CUDA (cuBLAS) 支援
# 必須明確指出 nvcc 的編譯器路徑，否則在部分 24.04 環境下 wheel 會找不到 CUDA
ENV CMAKE_ARGS="-DLLAMA_CUBLAS=on -DCUDAToolkit_ROOT=/usr/local/cuda"
ENV FORCE_CMAKE=1
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

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
