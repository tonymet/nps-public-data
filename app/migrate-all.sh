#!/bin/bash
for endpoint in $ENDPOINTS; do
    echo "START Migrating endpoint: $endpoint"
    bash migrate-table.sh $endpoint
    echo "END Migrating endpoint: $endpoint"
done

# save metadata
echo "uploading metadata to nps_public_data.meta"
bq load --autodetect --source_format NEWLINE_DELIMITED_JSON  nps_public_data.meta  "data/jsonl/meta.json"
if [ $? -ne 0 ]; then
    echo "error: bq load. endpoint = $endpoint, table=$table"
    exit 1
fi