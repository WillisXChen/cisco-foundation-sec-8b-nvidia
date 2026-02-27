# Cisco Foundation-Sec 8B en GPU NVIDIA (Asistente de Seguridad Bilingüe)

[![English](https://img.shields.io/badge/English-gray?style=for-the-badge)](README.md) [![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.中文.md) [![日本語](https://img.shields.io/badge/%E6%97%A5%E6%9C%AC%E8%AA%9E-gray?style=for-the-badge)](README.日本語.md) [![简体中文](https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-gray?style=for-the-badge)](README.简体中文.md) [![Español](https://img.shields.io/badge/Espa%C3%B1ol-blue?style=for-the-badge)](README.Español.md) [![한국어](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-gray?style=for-the-badge)](README.한국어.md) [![ภาษาไทย](https://img.shields.io/badge/%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A2-gray?style=for-the-badge)](README.ภาษาไทย.md) [![हिन्दी](https://img.shields.io/badge/%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%B1%8D%E0%09%A6%E0%A5%80-gray?style=for-the-badge)](README.hindi.md) [![Tiếng Việt](https://img.shields.io/badge/Ti%E1%BA%BFng%20Vi%E1%BB%87t-gray?style=for-the-badge)](README.TiengViet.md)

**Mantenido por [Willis Chen](mailto:misweyu2007@gmail.com)**

Este proyecto es un asistente inteligente de análisis de seguridad bilingüe (Chino/Inglés) que aprovecha la potencia de las **GPUs NVIDIA**. Al integrar [Chainlit](https://docs.chainlit.io/) para proporcionar una interfaz interactiva moderna, y combinar múltiples Modelos de Lenguaje Grandes (LLMs) con la base de datos vectorial Qdrant a través de una arquitectura Docker completamente contenedorizada, logra un análisis profesional de logs de seguridad y aplicaciones RAG (Generación Aumentada por Recuperación).

## Desarrollado Con

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

## Componentes Principales del Proyecto

1. **Interfaz Frontend**: Utiliza Chainlit (`cisco_security_chainlit.py`) para construir una interfaz de IA conversacional, soportando streaming de texto en tiempo real e historial de chat.
2. **Soporte Multilingüe**: Maneja la clasificación de intención, comprensión multilingüe y traducción a través de **Llama-3-Taiwan-8B-Instruct**.
3. **Experto en Seguridad**: Realiza análisis profundos de logs de sistema y seguridad a través de **Foundation-Sec-8B**, ajustado específicamente para el dominio de la ciberseguridad.
4. **Aceleración de Hardware**: Integra NVIDIA CUDA (`cuBLAS`) con `llama-cpp-python` dentro de Docker para maximizar el rendimiento de inferencia en tarjetas gráficas NVIDIA.
5. **Recuperación Vectorial (RAG)**: Utiliza **Qdrant** (desplegado vía Docker Compose) para almacenar y recuperar documentos internos de seguridad empresarial, mejorando así la precisión del análisis del modelo de lenguaje y reduciendo las alucinaciones.
6. **Experiencia de Usuario Pulida**: Incluye branding personalizado con logotipos propios, temas claro/oscuro (`public/theme.json`), pantallas de bienvenida localizadas y seguimiento de latencia de inferencia en tiempo real ("Thought for X seconds").

## Requisitos del Sistema

- **Sistema Operativo**: Se recomienda encarecidamente Linux/Ubuntu.
- **Hardware**: GPU NVIDIA con suficiente VRAM. Los dos modelos Q4_K_M 8B requieren aproximadamente **4–5 GB de VRAM** bajo la configuración de capas predeterminada. Una GPU con al menos **6 GB de VRAM** (ej. RTX 2060) es lo mínimo; se recomiendan 8 GB o más.
- **Configuración de Capas de GPU** — Ajuste el número de capas delegadas a la GPU para que coincidan con las especificaciones de su propia GPU a través de variables de entorno en `docker-compose.yml`:

  **Referencia de Parámetros** (cada modelo tiene 32 capas; cada capa ≈ 140 MB de VRAM):
  | Variable de Entorno | Función | Significado del Valor |
  |---|---|---|
  | `N_GPU_LAYERS_LLAMA3` | Clasificación de intención + Traducción | Número de capas en GPU (máx 32) |
  | `N_GPU_LAYERS_SEC` | Análisis profundo de logs de seguridad | Número de capas en GPU (máx 32) |

  **Valores recomendados según el tamaño de VRAM de la GPU**:
  | VRAM de GPU | GPUs de Ejemplo | `N_GPU_LAYERS_LLAMA3` | `N_GPU_LAYERS_SEC` | VRAM Est. Usada |
  |---|---|---|---|---|
  | 6 GB | RTX 2060, RTX 3060 | `5` | `15` | ~2.8 GB |
  | 8 GB | RTX 3060 Ti, RTX 4060 | `10` | `20` | ~4.2 GB |
  | 10 GB | RTX 3080 | `15` | `25` | ~5.6 GB |
  | 12 GB | RTX 3080 Ti, RTX 4070 | `19` | `27` | ~6.4 GB |
  | 16 GB+ | RTX 4080, A4000 | `27` | `32` | ~8.3 GB |

  > ⚠️ Configurar valores demasiado altos (más allá de su capacidad de VRAM) causará **CUDA Out-Of-Memory (OOM)**.
  > Fórmula rápida: `(N_GPU_LAYERS_LLAMA3 × 140 MB) + (N_GPU_LAYERS_SEC × 140 MB) < GPU VRAM × 70%`

- **Prerrequisitos**:
  - [Docker](https://docs.docker.com/get-docker/) y [Docker Compose](https://docs.docker.com/compose/install/)
  - [Driver NVIDIA](https://www.nvidia.com/Download/index.aspx) instalado en el host.
  - [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) instalado (para permitir el passthrough de la GPU a Docker).
  - Conexión a Internet (requerida para descargar modelos e imágenes de contenedores en el primer lanzamiento).

## Arquitectura del Proyecto

A diferencia de la versión para macOS, este proyecto para NVIDIA utiliza una arquitectura completamente contenedorizada sin necesidad de un entorno virtual local:

```text
.
├── docker-compose.yml          # Archivo principal de orquestación Docker (Chainlit + Qdrant)
├── Dockerfile                  # Construye el entorno Python habilitado para CUDA
├── models/                     # Almacenamiento de modelos GGUF (descargados automáticamente)
├── qdrant_storage/             # Directorio de almacenamiento persistente para Qdrant
├── public/                     # Recursos de branding personalizados (logos, CSS, temas)
├── cisco_security_chainlit.py  # Archivo principal de la aplicación Chainlit
├── playbooks.json              # SOPs de seguridad centralizados para ingestión RAG
├── download_models.sh          # Descarga automática de modelos HuggingFace GGUF
└── htpasswd_user.sh            # Script de gestión de usuarios basic auth de Nginx
```

## Cómo Ejecutar

1. **Abra la terminal** y navegue hasta el directorio de este proyecto:
   ```bash
   cd /path/to/cisco-foundation-sec-8b-nvidia
   ```

2. **Inicie los servicios vía Docker Compose**:
   El archivo `docker-compose.yml` define todo lo necesario. Construirá la imagen, instalará las dependencias de CUDA, descargará los modelos vía `download_models.sh` e iniciará los contenedores `qdrant` y `security-app` (Chainlit).
   ```bash
   docker compose up -d --build
   ```
   *Nota: La construcción de la imagen y la descarga de los modelos por primera vez tomará varios minutos. Puede verificar el progreso omitiendo la bandera `-d` o revisando los logs con `docker compose logs -f`.*

3. **Comience a Chatear**:
   Una vez que el contenedor `security-app-gpu` esté completamente en ejecución, la interfaz web de Chainlit estará disponible. Abra su navegador y navegue a:
   ```
   http://localhost:8000
   ```

## Solución de Problemas

- **GPU no detectada / El contenedor no inicia**: Asegúrese de que el NVIDIA Container Toolkit esté instalado y configurado correctamente en el host. El contenedor utiliza `deploy.resources.reservations.devices` con el driver `nvidia`.
- **Memoria insuficiente (OOM) / Crashes frecuentes**: Cada modelo Q4_K_M 8B tiene **32 capas transformer**, cada una consumiendo ~140 MB de VRAM. La división predeterminada (`N_GPU_LAYERS_LLAMA3=5`, `N_GPU_LAYERS_SEC=15`) usa ~2.8 GB en total. Para reducir la presión, edite estos valores en `docker-compose.yml`:
  ```yaml
  environment:
    - N_GPU_LAYERS_LLAMA3=5    # Reducir a 3 si el OOM persiste
    - N_GPU_LAYERS_SEC=15      # Reducir a 10 si el OOM persiste
  ```
- **Fallo en la descarga de modelos**: Si ocurren problemas de red durante el proceso de construcción, puede ejecutar manualmente `./download_models.sh` o reiniciar el proceso de construcción.

## Desarrollo y Características Avanzadas

- **Ingestión de Texto RAG**: Los SOPs de seguridad se gestionan centralizadamente en `playbooks.json`. Para importar estos documentos en la base de conocimientos Qdrant, puede ejecutar el script de ingestión dentro del contenedor:
  ```bash
  docker exec -it security-app-gpu python ingest_security_docs.py
  ```
- **Traducción/Procesamiento Automático de Logs**: `translate_logs.py` proporciona una plantilla para el procesamiento por lotes de logs o la realización de pruebas de conversión entre idiomas. Puede ejecutarlo dentro del contenedor de manera similar al comando anterior.

## Control de Acceso — Gestión de Usuarios htpasswd de Nginx

La aplicación está protegida por Autenticación Básica HTTP vía Nginx. Use `htpasswd_user.sh` para gestionar credenciales. Los cambios surten efecto inmediatamente sin reiniciar ningún contenedor.

> **Configuración inicial** — otorgue permisos de ejecución una vez:
> ```bash
> chmod +x htpasswd_user.sh
> ```

### Añadir / Actualizar un usuario

```bash
# Interactivo (la contraseña se oculta del historial de la terminal — recomendado)
./htpasswd_user.sh add admin

# No interactivo
./htpasswd_user.sh add alice secret123
```

### Eliminar un usuario

```bash
./htpasswd_user.sh del alice
```

### Listar todos los usuarios

```bash
./htpasswd_user.sh list
```

---

**Mantenido por [Willis Chen](mailto:misweyu2007@gmail.com)**
