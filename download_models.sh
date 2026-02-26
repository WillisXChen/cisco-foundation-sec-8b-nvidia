#!/bin/bash
# Maintainer: Willis Chen <misweyu2007@gmail.com>
set -e

mkdir -p /app/models

echo "Checking and downloading Llama-3-Taiwan-8B-Instruct..."
if [ ! -f /app/models/llama-3-taiwan-8b-instruct-q4_k_m.gguf ]; then
  wget -q --show-progress \
    -O /app/models/llama-3-taiwan-8b-instruct-q4_k_m.gguf \
    https://huggingface.co/phate334/Llama-3-Taiwan-8B-Instruct-Q4_K_M-GGUF/resolve/main/llama-3-taiwan-8b-instruct-q4_k_m.gguf
  echo "Llama-3-Taiwan downloaded."
else
  echo "Llama-3-Taiwan already exists, skipping."
fi

echo "Checking and downloading Foundation-Sec-8B..."
FOUNDATION_MODEL="/app/models/foundation-sec-8b-q4_k_m.gguf"

# 如果存在但檔案過小（下載不完整），先刪除重新下載
if [ -f "$FOUNDATION_MODEL" ]; then
  FILESIZE=$(stat -c%s "$FOUNDATION_MODEL" 2>/dev/null || echo 0)
  if [ "$FILESIZE" -lt 1000000000 ]; then
    echo "Existing file is too small (likely incomplete). Re-downloading..."
    rm -f "$FOUNDATION_MODEL"
  fi
fi

if [ ! -f "$FOUNDATION_MODEL" ]; then
  wget -q --show-progress \
    -O "$FOUNDATION_MODEL" \
    https://huggingface.co/DevQuasar/fdtn-ai.Foundation-Sec-8B-GGUF/resolve/main/fdtn-ai.Foundation-Sec-8B.Q4_K_M.gguf
  echo "Foundation-Sec-8B downloaded."
else
  echo "Foundation-Sec-8B already exists and is valid, skipping."
fi

echo "All models downloaded successfully."
