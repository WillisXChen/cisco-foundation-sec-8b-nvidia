# Cisco Foundation-Sec 8B บน NVIDIA GPU (ผู้ช่วยด้านความปลอดภัยสองภาษา)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-gray?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-gray?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-blue?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-gray?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-gray?style=for-the-badge)](README.TiengViet.md)

**ดูแลโดย [Willis Chen](mailto:misweyu2007@gmail.com)**

โปรเจกต์นี้เป็นผู้ช่วยอัจฉริยะสำหรับการวิเคราะห์ความปลอดภัยสองภาษา (จีน/อังกฤษ) ที่ใช้พลังของ **NVIDIA GPU** โดยการรวม [Chainlit](https://docs.chainlit.io/) เพื่อให้อินเทอร์เฟซการโต้ตอบที่ทันสมัย และรวมโมเดลภาษาขนาดใหญ่ (LLMs) หลายโมเดลเข้ากับฐานข้อมูลเวกเตอร์ Qdrant ผ่านสถาปัตยกรรม Docker ที่เป็นคอนเทนเนอร์อย่างสมบูรณ์ ทำให้สามารถวิเคราะห์บันทึกความปลอดภัยและใช้งาน RAG (Retrieval-Augmented Generation) ได้อย่างมืออาชีพ

## สร้างด้วย

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

## ส่วนประกอบหลักของโปรเจกต์

1. **อินเทอร์เฟซส่วนหน้า**: ใช้ Chainlit (`cisco_security_chainlit.py`) เพื่อสร้างอินเทอร์เฟซ AI สำหรับการสนทนา รองรับการสตรีมข้อความแบบเรียลไทม์และประวัติการแชท
2. **การรองรับหลายภาษา**: จัดการการจำแนกเจตนา ความเข้าใจหลายภาษา และการแปลผ่าน **Llama-3-Taiwan-8B-Instruct**
3. **ผู้เชี่ยวชาญด้านความปลอดภัย**: ทำการวิเคราะห์บันทึกระบบและความปลอดภัยในเชิงลึกผ่าน **Foundation-Sec-8B** ซึ่งได้รับการปรับแต่งมาโดยเฉพาะสำหรับโดเมนความปลอดภัยทางไซเบอร์
4. **การเร่งความเร็วด้วยฮาร์ดแวร์**: รวม NVIDIA CUDA (`cuBLAS`) เข้ากับ `llama-cpp-python` ภายใน Docker เพื่อเพิ่มประสิทธิภาพการประมวลผลบนการ์ดจอ NVIDIA ให้สูงสุด
5. **การค้นหาเวกเตอร์ (RAG)**: ใช้ **Qdrant** (ติดตั้งผ่าน Docker Compose) เพื่อจัดเก็บและค้นหาเอกสารความปลอดภัยภายในองค์กร ช่วยเพิ่มความแม่นยำในการวิเคราะห์โมเดลภาษาและลดการเกิดอาการ "หลอน" (Hallucinations)
6. **ประสบการณ์ผู้ใช้งานที่สวยงาม**: มาพร้อมการสร้างแบรนด์ที่กำหนดเองด้วยโลโก้ตามสั่ง ธีมมืด/สว่าง (`public/theme.json`) หน้าจอต้อนรับที่ปรับตามภาษา และการติดตามความหน่วงของการประมวลผลแบบเรียลไทม์ ("Thought for X seconds")

## ความต้องการของระบบ

- **ระบบปฏิบัติการ**: แนะนำให้ใช้ Linux/Ubuntu อย่างยิ่ง
- **ฮาร์ดแวร์**: NVIDIA GPU ที่มี VRAM เพียงพอ โมเดล Q4_K_M 8B สองโมเดลต้องการ VRAM ประมาณ **4–5 GB** ภายใต้การกำหนดค่าเลเยอร์เริ่มต้น GPU ที่มี VRAM อย่างน้อย **6 GB** (เช่น RTX 2060) เป็นขั้นต่ำ แนะนำให้ใช้ 8 GB ขึ้นไป
- **การกำหนดค่าเลเยอร์ GPU** — ปรับจำนวนเลเยอร์ที่ส่งต่อไปยัง GPU ให้ตรงกับสเปก GPU ของคุณผ่านตัวแปรสภาพแวดล้อมใน `docker-compose.yml`:

  **การอ้างอิงพารามิเตอร์** (แต่ละโมเดลมี 32 เลเยอร์; แต่ละเลเยอร์ใช้ VRAM ≈ 140 MB):
  | ตัวแปรสภาพแวดล้อม | บทบาท | ความหมายของค่า |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | การจำแนกเจตนา + การแปล | จำนวนเลเยอร์บน GPU (สูงสุด 32) |
  | `N_GPU_LAYERS_SEC` | การวิเคราะห์บันทึกความปลอดภัยเชิงลึก | จำนวนเลเยอร์บน GPU (สูงสุด 32) |

  **ค่าที่แนะนำตามขนาด VRAM ของ GPU**:
  | GPU VRAM | ตัวอย่าง GPU | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | การใช้ VRAM โดยประมาณ |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ การตั้งค่าค่าสูงเกินไป (เกินความจุ VRAM) จะทำให้เกิด **CUDA Out-Of-Memory (OOM)**
  > สูตรด่วน: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **สิ่งที่ต้องมีก่อน**:
  - [Docker](https://docs.docker.com/get-docker/) และ [Docker Compose](https://docs.docker.com/compose/install/)
  - ติดตั้ง [NVIDIA Driver](https://www.nvidia.com/Download/index.aspx) บนเครื่องโฮสต์
  - ติดตั้ง [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (เพื่ออนุญาตให้ GPU ส่งผ่านไปยัง Docker)
  - การเชื่อมต่ออินเทอร์เน็ต (จำเป็นสำหรับการดาวน์โหลดโมเดลและอิมเมจคอนเทนเนอร์ในการเรียกใช้ครั้งแรก)

## สถาปัตยกรรมโปรเจกต์

แตกต่างจากเวอร์ชัน macOS โปรเจกต์ NVIDIA นี้ใช้สถาปัตยกรรมคอนเทนเนอร์อย่างสมบูรณ์โดยไม่จำเป็นต้องมีสภาพแวดล้อมเสมือนจริงในเครื่อง:

```text
.
├── docker-compose.yml          # ไฟล์หลักสำหรับการจัดการ Docker (Chainlit + Qdrant)
├── Dockerfile                  # สร้างสภาพแวดล้อม Python ที่รองรับ CUDA
├── models/                     # ที่เก็บโมเดล GGUF (ดาวน์โหลดโดยอัตโนมัติ)
├── qdrant_storage/             # ไดเรกทอรีจัดเก็บข้อมูลถาวรสำหรับฐานข้อมูลเวก터 Qdrant
├── public/                     # แบรนด์และทรัพยากร UI (โลโก้, CSS, ธีม)
├── cisco_security_chainlit.py  # ไฟล์แอปพลิ케ชัน Chainlit หลัก
├── playbooks.json              # SOP ด้านความปลอดภัยแบบรวมศูนย์สำหรับการนำเข้า RAG
├── download_models.sh          # ดาวน์โหลดโมเดล HuggingFace GGUF ที่ต้องการโดยอัตโนมัติ
└── htpasswd_user.sh            # สคริปต์จัดการผู้ใช้สำหรับการตรวจสอบสิทธิ์ Nginx
```

## วิธีการรัน

1. **เปิดเทอร์มินัล** และไปยังไดเรกทอรีโปรเจกต์นี้:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **เริ่มบริการผ่าน Docker Compose**:
   ไฟล์ `docker-compose.yml` กำหนดทุกสิ่งที่จำเป็น มันจะสร้างอิมเมจ ติดตั้งการพึ่งพา CUDA ดาวน์โหลดโมเดลผ่าน `download_models.sh` และเริ่มทั้งคอนเทนเนอร์ `qdrant` และ `security-app` (Chainlit)
   ```bash
   docker compose up -d --build
   ```
   *หมายเหตุ: การสร้างอิมเมจและการดาวน์โหลดโมเดลในครั้งแรกจะใช้เวลาหลายนาที คุณสามารถตรวจสอบความคืบหน้าได้โดยไม่ต้องใส่แฟล็ก `-d` หรือตรวจสอบบันทึกด้วย `docker compose logs -f`*

3. **เริ่มการแชท**:
   เมื่อคอนเทนเนอร์ `security-app-gpu` ทำงานอย่างสมบูรณ์แล้ว เว็บ UI ของ Chainlit จะพร้อมใช้งาน เปิดเบราว์เซอร์ของคุณแล้วไปที่:
   ```
   http://localhost:8000
   ```

## การแก้ไขปัญหา

- **ตรวจไม่พบ GPU / คอนเทนเนอร์ไม่เริ่มทำงาน**: ตรวจสอบให้แน่ใจว่าติดตั้งและกำหนดค่า NVIDIA Container Toolkit อย่างถูกต้องบนเครื่องโฮสต์ คอนเทนเนอร์ใช้ `deploy.resources.reservations.devices` ร่วมกับไดรเวอร์ `nvidia`
- **หน่วยความจำไม่เพียงพอ (OOM) / การขัดข้องบ่อยครั้ง**: โมเดล Q4_K_M 8B แต่ละโมเดลมี **32 เทรนส์ฟอร์เมอร์เลเยอร์** โดยแต่ละเลเยอร์ใช้ VRAM ประมาณ 140 MB การแยกตามค่าเริ่มต้น (`N_GPU_LAYERS_LLAMA3=5`, `N_GPU_LAYERS_SEC=15`) จะใช้รวมประมาณ 2.8 GB หากยังเกิด OOM ให้แก้ไขค่าเหล่านี้ใน `docker-compose.yml`:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # ลดเหลือ 3 หากยังเกิด OOM
    - N_GPU_LAYERS_SEC=15      # ลดเหลือ 10 หากยังเกิด OOM
  ```
- **ดาวน์โหลดโมเดลไม่สำเร็จ**: หากเกิดปัญหาเครือข่ายระหว่างกระบวนการสร้าง คุณสามารถเรียกใช้ `./download_models.sh` ด้วยตนเองหรือเริ่มกระบวนการสร้างใหม่

## การพัฒนาและคุณสมบัติขั้นสูง

- **การนำเข้าข้อความ RAG**: SOP ด้านความปลอดภัยจะถูกจัดการแบบรวมศูนย์ใน `playbooks.json` หากต้องการนำเข้าเอกสารเหล่านี้เข้าสู่ฐานความรู้ Qdrant คุณสามารถเรียกใช้สคริปต์การนำเข้าภายในคอนเทนเนอร์:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **การแปล/การประมวลผลบันทึกอัตโนมัติ**: `translate_logs.py` ให้เทมเพลตสำหรับการประมวลผลบันทึกแบบแบตช์หรือการทดสอบการแปลงข้ามภาษา คุณสามารถรันภายในคอนเทนเนอร์ได้เช่นเดียวกับคำสั่งด้านบน

## การควบคุมการเข้าถึง — การจัดการผู้ใช้ Nginx htpasswd

แอปพลิ케ชันได้รับการปกป้องโดยการตรวจสอบสิทธิ์พื้นฐาน HTTP ผ่าน Nginx ใช้ `htpasswd_user.sh` เพื่อจัดการข้อมูลประจำตัว การเปลี่ยนแปลงจะมีผลทันทีโดยไม่ต้องเริ่มคอนเทนเนอร์ใหม่

> **การตั้งค่าครั้งแรก** — ให้สิทธิ์การเรียกใช้หนึ่งครั้ง:
> ```bash
> chmod +x htpasswd_user.sh
> ```

### เพิ่ม / อัปเดตผู้ใช้

```bash
# แบบโต้ตอบ (ซ่อนรหัสผ่านจากประวัติเชลล์ — แนะนำ)
./htpasswd_user.sh add admin

# แบบไม่โต้ตอบ
./htpasswd_user.sh add alice secret123
```

### ลบผู้ใช้

```bash
./htpasswd_user.sh del alice
```

### แสดงรายชื่อผู้ใช้ทั้งหมด

```bash
./htpasswd_user.sh list
```

> หลังจาก `add` หรือ `del` สคริปต์จะส่ง `nginx -s reload` โดยอัตโนมัติเพื่อใช้การเปลี่ยนแปลงอย่างราบรื่นโดยไม่ตัดการเชื่อมต่อที่กำลังทำงานอยู่

---

**ดูแลโดย [Willis Chen](mailto:misweyu2007@gmail.com)**
