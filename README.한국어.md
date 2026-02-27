# NVIDIA GPU 기반 Cisco Foundation-Sec 8B (이중 언어 보안 어시스턴트)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-gray?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-blue?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-gray?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-gray?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-gray?style=for-the-badge)](README.TiengViet.md)

**유지 관리자: [Willis Chen](mailto:misweyu2007@gmail.com)**

이 프로젝트는 **NVIDIA GPU**의 강력한 성능을 활용하는 이중 언어(중국어/영어) 보안 분석 스마트 어시스턴트입니다. [Chainlit](https://docs.chainlit.io/)을 통합하여 현대적인 대화형 인터페이스를 제공하고, 완전히 컨테이너화된 Docker 아키텍처를 통해 여러 대형 언어 모델(LLM)과 Qdrant 벡터 데이터베이스를 결합하여 전문적인 보안 로그 분석 및 RAG(검색 증강 생성) 애플리케이션을 구현합니다.

## 개발 및 실행 환경

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

## 핵심 프로젝트 구성 요소

1. **프론트엔드 인터페이스**: Chainlit(`cisco_security_chainlit.py`)을 사용하여 대화형 AI 인터페이스를 구축하고, 실시간 텍스트 스트리밍 및 채팅 기록을 지원합니다.
2. **다국어 지원**: **Llama-3-Taiwan-8B-Instruct**를 통해 의도 분류, 다국어 이해 및 번역을 처리합니다.
3. **보안 전문가 모델**: 사이버 보안 도메인에 특별히 미세 조정된 **Foundation-Sec-8B**를 통해 심층적인 시스템 및 보안 로그 분석을 수행합니다.
4. **하드웨어 가속**: NVIDIA 그래픽 카드에서 추론 성능을 극대화하기 위해 Docker 내에 NVIDIA CUDA(`cuBLAS`)와 `llama-cpp-python`을 통합합니다.
5. **벡터 검색(RAG)**: Docker Compose를 통해 배포된 **Qdrant**를 사용하여 내부 엔터프라이즈 보안 문서를 저장하고 검색하여 언어 모델의 분석 정확도를 높이고 환각(Hallucinations)을 줄입니다.
6. **세련된 사용자 경험**: 맞춤형 로고가 포함된 맞춤형 브랜드 자산(`public/theme.json`), 맞춤형 라이트/다크 테마, 현지화된 환영 화면 및 실시간 추론 지연 시간 추적("Thought for X seconds") 기능을 제공합니다.

## 시스템 요구 사항

- **운영 체제**: Linux/Ubuntu를 강력히 권장합니다.
- **하드웨어**: VRAM이 충분한 NVIDIA GPU. 두 개의 Q4_K_M 8B 모델은 기본 계층 구성에서 약 **4-5GB VRAM**이 필요합니다. 최소 **6GB VRAM**(예: RTX 2060) 이상의 GPU가 필요하며 여유 확보를 위해 8GB 이상을 권장합니다.
- **GPU 계층 구성** — `docker-compose.yml`의 환경 변수를 통해 자신의 GPU 사양에 맞게 GPU 오프로드 계층 수를 조정할 수 있습니다:

  **매개변수 참조**(각 모델에는 32개의 계층이 있으며, 각 계층은 약 140MB의 VRAM을 소모합니다):
  | 환경 변수 | 역할 | 의미 |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | 의도 분류 + 번역 | GPU의 계층 수(최대 32) |
  | `N_GPU_LAYERS_SEC` | 보안 로그 심층 분석 | GPU의 계층 수(최대 32) |

  **GPU VRAM 크기별 권장 값**:
  | GPU VRAM | 예시 GPU | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | 예상 VRAM 사용량 |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ VRAM 용량을 초과하여 값을 너무 높게 설정하면 **CUDA Out-Of-Memory(OOM)**가 발생합니다.
  > 빠른 공식: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **전제 조건**:
  - [Docker](https://docs.docker.com/get-docker/) 및 [Docker Compose](https://docs.docker.com/compose/install/)
  - 호스트에 설치된 [NVIDIA 드라이버](https://www.nvidia.com/Download/index.aspx).
  - 설치된 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)(Docker에 GPU 패스스루를 활성화하기 위해 필요).
  - 인터넷 연결(초기 실행 시 모델 및 컨테이너 이미지를 다운로드하는 데 필요).

## 프로젝트 아키텍처

macOS 버전과 달리 이 NVIDIA 프로젝트는 로컬 가상 환경이 필요 없는 완전히 컨테이너화된 아키텍처를 사용합니다:

```text
.
├── docker-compose.yml          # 기본 Docker 오케스트레이션 파일(Chainlit + Qdrant)
├── Dockerfile                  # CUDA 지원 Python 환경 구축
├── models/                     # GGUF 모델 스토리지(자동 다운로드됨)
├── qdrant_storage/             # Qdrant 벡터 데이터베이스의 영구 스토리지 디렉토리
├── public/                     # 커스텀 UI 리소스 (로고, CSS, 테마)
├── cisco_security_chainlit.py  # 메인 Chainlit 애플리케이션 파일
├── playbooks.json              # RAG 처리를 위한 중앙 집중식 보안 SOP
├── download_models.sh          # 필요한 HuggingFace GGUF 모델 자동 다운로드
└── htpasswd_user.sh            # Nginx 기본 인증 사용자 관리 스크립트
```

## 실행 방법

1. **터미널을 열고** 이 프로젝트 디렉토리로 이동합니다:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **Docker Compose를 통해 서비스 시작**:
   `docker-compose.yml` 파일에는 필요한 모든 것이 정의되어 있습니다. 이미지를 빌드하고, CUDA 종속성을 설정하고, `download_models.sh`를 통해 모델을 다운로드하고, `qdrant` 및 `security-app`(Chainlit) 컨테이너를 시작합니다.
   ```bash
   docker compose up -d --build
   ```
   *참고: 이미지를 빌드하고 모델을 처음 다운로드하는 데 몇 분 정도 걸립니다. `-d` 플래그를 생략하거나 `docker compose logs -f`로 로그를 확인하여 진행 상황을 확인할 수 있습니다.*

3. **채팅 시작**:
   `security-app-gpu` 컨테이너가 완전히 실행되면 Chainlit 웹 UI를 사용할 수 있습니다. 브라우저를 열고 다음으로 이동합니다:
   ```
   http://localhost:8000
   ```

## 문제 해결

- **GPU가 감지되지 않음 / 컨테이너가 시작되지 않음**: 호스트에 NVIDIA Container Toolkit이 올바르게 설치되고 구성되었는지 확인하세요. 컨테이너는 `deploy.resources.reservations.devices`와 `nvidia` 드라이버를 함께 사용합니다.
- **메모리 부족(OOM) / 잦은 충돌**: 각 Q4_K_M 8B 모델에는 **32개의 변환기 계층**이 있으며, 각 계층은 약 140MB의 VRAM을 소모합니다. 기본 분할(`N_GPU_LAYERS_LLAMA3=5`, `N_GPU_LAYERS_SEC=15`)은 총 약 2.8GB를 사용합니다. OOM이 계속 발생하면 `docker-compose.yml`에서 이 값을 편집하세요:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # OOM이 계속되면 3으로 줄이기
    - N_GPU_LAYERS_SEC=15      # OOM이 계속되면 10으로 줄이기
  ```
- **모델 다운로드 실패**: 초기 빌드 프로세스 중에 네트워크 문제가 발생하면 프로세스를 다시 시작하거나 `./download_models.sh`를 수동으로 실행할 수 있습니다.

## 개발 및 고급 기능

- **RAG 텍스트 수집**: 보안 SOP는 `playbooks.json`에서 중앙 관리됩니다. 이러한 새 기본 보안 문서를 Qdrant 지식 베이스로 가져오려면 컨테이너 내부에서 수집 스크립트를 실행할 수 있습니다:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **자동화된 로그 번역/처리**: `translate_logs.py`는 로그를 일괄 처리하거나 다국어 변환 테스트를 수행하기 위한 템플릿을 제공합니다. 위의 명령과 유사하게 컨테이너 내부에서 실행할 수 있습니다.

## 액세스 제어 — Nginx htpasswd 사용자 관리

이 애플리케이션은 Nginx를 통한 HTTP 기본 인증에 의해 보호됩니다. `htpasswd_user.sh`를 사용하여 사용자 계정을 관리하세요. 변경 사항은 컨테이너를 다시 시작할 필요 없이 즉시 적용됩니다.

> **초기 설정** — 실행 권한을 한 번 부여합니다:
> ```bash
> chmod +x htpasswd_user.sh
> ```

### 사용자 추가 / 업데이트

```bash
# 대화형(셸 기록에서 암호 숨김 - 권장)
./htpasswd_user.sh add admin

# 비대화형
./htpasswd_user.sh add alice secret123
```

### 사용자 삭제

```bash
./htpasswd_user.sh del alice
```

### 모든 사용자 목록

```bash
./htpasswd_user.sh list
```

> `add` 또는 `del` 후 스크립트는 활성 연결을 끊지 않고 변경 사항을 정상적으로 적용하기 위해 자동으로 `nginx -s reload`를 전송합니다.

---

**유지 관리자: [Willis Chen](mailto:misweyu2007@gmail.com)**
