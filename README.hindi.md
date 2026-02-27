# NVIDIA GPU पर Cisco Foundation-Sec 8B (द्विभाषिक सुरक्षा सहायक)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-gray?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-gray?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-gray?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-blue?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-gray?style=for-the-badge)](README.TiengViet.md)

**अनुरक्षक: [Willis Chen](mailto:misweyu2007@gmail.com)**

यह प्रोजेक्ट **NVIDIA GPUs** की शक्ति का लाभ उठाने वाला एक द्विभाषिक (चीनी/अंग्रेजी) सुरक्षा विश्लेषण स्मार्ट सहायक है। एक आधुनिक संवादात्मक इंटरफ़ेस प्रदान करने के लिए [Chainlit](https://docs.chainlit.io/) को एकीकृत करके, और पूरी तरह से कंटेनरीकृत डॉकर आर्किटेक्चर के माध्यम से Qdrant वेक्टर डेटाबेस के साथ कई बड़े भाषा मॉडल (LLMs) को मिलाकर, यह पेशेवर सुरक्षा लॉग विश्लेषण और RAG (रिट्रीवल-ऑगमेंटेड जनरेशन) एप्लिकेशन प्राप्त करता है।

## इनके साथ निर्मित

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

## प्रोजेक्ट के मुख्य घटक

1. **फ्रंटएंड इंटरफ़ेस**: एक संवादात्मक AI इंटरफ़ेस बनाने के लिए Chainlit (`cisco_security_chainlit.py`) का उपयोग करता है, जो वास्तविक समय टेक्स्ट स्ट्रीमिंग और चैट इतिहास का समर्थन करता है।
2. **बहु-भाषा समर्थन**: **Llama-3-Taiwan-8B-Instruct** के माध्यम से इरादा वर्गीकरण, बहु-भाषा समझ और अनुवाद को संभालता है।
3. **सुरक्षा विशेषज्ञ**: **Foundation-Sec-8B** के माध्यम से गहन प्रणाली और सुरक्षा लॉग विश्लेषण करता है, जो विशेष रूप से साइबर सुरक्षा क्षेत्र के लिए तैयार किया गया है।
4. **हार्डवेयर त्वरण**: NVIDIA ग्राफिक्स कार्ड पर अनुमान प्रदर्शन को अधिकतम करने के लिए डॉकर के भीतर NVIDIA CUDA (`cuBLAS`) को `llama-cpp-python` के साथ एकीकृत करता है।
5. **वेक्टर रिट्रीवल (RAG)**: आंतरिक उद्यम सुरक्षा दस्तावेजों को संग्रहीत और पुनर्प्राप्त करने के लिए **Qdrant** (डॉकर कंपोज़ के माध्यम से तैनात) का उपयोग करता है, जिससे भाषा मॉडल की विश्लेषण सटीकता बढ़ती है और मतिभ्रम (hallucinations) कम होता है।
6. **बेहतर उपयोगकर्ता अनुभव**: कस्टम लोगो के साथ कस्टम ब्रांडिंग, डार्क/लाइट थीम (`public/theme.json`), स्थानीयकृत स्वागत स्क्रीन और वास्तविक समय अनुमान विलंबता ट्रैकिंग ("X सेकंड के लिए सोचा") की सुविधा देता है।

## सिस्टम आवश्यकताएं

- **ऑपरेटिंग सिस्टम**: लिनक्स/उबंटू की अत्यधिक अनुशंसा की जाती है।
- **हार्डवेयर**: पर्याप्त VRAM वाला NVIDIA GPU। दो Q4_K_M 8B मॉडल को डिफ़ॉल्ट लेयर कॉन्फ़िगरेशन के तहत लगभग **4–5 GB VRAM** की आवश्यकता होती है। कम से कम **6 GB VRAM** (जैसे RTX 2060) वाला GPU न्यूनतम है; 8 GB या अधिक की अनुशंसा की जाती है।
- **GPU लेयर कॉन्फ़िगरेशन** — `docker-compose.yml` में पर्यावरण चर के माध्यम से अपने स्वयं के GPU स्पेक से मेल खाने के लिए GPU-ऑफलोड लेयर्स की संख्या को समायोजित करें:

  **पैरामीटर संदर्भ** (प्रत्येक मॉडल में 32 लेयर हैं; प्रत्येक लेयर ≈ 140 MB VRAM):
  | पर्यावरण चर | भूमिका | मान का अर्थ |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | इरादा वर्गीकरण + अनुवाद | GPU पर लेयर्स की संख्या (अधिकतम 32) |
  | `N_GPU_LAYERS_SEC` | सुरक्षा लॉग गहन विश्लेषण | GPU पर लेयर्स की संख्या (अधिकतम 32) |

  **GPU VRAM आकार के अनुसार अनुशंसित मान**:
  | GPU VRAM | उदाहरण GPUs | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | अनुमानित VRAM उपयोग |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ मान बहुत अधिक (आपकी VRAM क्षमता से अधिक) सेट करने से **CUDA Out-Of-Memory (OOM)** हो जाएगा।
  > त्वरित सूत्र: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **पूर्वापेक्षाएँ**:
  - [Docker](https://docs.docker.com/get-docker/) और [Docker Compose](https://docs.docker.com/compose/install/)
  - होस्ट पर स्थापित [NVIDIA ड्राइवर](https://www.nvidia.com/Download/index.aspx)।
  - [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) स्थापित (डॉकर के लिए GPU पासथ्रू सक्षम करने के लिए)।
  - इंटरनेट कनेक्शन (पहली बार लॉन्च पर मॉडल और कंटेनर इमेज डाउनलोड करने के लिए आवश्यक)।

## प्रोजेक्ट आर्किटेक्चर

macOS संस्करण के विपरीत, यह NVIDIA प्रोजेक्ट स्थानीय वर्चुअल वातावरण की आवश्यकता के बिना पूरी तरह से कंटेनरीकृत आर्किटेक्चर का उपयोग करता है:

```text
.
├── docker-compose.yml          # मुख्य डॉकर ऑर्केस्ट्रेशन फ़ाइल (Chainlit + Qdrant)
├── Dockerfile                  # CUDA-सक्षम पायथन वातावरण बनाता है
├── models/                     # GGUF मॉडल स्टोरेज (स्वचालित रूप से डाउनलोड किया गया)
├── qdrant_storage/             # Qdrant वेक्टर डेटाबेस के लिए निरंतर स्टोरेज निर्देशिका
├── public/                     # कस्टम ब्रांडिंग एसेट्स (लोगो, CSS, थीम)
├── cisco_security_chainlit.py  # मुख्य Chainlit एप्लिकेशन फ़ाइल
├── playbooks.json              # RAG अंतर्ग्रहण के लिए केंद्रीकृत सुरक्षा SOPs
├── download_models.sh          # आवश्यक HuggingFace GGUF मॉडल को ऑटो-डाउनलोड करता है
└── htpasswd_user.sh            # Nginx बेसिक ऑथेंटिकेशन उपयोगकर्ता प्रबंधन स्क्रिप्ट
```

## कैसे चलाएं

1. **टर्मिनल खोलें**, और इस प्रोजेक्ट निर्देशिका पर जाएं:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **डॉकर कंपोज़ के माध्यम से सेवाएँ शुरू करें**:
   `docker-compose.yml` फ़ाइल आवश्यक सभी चीज़ों को परिभाषित करती है। यह इमेज बनाएगी, CUDA निर्भरताएँ स्थापित करेगी, `download_models.sh` के माध्यम mें मॉडल डाउनलोड करेगी, और `qdrant` और `security-app` (Chainlit)Container दोनों शुरू करेगी।
   ```bash
   docker compose up -d --build
   ```
   *नोट: पहली बार इमेज बनाने और मॉडल डाउनलोड करने में कई मिनट लगेंगे। आप `-d` ध्वज को हटाकर या `docker compose logs -f` के साथ लॉग की जाँच करके प्रगति देख सकते हैं।*

3. **चैटिंग शुरू करें**:
   एक बार जब `security-app-gpu` कंटेनर पूरी तरह से चल रहा हो, तो Chainlit वेब UI उपलब्ध होगा। अपना ब्राउज़र खोलें और यहां जाएं:
   ```
   http://localhost:8000
   ```

## समस्या निवारण

- **GPU का पता नहीं चला / कंटेनर शुरू होने में विफल**: सुनिश्चित करें कि होस्ट पर NVIDIA Container Toolkit स्थापित और सही ढंग से कॉन्फ़िगर किया गया है। कंटेनर `nvidia` ड्राइवर के साथ `deploy.resources.reservations.devices` का उपयोग करता है।
- **मेमोरी की कमी (OOM) / बार-बार क्रैश**: प्रत्येक Q4_K_M 8B मॉडल में **32 ट्रांसफॉर्मर लेयर्स** होती हैं, जिनमें से प्रत्येक ~140 MB VRAM की खपत करती है। डिफ़ॉल्ट विभाजन (`N_GPU_LAYERS_LLAMA3=5`, `N_GPU_LAYERS_SEC=15`) कुल ~2.8 GB का उपयोग करता है। दबाव कम करने के लिए, `docker-compose.yml` में इन मानों को संपादित करें:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # यदि OOM बना रहता है तो 3 तक कम करें
    - N_GPU_LAYERS_SEC=15      # यदि OOM बना रहता है तो 10 तक कम करें
  ```
- **मॉडल डाउनलोड करने में विफल**: यदि निर्माण प्रक्रिया के दौरान नेटवर्क संबंधी समस्याएं आती हैं, तो आप मैन्युअल रूप से `./download_models.sh` निष्पादित कर सकते हैं या निर्माण प्रक्रिया को पुनरारंभ कर सकते हैं।

## विकास और उन्नत सुविधाएँ

- **RAG टेक्स्ट इनजेशन**: सुरक्षा SOPs को केंद्रीकृत रूप से `playbooks.json` में प्रबंधित किया जाता है। इन दस्तावेजों को Qdrant नॉलेज बेस में आयात करने के लिए, आप कंटेनर के भीतर इनजेशन स्क्रिप्ट चला सकते हैं:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **स्वचालित लॉग अनुवाद/प्रसंस्करण**: `translate_logs.py` लॉग्स के बैच प्रसंस्करण या क्रॉस-भाषा रूपांतरण परीक्षण करने के लिए एक टेम्पलेट प्रदान करता है। आप इसे उपर्युक्त कमांड के समान कंटेनर के भीतर चला सकते हैं।

## एक्सेस कंट्रोल — Nginx htpasswd उपयोगकर्ता प्रबंधन

एप्लिकेशन Nginx के माध्यम से HTTP बेसिक ऑथेंटिकेशन द्वारा सुरक्षित है। क्रेडेंशियल प्रबंधित करने के लिए `htpasswd_user.sh` का उपयोग करें। परिवर्तन किसी भी कंटेनर को पुनरारंभ किए बिना तुरंत प्रभावी होते हैं।

> **पहली बार सेटअप** — एक बार निष्पादन अनुमति दें:
> ```bash
> chmod +x htpasswd_user.sh
> ```

### उपयोगकर्ता जोड़ें / अपडेट करें

```bash
# संवादात्मक (शेल इतिहास से पासवर्ड छिपा हुआ — अनुशंसित)
./htpasswd_user.sh add admin

# गैर-संवादात्मक
./htpasswd_user.sh add alice secret123
```

### उपयोगकर्ता हटाएं

```bash
./htpasswd_user.sh del alice
```

### सभी उपयोगकर्ताओं को सूचीबद्ध करें

```bash
./htpasswd_user.sh list
```

> प्रत्येक `add` या `del` के बाद, स्क्रिप्ट सक्रिय कनेक्शन को छोड़े बिना परिवर्तनों को सुचारू रूप से लागू करने के लिए स्वचालित रूप से `nginx -s reload` भेजती है।

---

**अनुरक्षक: [Willis Chen](mailto:misweyu2007@gmail.com)**
