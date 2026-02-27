# Maintainer: Willis Chen <misweyu2007@gmail.com>
# Use NVIDIA's official CUDA devel image as base
# We need the devel version because llama-cpp-python requires compiling related C/C++ code for CUDA
FROM nvidia/cuda:12.6.3-devel-ubuntu24.04

# Switch to root user to execute subsequent commands (ensures sufficient permissions)
USER root

# Set environment variables to prevent interactive prompts during apt installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install Python, pip, and essential build tools (including wget and curl for network downloads)
# Ubuntu 24.04 comes with a relatively new and stable Python3 by default, so installing python3 is sufficient
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


# Create and set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# This is for PEP 668 compliance introduced in Ubuntu 24.04 / Python 3.12
# We must install pip packages within a virtual environment to avoid breaking system packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install wheel and basic py packages required for building
RUN pip install --no-cache-dir --upgrade pip wheel setuptools

# Set environment variables to enable CUDA support for llama-cpp-python
# Note: Newer versions of llama.cpp deprecated LLAMA_CUBLAS in favor of GGML_CUDA
# Path to nvcc compiler must be explicitly specified, otherwise wheel may fail to find CUDA in some 24.04 environments
ENV CMAKE_ARGS="-DGGML_CUDA=on -DCUDAToolkit_ROOT=/usr/local/cuda"
ENV FORCE_CMAKE=1
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy model downloading script and grant execution permissions
COPY download_models.sh .
RUN chmod +x download_models.sh

# Pre-download models during Image build (takes time, but saves waiting upon startup)
# Execute explicitly using bash (script shebang is #!/bin/bash)
RUN bash download_models.sh

# Copy remaining application code into the container
COPY . .

# Run a persistent process by default, allowing you to bash inside for testing
# Can be changed to CMD ["python3", "translate_logs.py"] or another service you want to start directly
CMD ["tail", "-f", "/dev/null"]
