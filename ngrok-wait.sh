#!/bin/bash

# ACA-Py startup script for EC2 environment
# Using EC2 public IP or DNS instead of ngrok

# Set your EC2 public IP or DNS
export EC2_PUBLIC_DNS="ec2-43-205-92-53.ap-south-1.compute.amazonaws.com"
export EC2_PUBLIC_IP="43.205.92.53"
# export ACAPY_ENDPOINT=http://43.205.92.53:8030

# Use whichever you prefer
export ACAPY_ENDPOINT="http://${EC2_PUBLIC_DNS}:${TRACTION_ACAPY_HTTP_PORT}"

echo "Fetched endpoint: ${ACAPY_ENDPOINT}"
echo "Starting aca-py agent ..."

exec aca-py start \
    --inbound-transport http "0.0.0.0" ${TRACTION_ACAPY_HTTP_PORT} \
    --outbound-transport http \
    --endpoint ${ACAPY_ENDPOINT} \
    --wallet-name "${TRACTION_ACAPY_WALLET_NAME}" \
    --wallet-key "${TRACTION_ACAPY_WALLET_ENCRYPTION_KEY}" \
    --wallet-storage-config "{\"url\":\"${POSTGRESQL_HOST}:5432\",\"max_connections\":5, \"wallet_scheme\":\"${TRACTION_ACAPY_WALLET_SCHEME}\"}" \
    --wallet-storage-creds "{\"account\":\"${POSTGRESQL_USER}\",\"password\":\"${POSTGRESQL_PASSWORD}\",\"admin_account\":\"${POSTGRESQL_USER}\",\"admin_password\":\"${POSTGRESQL_PASSWORD}\"}" \
    --admin "0.0.0.0" ${TRACTION_ACAPY_ADMIN_PORT} \
    --plugin traction_plugins.traction_innkeeper.v1_0 \
    --plugin basicmessage_storage.v1_0 \
    --plugin connection_update.v1_0 \
    --plugin multitenant_provider.v1_0 \
    --plugin rpc.v1_0
