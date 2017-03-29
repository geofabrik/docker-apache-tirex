# Docker apache webserver with tirex tile rendering system

This container sets up an apache webserver and the tirex tile rendering system.
Currently osmbright and openstreetmap-carto styles are supported.

# usage
* download docker-compose.yml from this repository
* ```mkdir import && mkdir osmbright && mkdir osmcarto```
* place the OpenStreetMap XML files ```*.osm``` into the folder ```./import```
* place prerendered tiles into the directories ```./osmbright``` and ```./osmcarto```
* run ```docker-compose up```
* open your browser http://<docker-ip>:8081/osm/slippymap.html

# good to know
It expects a postgres database with postgis extension and imported OpenStreetMap data.
For now the following credentials are fixed:
* host = 'postgis' (link your postgis-container as 'postgis' to this container and it should work)
* port = '5432'
* user = 'postgres'
* db   = 'gis'

* currently the shapefiles for countryborders etc. are inside the image and *not* downloaded extra

# credits
The creation of this Open Source Docker container was sponsored by Siemens AG (Building Technologies Division).
