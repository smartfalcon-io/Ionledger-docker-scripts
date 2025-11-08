

set -e  

# export EC2_PUBLIC_DNS="ec2-13-126-137-120.ap-south-1.compute.amazonaws.com"
# export EC2_PUBLIC_IP="13.126.137.120"

if [[ "${TRACTION_ENV}" == "ec2" ]]; then
    echo "Using EC2 endpoint configuration..."

    EC2_ENDPOINT="https://${EC2_PUBLIC_DNS}/traction"

    # Mimic ngrok wait loop (optional, ensures endpoint variable is initialized)
    while [ -z "$EC2_ENDPOINT" ] || [ "$EC2_ENDPOINT" = "null" ]; do
        echo "EC2 endpoint not ready, sleeping 5 seconds..."
        sleep 5
    done

    # export ACAPY_ENDPOINT="$EC2_ENDPOINT"
    export ACAPY_ENDPOINT="http://traction-agent:8030"
fi

echo "-------------------------------------------------------"
echo "Fetched endpoint: ${ACAPY_ENDPOINT}"
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
    --plugin rpc.v1_0 \
