#!/bin/bash

echo "-------------------------------------------------------"
echo "Initializing ACA-Py startup configuration..."
echo "-------------------------------------------------------"

# --- EC2 environment setup ---
if [[ "${TRACTION_ENV}" == "ec2" ]]; then
    echo "Using EC2 endpoint configuration..."
    export ACAPY_ENDPOINT="https://${EC2_PUBLIC_DNS}/traction"
else
    echo "Using default local endpoint configuration..."
    export ACAPY_ENDPOINT="http://traction-agent:${TRACTION_ACAPY_HTTP_PORT}"
fi

echo "-------------------------------------------------------"
echo "Fetched endpoint: [$ACAPY_ENDPOINT]"
echo "Starting ACA-Py agent..."
echo "-------------------------------------------------------"

# --- Start ACA-Py ---
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
