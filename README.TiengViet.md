# Cisco Foundation-Sec 8B trên NVIDIA GPU (Trợ lý Bảo mật Song ngữ)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-gray?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-gray?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-gray?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-gray?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-blue?style=for-the-badge)](README.TiengViet.md)

**Duy trì bởi [Willis Chen](mailto:misweyu2007@gmail.com)**

Dự án này là một trợ lý thông minh phân tích bảo mật song ngữ (Trung/Anh) tận dụng sức mạnh của **NVIDIA GPU**. Bằng cách tích hợp [Chainlit](https://docs.chainlit.io/) để cung cấp giao diện tương tác hiện đại, và kết hợp nhiều Mô hình Ngôn ngữ Lớn (LLMs) với cơ sở dữ liệu vector Qdrant thông qua kiến trúc Docker được đóng gói hoàn toàn, dự án đạt được khả năng phân tích nhật ký bảo mật chuyên nghiệp và các ứng dụng RAG (Retrieval-Augmented Generation).

## Công nghệ sử dụng

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

## Thành phần cốt lõi của dự án

1. **Giao diện Frontend**: Sử dụng Chainlit (`cisco_security_chainlit.py`) để xây dựng giao diện AI hội thoại, hỗ trợ truyền luồng văn bản thời gian thực và lịch sử trò chuyện.
2. **Hỗ trợ đa ngôn ngữ**: Xử lý phân loại ý định, hiểu đa ngôn ngữ và dịch thuật thông qua **Llama-3-Taiwan-8B-Instruct**.
3. **Chuyên gia Bảo mật**: Thực hiện phân tích nhật ký hệ thống và bảo mật chuyên sâu thông qua **Foundation-Sec-8B**, được tinh chỉnh đặc biệt cho lĩnh vực an ninh mạng.
4. **Tăng tốc phần cứng**: Tích hợp NVIDIA CUDA (`cuBLAS`) với `llama-cpp-python` trong Docker để tối đa hóa hiệu suất suy luận trên card đồ họa NVIDIA.
5. **Truy xuất Vector (RAG)**: Sử dụng **Qdrant** (triển khai qua Docker Compose) để lưu trữ và truy xuất các tài liệu bảo mật nội bộ doanh nghiệp, từ đó nâng cao độ chính xác của mô hình ngôn ngữ và giảm thiểu hiện tượng "ảo giác".
6. **Trải nghiệm người dùng tinh tế**: Bao gồm xây dựng thương hiệu tùy chỉnh với logo riêng, chủ đề sáng/tối (`public/theme.json`), màn hình chào mừng được bản địa hóa và theo dõi độ trễ suy luận thời gian thực ("Thought for X seconds").

## Yêu cầu hệ thống

- **Hệ điều hành**: Khuyến nghị sử dụng Linux/Ubuntu.
- **Phần cứng**: GPU NVIDIA có đủ VRAM. Hai mô hình Q4_K_M 8B cùng nhau yêu cầu khoảng **4–5 GB VRAM** với cấu hình lớp mặc định. GPU có ít nhất **6 GB VRAM** (ví dụ: RTX 2060) là mức tối thiểu; khuyến nghị 8 GB trở lên.
- **Cấu hình lớp GPU** — Điều chỉnh số lượng lớp được đẩy lên GPU để phù hợp với thông số GPU của bạn thông qua các biến môi trường trong `docker-compose.yml`:

  **Tham khảo tham số** (mỗi mô hình có 32 lớp; mỗi lớp ≈ 140 MB VRAM):
  | Biến môi trường | Vai trò | Ý nghĩa giá trị |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | Phân loại ý định + Dịch thuật | Số lớp trên GPU (tối đa 32) |
  | `N_GPU_LAYERS_SEC` | Phân tích sâu nhật ký bảo mật | Số lớp trên GPU (tối đa 32) |

  **Giá trị khuyến nghị theo kích thước VRAM GPU**:
  | VRAM GPU | Loại GPU điển hình | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | Ước tính VRAM sử dụng |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ Đặt giá trị quá cao (vượt quá dung lượng VRAM) sẽ gây ra lỗi **CUDA Out-Of-Memory (OOM)**.
  > Công thức nhanh: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **Điều kiện tiên quyết**:
  - [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
  - Đã cài đặt [NVIDIA Driver](https://www.nvidia.com/Download/index.aspx) trên máy chủ.
  - Đã cài đặt [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (để cho phép Docker truy cập GPU).
  - Kết nối Internet (cần thiết để tải xuống mô hình và hình ảnh container trong lần chạy đầu tiên).

## Kiến trúc dự án

Khác với phiên bản macOS, dự án NVIDIA này sử dụng kiến trúc đóng gói hoàn toàn trong container mà không cần thiết lập môi trường ảo cục bộ:

```text
.
├── docker-compose.yml          # Tệp điều phối Docker chính (Chainlit + Qdrant)
├── Dockerfile                  # Xây dựng môi trường Python hỗ trợ CUDA
├── models/                     # Lưu trữ mô hình GGUF (tự động tải xuống)
├── qdrant_storage/             # Thư mục lưu trữ vĩnh viễn cho cơ sở dữ liệu vector Qdrant
├── public/                     # Tài sản thương hiệu tùy chỉnh (logo, CSS, chủ đề)
├── cisco_security_chainlit.py  # Tệp ứng dụng Chainlit chính
├── playbooks.json              # Các SOP bảo mật tập trung để nạp vào RAG
├── download_models.sh          # Tự động tải xuống các mô hình GGUF từ HuggingFace
└── htpasswd_user.sh            # Tập lệnh quản lý người dùng xác thực Nginx
```

## Cách chạy

1. **Mở Terminal**, và di chuyển đến thư mục dự án này:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **Khởi động các dịch vụ qua Docker Compose**:
   Tệp `docker-compose.yml` định nghĩa mọi thứ cần thiết. Nó sẽ xây dựng hình ảnh, cài đặt các phụ thuộc CUDA, tải xuống mô hình qua `download_models.sh` và khởi động cả hai container `qdrant` và `security-app` (Chainlit).
   ```bash
   docker compose up -d --build
   ```
   *Lưu ý: Việc xây dựng hình ảnh và tải xuống mô hình lần đầu tiên sẽ mất vài phút. Bạn có thể kiểm tra tiến trình bằng cách bỏ cờ `-d` hoặc kiểm tra nhật ký bằng `docker compose logs -f`.*

3. **Bắt đầu trò chuyện**:
   Khi container `security-app-gpu` đã chạy hoàn toàn, giao diện web Chainlit sẽ sẵn sàng. Mở trình duyệt và truy cập:
   ```
   http://localhost:8000
   ```

## Xử lý sự cố

- **Không phát hiện được GPU / Container không khởi động được**: Đảm bảo NVIDIA Container Toolkit được cài đặt và cấu hình chính xác trên máy chủ. Container sử dụng `nvidia` driver.
- **Thiếu bộ nhớ (OOM) / Thường xuyên bị treo**: Mỗi mô hình Q4_K_M 8B có **32 lớp transformer**, mỗi lớp tiêu thụ khoảng 140 MB VRAM. Cấu hình mặc định (`N_GPU_LAYERS_LLAMA3=5`, `N_GPU_LAYERS_SEC=15`) sử dụng tổng cộng khoảng 2.8 GB. Để giảm áp lực, hãy chỉnh sửa các giá trị này trong `docker-compose.yml`:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # Giảm xuống 3 nếu OOM vẫn tiếp diễn
    - N_GPU_LAYERS_SEC=15      # Giảm xuống 10 nếu OOM vẫn tiếp diễn
  ```
- **Không tải được mô hình**: Nếu xảy ra sự cố mạng trong quá trình xây dựng, bạn có thể chạy `./download_models.sh` thủ công hoặc khởi động lại quá trình xây dựng.

## Phát triển và các tính năng nâng cao

- **Nạp văn bản RAG**: Các SOP bảo mật được quản lý tập trung trong `playbooks.json`. Để nhập các tài liệu này vào kho tri thức Qdrant, bạn có thể thực hiện tập lệnh nạp dữ liệu bên trong container:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **Dịch nhật ký/Xử lý tự động**: `translate_logs.py` cung cấp một mẫu để xử lý nhật ký hàng loạt hoặc thực hiện các thử nghiệm chuyển đổi ngôn ngữ chéo. Bạn có thể chạy nó bên trong container tương tự như lệnh trên.

## Kiểm soát truy cập — Quản lý người dùng Nginx htpasswd

Ứng dụng được bảo vệ bằng HTTP Basic Authentication qua Nginx. Sử dụng `htpasswd_user.sh` để quản lý thông tin đăng nhập. Các thay đổi có hiệu lực ngay lập tức mà không cần khởi động lại container.

> **Thiết lập lần đầu** — cấp quyền thực thi một lần:
> ```bash
> chmod +x htpasswd_user.sh
> ```

### Thêm / Cập nhật người dùng

```bash
# Tương tác (mật khẩu bị ẩn khỏi lịch sử shell — khuyến nghị)
./htpasswd_user.sh add admin

# Không tương tác
./htpasswd_user.sh add alice secret123
```

### Xóa người dùng

```bash
./htpasswd_user.sh del alice
```

### Liệt kê tất cả người dùng

```bash
./htpasswd_user.sh list
```

---

**Duy trì bởi [Willis Chen](mailto:misweyu2007@gmail.com)**
