#!/bin/bash
for endpoint in $(cat endpoint-list.txt); do
    echo "START Migrating endpoint: $endpoint"
    echo bash migrate-table.sh $endpoint
    echo "END Migrating endpoint: $endpoint"
done