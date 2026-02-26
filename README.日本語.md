# Cisco Foundation-Sec 8B Native on NVIDIA GPU (バイリンガル・セキュリティ・アシスタント)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-blue?style=for-the-badge)](README.日本語.md)

**Maintained by [Willis Chen](mailto:misweyu2007@gmail.com)**

本プロジェクトは、**NVIDIA GPU** の強力なパフォーマンスを活用した、バイリンガル（中国語と英語を中心とする）セキュリティ分析のスマートアシスタントです。モダンな対話型インターフェースを提供する [Chainlit](https://docs.chainlit.io/) を統合し、複数の大規模言語モデル (LLM) と Qdrant ベクトルデータベースを Docker という完全にコンテナ化されたエコシステムで組み合わせることで、プロフェッショナルなセキュリティログ分析と RAG (検索拡張生成) アプリケーションを実現しています。

## 開発・実行環境

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

## コアコンポーネント

1. **フロントエンド・インターフェース**: Chainlit (`cisco_security_chainlit.py`) を使用して会話型 AI インターフェースを構築し、リアルタイムのテキストストリーミングやチャット履歴をサポートします。
2. **多言語サポート**: 意図の分類、多言語理解、および翻訳機能は **Llama-3-Taiwan-8B-Instruct** を通じて処理されます。
3. **セキュリティ専門家モデル**: サイバーセキュリティ領域に特化してファインチューニングされた **Foundation-Sec-8B** を介して、綿密なシステムおよびセキュリティログ分析を実行します。
4. **ハードウェア・アクセラレーション**: NVIDIA のグラフィックカード上で推論パフォーマンスを最大化するために、Docker 内で NVIDIA CUDA (`cuBLAS`) と `llama-cpp-python` を統合しています。
5. **ベクトル検索 (RAG)**: Docker Compose 経由で導入された **Qdrant** を利用して社内のセキュリティドキュメントを保存・検索します。これにより言語モデルの分析精度が向上し、ハルシネーション（幻覚）が軽減します。

## システム要件

- **オペレーティング・システム**: Linux/Ubuntu を強く推奨します。
- **ハードウェア**: 充分な VRAM を備えた NVIDIA GPU。二つの Q4_K_M 8B モデルはデフォルトの層数設定で合計約 **4〜5 GB VRAM** を消費します。最低 **6 GB VRAM**（例: RTX 2060）が必要ですが、8 GB 以上を推奨します。
- **GPU 層数設定** — ご自身の GPU スペックに合わせて、`docker-compose.yml` の環境変数で GPU 層数を自由に調整できます：

  **パラメータ説明**（各モデルは 32 層、1 層あたり約 140 MB）：
  | 環境変数 | 役割 | 値の意味 |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | 意図分類 + 翻訳 | GPU に載せる層数（最大 32）|
  | `N_GPU_LAYERS_SEC` | セキュリティログの深層分析 | GPU に載せる層数（最大 32）|

  **GPU VRAM サイズ別の推奨設定値**：
  | GPU VRAM | 代表的な GPU | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | 推定 VRAM 消費 |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `10` | `20` | ~4.2 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `15` | `25` | ~5.6 GB |
  | 10 GB | RTX 3080 | `20` | `30` | ~7.0 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `24` | `32` | ~7.8 GB |
  | 16 GB+ | RTX 4080, A4000 | `32` | `32` | ~9.0 GB（フル GPU）|

  > ⚠️ 値を高く設定しすぎると（VRAM 容量を超えた場合）**CUDA Out-Of-Memory (OOM)** が発生します。
  > 計算式：`(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **前提条件**:
  - [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
  - ホスト上に [NVIDIA ドライバー](https://www.nvidia.com/Download/index.aspx) がインストールされていること。
  - ホスト上に [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) がインストールされていること (Docker コンテナからの GPU アクセスに必要)。
  - インターネット接続 (初回起動時のモデルやイメージのダウンロードに必要)。

## プロジェクト・アーキテクチャ

macOSバージョンとは異なり、このNVIDIAプロジェクトでは、ローカルの仮想環境を構築せずに完全にコンテナ化されたアーキテクチャを使用します:

```text
.
├── docker-compose.yml          # 主要な Docker オーケストレーションファイル (Chainlit と Qdrant)
├── Dockerfile                  # CUDA 対応 Python 環境を構築
├── models/                     # GGUF モデル保存用 (自動ダウンロード)
├── qdrant_storage/             # Qdrant ベクトルデータベースの永続的ストレージ・ディレクトリ
├── cisco_security_chainlit.py  # メインの Chainlit アプリケーションファイル
├── download_models.sh          # 必要な HuggingFaceのGGUFモデルを自動でダウンロード
└── (その他の Python スクリプトおよび設定ファイル)
```

## 実行方法

1. **ターミナルを開き**、このプロジェクトディレクトリに移動します:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **Docker Compose によるサービスの開始**:
   `docker-compose.yml` に必要なサービスがすべて定義されています。コマンドひとつで、イメージのビルド、CUDA 環境のセットアップ、`download_models.sh` 経由でのモデルダウンロードを行い、`qdrant` および `security-app` (Chainlit) コンテナを起動します。
   ```bash
   docker compose up -d --build
   ```
   *注意: 初回のイメージ構築やモデルのダウンロードには数分かかります。進行状況を確認するには、`-d` フラグを省略するか、`docker compose logs -f` を実行してください。*

3. **チャットの開始**:
   `security-app-gpu` コンテナが完全に起動すると、Chainlit の Web UI が利用可能になります。ブラウザを開いて、以下にアクセスしてください:
   ```
   http://localhost:8000
   ```

## トラブルシューティング

- **GPUが検出されない / コンテナが起動しない**: NVIDIA Container Toolkit がホスト上に正しくインストールされ設定されているか確認してください。コンテナは `NVIDIA_VISIBLE_DEVICES=all` パラメータと連携して GPU リソースを使用します。
- **メモリ不足 (OOM) / 頻繁なクラッシュ**: 各 Q4_K_M 8B モデルには **32 個の transformer 層**があり、1層あたり約 0.14 GB の VRAM を消費します。デフォルト設定（`N_GPU_LAYERS_LLAMA3=10`、`N_GPU_LAYERS_SEC=20`）で合計約 4.2 GBを使用します。引き続き OOM の場合は、`docker-compose.yml` の値を編集してください：
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=10   # OOM が続く場合は 5 に減らしてください
    - N_GPU_LAYERS_SEC=20      # OOM が続く場合は 15 に減らしてください
  ```
- **モデルのダウンロードに失敗する**: 最初の構築中にネットワークの問題などで失敗した場合は、プロセスを再開するか、`./download_models.sh` を手動で実行できます。

## 開発と高度な機能

- **RAG テキストのインポート**: 新たな基礎セキュリティドキュメントを Qdrant ナレッジベースにインポートするには、コンテナ内でインポート用スクリプトを実行してください:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **自動ログ翻訳・処理**: `translate_logs.py` は、ログのバッチ処理や言語間変換テストを実行するためのテンプレートを提供します。上記と同様にコンテナ内で実行できます。

---

**Maintained by [Willis Chen](mailto:misweyu2007@gmail.com)**
