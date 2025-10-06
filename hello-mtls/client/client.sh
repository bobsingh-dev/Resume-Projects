#!/bin/bash
set -e
BASE_DIR=$(dirname "$0")
CERT_DIR="$BASE_DIR/../certs"

echo "🌐 Attempting mTLS connection..."
curl -s --cacert "$CERT_DIR/ca.crt" \
     --cert "$CERT_DIR/client.crt" \
     --key "$CERT_DIR/client.key" \
     https://localhost:4443 >/dev/null && \
echo "✅ Connection succeeded: mutual TLS verified!"
