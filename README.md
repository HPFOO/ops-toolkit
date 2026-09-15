# Ops Toolkit (`ops-toolkit`)

A modular collection of production-hardened DevOps automation scripts, server bootstrap tools, and security enhancers. Designed for rapid one-line execution across multi-node clusters and VPS environments.

---

## 🛠 Available Tools

| Category | Script | Description |
| :--- | :--- | :--- |
| **Coolify / Proxy** | `coolify/deploy-dummy-cert.sh` | Generates a 100-year dummy TLS certificate to prevent Censys/Shodan SNI scanning leaks on Traefik proxies. |
| **Docker** | `docker/init-daemon-limits.sh` | Limits container log files (`10m x 3`) to prevent disk overflow, with optional insecure registry support. |

---

## 🚀 Quick Start (One-Liners)

### 1. Coolify Traefik Anti-Scan Dummy Certificate (100-Year Fallback)
Generates a self-signed fallback certificate (`unauthorized.local`, valid for 36,500 days) and registers it as Traefik's `defaultCertificate`. Scanners hitting raw IP on port 443 receive no domain information.

```bash
curl -sSL [https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/coolify/deploy-dummy-cert.sh](https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/coolify/deploy-dummy-cert.sh) | bash

```

* **Target Machines**: Coolify Master node or any worker server exposing port `443` publicly.
* **Idempotent**: Safe to re-run at any time to renew or verify the fallback certificate.

---

### 2. Docker Daemon Log Rotation & Storage Guard

Caps container logs at 3 files of 10MB each (`max-size: 10m`, `max-file: 3`) using safe JSON merging via `jq`. Prevents unexpected root partition exhaustion.

#### Standard Run (Log Limit Only)

For standalone servers or nodes without internal Docker registries:

```bash
curl -sSL [https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/docker/init-daemon-limits.sh](https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/docker/init-daemon-limits.sh) | bash

```

#### Advanced Run (With Internal / Private Registry)

Pass the registry host/IP and port as the argument:

```bash
curl -sSL [https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/docker/init-daemon-limits.sh](https://raw.githubusercontent.com/HPFOO/ops-toolkit/main/docker/init-daemon-limits.sh) | bash -s -- "100.64.214.117:5000"

```

---

## 📂 Repository Layout

```text
ops-toolkit/
├── README.md
├── coolify/
│   └── deploy-dummy-cert.sh
└── docker/
    └── init-daemon-limits.sh

```

---

## 🔒 Security & Privacy

* **Zero Hardcoded Secrets**: No credentials, private IP addresses, or internal domains are embedded in any script.
* **Non-Destructive**: Merges with existing Docker configuration rather than overwriting the entire file.
