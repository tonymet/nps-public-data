# nps-public-data
Make US National Park Service (NPS) API data more accessible.  Query Park Info, Activities, Events, Multimedia, places &amp; more

## Demo
<img width="867" alt="image" src="https://github.com/tonymet/nps-public-data/assets/397995/e46ca93f-134b-4eac-8387-65ac79fa9c2e">

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

## Data Freshness
* Currently data is refreshed monthly
* We are working to update tables with frequent changes weekly and later in real-time

## Feedback & Issues
Please share your use-cases & issues using [Github Issues](https://github.com/tonymet/nps-public-data/issues) 
