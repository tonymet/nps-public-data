#!/bin/bash

# get arg
# set API key
# download file via curl
# transform to jq
# bq load

LIMIT=50000
STAMP=$(date +%Y-%m-%d-%H%M)
if [[ -z $API_KEY ]]; then
    echo "API_KEY is unset"
    exit 1
fi

if [[ -z $1 ]];then
    echo "usage: $0 TABLE"
    exit
fi
jq_transform='.data[]'

endpoint=$1
echo ENDPOINT=$endpoint
# set endpoint
table=${endpoint//\//__}
# jq_transform
case "$table" in
    amenities__parksplaces | amenities__parkvisitorcenters)
    jq_transform='.data[][]'
    ;;
    *)
    # use default
    ;;
esac

echo Downloading $endpoint into $table...
json="data/$table.json"
curl -f -X GET "https://developer.nps.gov/api/v1/$endpoint?api_key=$API_KEY&limit=$LIMIT" -H "accept: application/json" > "$json"
if [ $? -ne 0 ]; then
    echo "curl error"
    exit
fi

json_size=$(wc -c <"$json")
if [ $json_size -le 200 ]; then
    echo "error: json filesize 0"
    exit 1
fi

jsonl="data/jsonl/$table.json"
echo "jq transform $endpoint into $jsonl"
jq -c "$jq_transform" data/"$table".json > "$jsonl"

if [ $? -ne 0 ]; then
    echo "jq transform error"
    exit
fi

jsonl_size=$(wc -c <"$jsonl")
if [ $jsonl_size -le 0 ]; then
    echo "error: jsonl size = 0 "
    exit 1
fi

#bq load --autodetect --source_format NEWLINE_DELIMITED_JSON  nps_public_data.$table "$jsonl"
bq load --autodetect --source_format NEWLINE_DELIMITED_JSON  nps_public_data.$table_$STAMP  "$jsonl"
if [ $? -ne 0 ]; then
    echo "bq load error"
    exit
fi
echo "removing table $table"
bq rm -f nps_public_data.$table
if [ $? -ne 0 ]; then
    echo "bq rm error "
    exit
fi
# copy (move) table
echo "copy nps_public_data.$table_$STAMP to nps_public_data.$table"
bq cp nps_public_data.$table_$STAMP nps_public_data.$table
if [ $? -ne 0 ]; then
    echo "bq cp error "
    exit
fi
#drop stamp table
echo "removing table $table_$STAMP"
bq rm -f nps_public_data.$table_$STAMP
if [ $? -ne 0 ]; then
    echo "bq rm error $table_$STAMP "
    exit
fi