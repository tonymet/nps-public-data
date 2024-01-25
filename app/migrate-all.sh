#!/bin/bash
for endpoint in $ENDPOINTS; do
    echo "START Migrating endpoint: $endpoint"
    bash migrate-table.sh $endpoint
    echo "END Migrating endpoint: $endpoint"
done