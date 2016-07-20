#!/bin/bash
set -e
set -x

# # setup osm-bright
# cd /srv/osm-bright
# # applies settings from configure.py
# ./make.py
# cd OSMBright
# carto project.mml > project.xml
# 
# # setup osm-carto
# # settings in project.yaml
# cd /srv/openstreetmap-carto/scripts/; python yaml2mml.py
# carto /srv/openstreetmap-carto/project.mml > /srv/openstreetmap-carto/project.xml

service tirex-master start
service tirex-backend-manager start
/usr/sbin/apache2ctl -DFOREGROUND

