#!/bin/sh
set -e
# 1) Issue a one-time join token so the agent can authenticate to server
TOKEN=$( /opt/spire/bin/spire-server token generate -spiffeID spiffe://example.org/spire/agent/join_token | awk '/token/ {print $2}' )
echo "Join token: $TOKEN"
# Have the running agent fetch it
/opt/spire/bin/spire-agent api fetch x509 -socketPath /run/spire/sockets/agent.sock >/dev/null 2>&1 || true


# 2) Register workloads (server & client identities)
/opt/spire/bin/spire-server entry create \
-spiffeID spiffe://example.org/workload/server \
-selector unix:user:root \
-x509SVIDTTL 120s


/opt/spire/bin/spire-server entry create \
-spiffeID spiffe://example.org/workload/client \
-selector unix:user:root \
-x509SVIDTTL 120s


echo "Registered server/client entries with 120s TTL (watch rotation logs)."
