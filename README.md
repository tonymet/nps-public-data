# nps-public-data
Make [US National Park Service (NPS) API](https://www.nps.gov/subjects/developer/api-documentation.htm) data more accessible.  Query Park Info, Activities, Events, Multimedia, places &amp; more

## Demo
<img width="867" alt="image" src="https://github.com/tonymet/nps-public-data/assets/397995/e46ca93f-134b-4eac-8387-65ac79fa9c2e">

## Accessing nps-public-data on Google Bigquery
Visit the [BigQuery Console for nps-public-data](https://console.cloud.google.com/bigquery?hl=en&project=nps-public-data&ws=!1m4!1m3!3m2!1snps-public-data!2snps_public_data) 

See [Google's Docs for Accessing Public Data](https://cloud.google.com/bigquery/public-data/) for details on how to use the console, authenticate and issue queries. 

## What Data is Available
* activities
* activities/parks
* alerts
* amenities
* amenities/parksplaces
* amenities/parksvisitorcenters
* articles
* campgrounds
* events
* feespasses
* lessonplans
* multimedia/audio
* multimedia/galleries
* multimedia/galleries/assets
* multimedia/videos
* newsreleases
* parkinglots
* parks
* passportstamplocations
* places
* roadevents
* thingstodo
* topics
* topics/parks
* tours
* visitorcenters
* webcams

## What Data is In Progress
* multimedia/audio -- working on string encoding issues
* roadevents -- this API is not yet available from NPS
* mapdata/parkboundaries -- this api requires iterating over each park (sitecode) . 

## Data Freshness
* Currently data is refreshed *weekly*
* We are working to update tables with frequent changes weekly and later in real-time

## Next Steps
* Add coverage checks
* Improve realtime updates
* Work with NPS to make the dataset official. 

## Feedback & Issues
Please share your use-cases & issues using [Github Issues](https://github.com/tonymet/nps-public-data/issues) 
