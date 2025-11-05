#!/bin/bash
set -e

if [[ "${TRACTION_ENV}" == "ec2" ]]; then
    echo "Using EC2 endpoint configuration..."
    EC2_ENDPOINT="https://${EC2_PUBLIC_DNS}"

    # Wait until endpoint is reachable
    until curl --silent --head $EC2_ENDPOINT | grep "200" >/dev/null; do
        echo "Waiting for ACAPY endpoint to be ready..."
        sleep 5
    done

    export ACAPY_ENDPOINT=$EC2_ENDPOINT
fi

echo "-------------------------------------------------------"
echo "Fetched endpoint: [$ACAPY_ENDPOINT]"
echo "Starting ACA-Py agent..."
echo "-------------------------------------------------------"

exec aca-py start \
    --auto-provision \
    --inbound-transport http "0.0.0.0" ${TRACTION_ACAPY_HTTP_PORT} \
    --outbound-transport http \
    --endpoint ${ACAPY_ENDPOINT} \
    --wallet-name "${TRACTION_ACAPY_WALLET_NAME}" \
    --wallet-key "${TRACTION_ACAPY_WALLET_ENCRYPTION_KEY}" \
    --wallet-storage-config "{\"url\":\"${POSTGRESQL_HOST}:5432\",\"max_connections\":5, \"wallet_scheme\":\"${TRACTION_ACAPY_WALLET_SCHEME}\"}" \
    --wallet-storage-creds "{\"account\":\"${POSTGRESQL_USER}\",\"password\":\"${POSTGRESQL_PASSWORD}\",\"admin_account\":\"${POSTGRESQL_USER}\",\"admin_password\":\"${POSTGRESQL_PASSWORD}\"}" \
    --admin "0.0.0.0" ${TRACTION_ACAPY_ADMIN_PORT} \
    --admin-api-key ${ACAPY_ADMIN_API_KEY} \
    --plugin multitenant_provider.v1_0 \
    --plugin traction_plugins.traction_innkeeper.v1_0 \
    --plugin basicmessage_storage.v1_0 \
    --plugin connections \
    --plugin connection_update.v1_0 \
    --plugin rpc.v1_0 \
    --plugin webvh
