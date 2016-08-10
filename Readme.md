# Docker apache webserver with tirex tile rendering system

This container sets up an apache webserver and the tirex tile rendering system.
Currently osmbright and openstreetmap-carto styles are supported.

# good to know

It expects a postgres database with postgis extension and imported OpenStreetMap data.
For now the following credentials are fixed:
* host = 'postgis' (link your postgis-container as 'postgis' to this container and it should work)
* port = '5432'
* user = 'postgres'
* db   = 'gis'

* currently the shapefiles for countryborders etc. are inside the image and *not* downloaded extra

# usage

* e. g. use docker-compose to link a postgis container to use this container

# credits
The creation of this Open Source Docker container was sponsored by Siemens AG (Building Technologies Division).
