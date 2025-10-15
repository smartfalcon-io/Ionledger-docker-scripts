#!/bin/bash

# ACA-Py startup script for EC2 environment
# Using EC2 public IP or DNS instead of ngrok

# Set your EC2 public IP or DNS
# export EC2_PUBLIC_DNS="ec2-43-205-92-53.ap-south-1.compute.amazonaws.com"
# export EC2_PUBLIC_IP="43.205.92.53"

# Use whichever you prefer (DNS is usually better)
ACAPY_ENDPOINT="http://traction-agent:8030"


echo "=============================================="
echo "🚀 Starting ACA-Py Agent on EC2"
echo "Endpoint: ${ACAPY_ENDPOINT}"
echo "Wallet Name: ${TRACTION_ACAPY_WALLET_NAME}"
echo "=============================================="

exec aca-py start \
    --inbound-transport http "0.0.0.0" "${TRACTION_ACAPY_HTTP_PORT}" \
    --outbound-transport http \
    --endpoint "${ACAPY_ENDPOINT}" \
    --wallet-name "${TRACTION_ACAPY_WALLET_NAME}" \
    --wallet-key "${TRACTION_ACAPY_WALLET_ENCRYPTION_KEY}" \
    --wallet-storage-config "{\"url\":\"${POSTGRESQL_HOST}:5432\",\"max_connections\":5,\"wallet_scheme\":\"${TRACTION_ACAPY_WALLET_SCHEME}\"}" \
    --wallet-storage-creds "{\"account\":\"${POSTGRESQL_USER}\",\"password\":\"${POSTGRESQL_PASSWORD}\",\"admin_account\":\"${POSTGRESQL_USER}\",\"admin_password\":\"${POSTGRESQL_PASSWORD}\"}" \
    --admin "0.0.0.0" "${TRACTION_ACAPY_ADMIN_PORT}" \
    --admin-api-key "${ACAPY_ADMIN_API_KEY}" \
    --plugin traction_plugins.traction_innkeeper.v1_0 \
    --plugin basicmessage_storage.v1_0 \
    --plugin connection_update.v1_0 \
    --plugin multitenant_provider.v1_0 \
    --plugin rpc.v1_0 \
    --genesis-url "${ACAPY_GENESIS_URL}" \
    --label "${ACAPY_LABEL}" \
    --log-level "${ACAPY_LOG_LEVEL}" \
    --auto-provision "${ACAPY_AUTO_PROVISION}" \
    --wallet-type "${ACAPY_WALLET_TYPE}"
