#!/usr/bin/env bash
set -e

REGISTRY="${1:-}"

echo "[+] Checking prerequisites..."
if ! command -v jq &> /dev/null; then
    echo "[+] Installing jq for safe JSON editing..."
    sudo apt-get update -qq && sudo apt-get install -y -qq jq
fi

echo "[+] Configuring Docker daemon (/etc/docker/daemon.json)..."
sudo mkdir -p /etc/docker

DAEMON_FILE="/etc/docker/daemon.json"
if [ ! -f "$DAEMON_FILE" ] || [ ! -s "$DAEMON_FILE" ]; then
    echo "{}" | sudo tee "$DAEMON_FILE" > /dev/null
fi

# 1. 安全合并 10m * 3 的日志限制
sudo jq '. + {
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}' "$DAEMON_FILE" | sudo tee "$DAEMON_FILE.tmp" > /dev/null

# 2. 如果传入了私有仓库参数，动态合并进去
if [ -n "$REGISTRY" ]; then
    echo "[+] Adding insecure-registry: $REGISTRY"
    sudo jq --arg reg "$REGISTRY" '
      .["insecure-registries"] = ((.["insecure-registries"] // []) + [$reg] | unique)
    ' "$DAEMON_FILE.tmp" | sudo tee "$DAEMON_FILE.tmp2" > /dev/null
    sudo mv "$DAEMON_FILE.tmp2" "$DAEMON_FILE.tmp"
fi

sudo mv "$DAEMON_FILE.tmp" "$DAEMON_FILE"
sudo chmod 644 "$DAEMON_FILE"

echo "[+] Restarting Docker service..."
sudo systemctl restart docker
echo "[✔] Docker daemon successfully configured and restarted!"
