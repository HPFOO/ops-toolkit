#!/usr/bin/env bash
set -e

echo "[+] Preparing Traefik proxy directories..."
sudo mkdir -p /data/coolify/proxy/certs
sudo mkdir -p /data/coolify/proxy/dynamic

echo "[+] Generating 100-Year (36,500 days) Anti-Scan Dummy Certificate..."
sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 \
  -keyout /data/coolify/proxy/certs/dummy.key \
  -out /data/coolify/proxy/certs/dummy.crt \
  -subj "/C=US/ST=None/L=None/O=BlackHole/CN=unauthorized.local"

sudo chmod 600 /data/coolify/proxy/certs/dummy.key
sudo chmod 644 /data/coolify/proxy/certs/dummy.crt

echo "[+] Verifying Traefik dynamic TLS configuration..."
CONFIG_FILE="/data/coolify/proxy/dynamic/default-cert.yaml"

if [ ! -f "$CONFIG_FILE" ]; then
  sudo tee "$CONFIG_FILE" << 'EOF'
tls:
  stores:
    default:
      defaultCertificate:
        certFile: /traefik/certs/dummy.crt
        keyFile: /traefik/certs/dummy.key
EOF
  echo "[✔] Initialized $CONFIG_FILE with default dummy certificate."
else
  echo "[i] Existing $CONFIG_FILE detected. Dummy certificate renewed successfully."
fi

echo "[+] Reloading Traefik proxy container..."
if [ "$(docker ps -q -f name=coolify-proxy)" ]; then
    docker restart coolify-proxy
    echo "[✔] Traefik restarted. 100-Year Dummy Certificate is active!"
else
    echo "[!] coolify-proxy container not found. Configuration saved for initial boot."
fi
