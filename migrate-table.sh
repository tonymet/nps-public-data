#!/bin/bash

# get arg
# set API key
# download file via curl
# transform to jq
# bq load

LIMIT=50000
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

bq load --autodetect --source_format NEWLINE_DELIMITED_JSON  nps_public_data.$table "$jsonl"
if [ $? -ne 0 ]; then
    echo "bq error"
    exit 
fi 


# curl -X GET "https://developer.nps.gov/api/v1/places?api_key=$API_KEY&limit=16000" -H "accept: application/json" > people.json
# curl -X GET "https://developer.nps.gov/api/v1/feespasses?api_key=$API_KEY&limit=500" -H "accept: application/json" > feespasses.json
# curl -X GET "https://developer.nps.gov/api/v1/campgrounds?api_key=$API_KEY&limit=650" -H "accept: application/json" > campgrounds.json
# curl -X GET "https://developer.nps.gov/api/v1/newsreleases?api_key=$API_KEY&limit=1500" -H "accept: application/json" > newsreleases.json
# curl -X GET "https://developer.nps.gov/api/v1/events?api_key=$API_KEY&limit=650" -H "accept: application/json" > events.json
# curl -X GET "https://developer.nps.gov/api/v1/events?api_key=$API_KEY&limit=650" -H "accept: application/json" -o/dev/null
# curl -v  -X GET "https://developer.nps.gov/api/v1/events?api_key=$API_KEY&limit=650" -H "accept: application/json" -o/dev/null
# curl -v  -X GET "https://developer.nps.gov/api/v1/events?api_key=$API_KEY&limit=650" -H "accept: application/json"  > events2.json
# curl -X GET "https://developer.nps.gov/api/v1/visitorcenters?api_key=$API_KEY&limit=700" -H "accept: application/json" > visitorcenters.json
# curl -X GET "https://developer.nps.gov/api/v1/roadevents?api_key=$API_KEY" -H "accept: application/json"
# curl -v -X GET "https://developer.nps.gov/api/v1/roadevents?api_key=$API_KEY" -H "accept: application/json"
# curl -X GET "https://developer.nps.gov/api/v1/webcams?api_key=$API_KEY&limit=250" -H "accept: application/json" > webcams.json
# curl -X GET "https://developer.nps.gov/api/v1/alerts?api_key=$API_KEY&limit=750" -H "accept: application/json" > alerts.json
# curl -X GET "https://developer.nps.gov/api/v1/activities/parks?id=1&api_key=$API_KEY&limit=50" -H "accept: application/json" > activities__parks.json
# curl -X GET "https://developer.nps.gov/api/v1/parkinglots?api_key=$API_KEY&limit=510" -H "accept: application/json" > parkinglots.json
# curl -X GET "https://developer.nps.gov/api/v1/passportstamplocations?api_key=$API_KEY&limit=1050" -H "accept: application/json" > passportstamplocations.json
# curl -X GET "https://developer.nps.gov/api/v1/thingstodo?api_key=$API_KEY&limit=3300" -H "accept: application/json"
# curl -X GET "https://developer.nps.gov/api/v1/thingstodo?api_key=$API_KEY&limit=3300" -H "accept: application/json" > thingstodo.json
# curl -X GET "https://developer.nps.gov/api/v1/tours?api_key=$API_KEY&limit=620" -H "accept: application/json" > tours.json
# curl -X GET "https://developer.nps.gov/api/v1/topics?api_key=$API_KEY&limit=100" -H "accept: application/json" > topics.json
# curl -X GET "https://developer.nps.gov/api/v1/amenities?api_key=$API_KEY&limit=200" -H "accept: application/json" > amenities.json
# curl -X GET "https://developer.nps.gov/api/v1/amenities/parksplaces?api_key=$API_KEY&limit=150" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/amenities/parksvisitorcenters?api_key=$API_KEY&limit=500" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/topics/parks?api_key=$API_KEY&limit=500" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/places?api_key=$API_KEY&limit=18000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/activities?api_key=$API_KEY&limit=100" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/amenities/parksplaces?api_key=$API_KEY&limit=500" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/amenities/parksvisitorcenters?api_key=$API_KEY&limit=500" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/articles&limit=50000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/articles&limit=50000&api_key=$API_KEY" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/articles?api_key=$API_KEY&limit=50000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/lessonplans?api_key=$API_KEY&limit=50000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/multimedia/audio?api_key=$API_KEY&limit=50000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/multimedia/galleries?api_key=$API_KEY&limit=50000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/multimedia/galleries/assets?api_key=$API_KEY&limit=200000" -H "accept: application/json" > $table.json
# curl -X GET "https://developer.nps.gov/api/v1/multimedia/videos?api_key=$API_KEY&limit=50000" -H "accept: application/json" > $table.json