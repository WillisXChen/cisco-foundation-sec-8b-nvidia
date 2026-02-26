# 🛡️ Cisco Foundation-Sec 8B — Security Assistant

**Powered by NVIDIA GPU · Chainlit · llama-cpp-python · Qdrant RAG**

---

Welcome! This is a **bilingual cybersecurity analysis assistant** running entirely on local GPU hardware. No data leaves your machine.

## 🤖 What I can do

- **Security Log Analysis** — Paste raw logs (Nginx, Apache, SSH, syslog) and get an instant expert assessment powered by **Foundation-Sec-8B**
- **Threat Classification** — Detect SQL injection, brute-force, directory traversal, and more
- **RAG Context Retrieval** — Answers are grounded in your internal security SOPs stored in Qdrant
- **Bilingual Output** — Analysis in English, then automatically translated to Traditional Chinese by **Llama-3-Taiwan-8B**

## 💬 How to use

Simply paste a log entry or ask a security question. For example:

```
192.168.1.10 - - [26/Feb/2026] "GET /etc/passwd HTTP/1.1" 404 -
```

---

> ⚙️ *Models are loading on first connection — this may take a moment.*
> Maintained by **Willis Chen** · [misweyu2007@gmail.com](mailto:misweyu2007@gmail.com)
