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
