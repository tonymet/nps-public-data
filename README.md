# nps-public-data
Make US National Park Service (NPS) API data more accessible.  Query Park Info, Activities, Events, Multimedia, places &amp; more

## Accessing nps-public-data on Google Bigquery
Visit the [BigQuery Console for nps-public-data](https://console.cloud.google.com/bigquery?hl=en&project=nps-public-data&ws=!1m4!1m3!3m2!1snps-public-data!2snps_public_data) 

See [Google's Docs for Accessing Public Data](https://cloud.google.com/bigquery/public-data/) for details on how to use the console, authenticate and issue queries. 

## What Data is Available
* activities
* activities__parks
* alerts
* amenities
* amenities__parks
* amenities__parkvisitorcenters
* articles
* campgrounds
* events
* feespasses
* lessonplans
* multimedia__galleries
* multimedia__galleries__assets
* newsreleases
* parkinglots
* parks
* passportstamplocations
* people
* places
* thingstodo
* topics
* topics__parks
* tours
* visitorcenters
* webcams

## What Data is In Progress
* multimedia__audio -- working on string encoding issues
* roadevents -- this API is not yet available from NPS
* mapdata/parkboundaries -- this api requires iterating over each park (sitecode) . 


