#!/usr/bin/env bash
set -euo pipefail

# Always run relative to this script's directory
cd "$(dirname "$0")"

# Create (or clean) cert directory
mkdir -p certs
cd certs

echo "🔧 Generating dev CA, server, and client certificates..."

# -------------------------
# 1️⃣  Create a Dev Root CA
# -------------------------
openssl genrsa -out ca-key.pem 4096
openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 3650 \
  -subj "/CN=Dev CA" -out ca.pem

# -------------------------
# 2️⃣  Generate Server Cert
# -------------------------
openssl genrsa -out server-key.pem 2048
openssl req -new -key server-key.pem -subj "/CN=localhost" -out server.csr

# Add both localhost and Docker service name (parta-server) to SAN
cat > server.ext <<EOF
subjectAltName=DNS:localhost,DNS:parta-server,IP:127.0.0.1
extendedKeyUsage=serverAuth
EOF

openssl x509 -req -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial \
  -out server.pem -days 365 -sha256 -extfile server.ext

# -------------------------
# 3️⃣  Generate Client Cert
# -------------------------
openssl genrsa -out client-key.pem 2048
openssl req -new -key client-key.pem -subj "/CN=demo-client" -out client.csr

cat > client.ext <<EOF
extendedKeyUsage=clientAuth
EOF

openssl x509 -req -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial \
  -out client.pem -days 365 -sha256 -extfile client.ext

# -------------------------
# 4️⃣  Summary
# -------------------------
echo "✅ Generated dev CA + server/client certs in $(pwd)"
echo "📁 Files:"
ls -1 | sed 's/^/   - /'

# Quick check (optional)
echo "🔍 SAN in server cert:"
openssl x509 -in server.pem -noout -text | grep -A1 "Subject Alternative Name" || true
