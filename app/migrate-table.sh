#!/bin/bash

# get arg
# set API key
# download file via curl
# transform to jq
# bq load

LIMIT=50000
TS=$(date +%Y-%m-%d-%H%M)
if [[ -z $API_KEY ]]; then
    echo "API_KEY is unset"
    exit 1
fi

mkdir -p data/jsonl
if [ $? -ne 0 ]; then
    echo "mkdir error: data/jsonl"
    exit 1
fi

if [[ -z $1 ]];then
    echo "usage: $0 TABLE"
    exit 1
fi
jq_transform='.data[]'

endpoint=$1
echo ENDPOINT=$endpoint
# set endpoint
table=${endpoint//\//__}
# jq_transform
case "$table" in
    amenities__parksplaces | amenities__parksvisitorcenters)
    jq_transform='.data[][]'
    ;;
    *)
    # use default
    ;;
esac

echo Downloading $endpoint into $table...
json="data/$table.json"
curl -s -f -X GET "https://developer.nps.gov/api/v1/$endpoint?api_key=$API_KEY&limit=$LIMIT" -H "accept: application/json" > "$json"
if [ $? -ne 0 ]; then
    echo "error: curl"
    exit 1
fi

json_size=$(du -sk "$json"|cut -f1)
if [ $json_size -le 200 ]; then
    echo "error: json filesize 0"
    exit 1
fi


jsonl="data/jsonl/$table.json"
echo "jq transform $endpoint into $jsonl"
jq -c "$jq_transform" data/"$table".json > "$jsonl"

if [ $? -ne 0 ]; then
    echo "error: jq transform endpoint = $endpoint, table=$table"
    exit 1
fi


jsonl_size=$(du -sk "$jsonl"|cut -f1)
if [ $jsonl_size -le 0 ]; then
    echo "error: jsonl size = 0 endpoint = $endpoint, table=$table"
    exit 1
fi

# collect metadata
jq -c "del(.data) * {jsonl_size: "$jsonl_size", json_size: "$json_size", endpoint: \"$endpoint\", table: \"$table\", ts: \"$TS\"}" data/$table.json >> data/jsonl/meta.json
bq load --headless -q --autodetect --source_format NEWLINE_DELIMITED_JSON  nps_public_data.$table_$TS  "$jsonl"
if [ $? -ne 0 ]; then
    echo "error: bq load. endpoint = $endpoint, table=$table"
    exit 1
fi
echo "removing table $table"
bq rm -f nps_public_data.$table
if [ $? -ne 0 ]; then
    echo "bq rm error. endpoint=$endpoint, table=$table  "
    exit 1
fi
# copy (move) table
echo "copy nps_public_data.$table_$TS to nps_public_data.$table"
bq cp nps_public_data.$table_$TS nps_public_data.$table
if [ $? -ne 0 ]; then
    echo "error: bq cp error table=$table"
    exit 1
fi
#drop TS table
echo "removing table $table_$TS"
bq rm -f nps_public_data.$table_$TS
if [ $? -ne 0 ]; then
    echo "bq rm error $table_$TS "
    exit 1
fi