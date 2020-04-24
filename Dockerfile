FROM debian:10-slim
LABEL maintainer="Philip Beelmann <beelmann@geofabrik.de>"

RUN apt-get update && apt-get install -y \
    apache2 \
    libmapnik3.0 \
    mapnik-utils \
    libjson-perl \
    libipc-sharelite-perl \
    libgd-perl \
    fonts-noto-cjk \
    fonts-noto-hinted \
    fonts-noto-unhinted \
    ttf-unifont \
    patch \
    nano \
    sudo \
    unzip \
    git \
    wget \
    curl \
    npm \
    python3 \
    python3-distutils

COPY debs /tmp/debs
RUN dpkg -i /tmp/debs/*deb 

COPY slippymap.html style.css /var/www/html/osm/
COPY tileserver_site.conf /etc/apache2/sites-available/
COPY tirex.conf.patch mapnik.conf.patch /tmp/


RUN \
# tirex config
    patch -l /etc/tirex/tirex.conf < /tmp/tirex.conf.patch \
 && patch -l /etc/tirex/renderer/mapnik.conf < /tmp/mapnik.conf.patch \
 && mkdir -p /srv; cd /srv \
 && rm -rf /var/lib/mod_tile \
 && ln -s /var/lib/tirex/tiles /var/lib/mod_tile \
 && chown tirex:tirex -R /var/lib/tirex/tiles/ 

## get map styles and resources
RUN \
# osm-bright
 mkdir -p /srv; cd /srv \
 && git clone https://github.com/mapbox/osm-bright.git \
 && cd osm-bright/ \
 && git remote add rory https://github.com/rory/osm-bright.git \
 && git fetch rory \
 && git checkout rory/master \
# osm-bright - get-shapefiles
 && mkdir shp; cd shp \
 && wget https://osmdata.openstreetmap.de/download/simplified-land-polygons-complete-3857.zip \
 && unzip simplified-land-polygons-complete-3857.zip \
 && wget https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip \
 && unzip land-polygons-split-3857.zip \
 && wget http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.4.0/cultural/10m-populated-places-simple.zip \
 && mkdir 10m-populated-places-simple; cd 10m-populated-places-simple; unzip ../10m-populated-places-simple.zip \
# openstreetmap-carto
 && mkdir -p /srv; cd /srv \
 && git clone https://github.com/gravitystorm/openstreetmap-carto \
 && cd openstreetmap-carto \
 && scripts/get-shapefiles.py \
# create tile directories
 && install -d -o tirex -g tirex /var/lib/tirex/tiles/osmbright/ \
 && install -d -o tirex -g tirex /var/lib/tirex/tiles/osmcarto/

COPY osmbright_configure.py /srv/osm-bright/configure.py
COPY osmcarto_project.mml /srv/openstreetmap-carto/project.mml
COPY osmbright.conf osmcarto.conf /etc/tirex/renderer/mapnik/

RUN cd /srv \
# install carto
 && git clone https://github.com/mapbox/carto.git \
 && cd carto; git checkout v1.2.0 \
 && npm install -g carto \
# osm-bright style
 && cd /srv/osm-bright \
 && ./make.py \
 && cd OSMBright; carto project.mml > project.xml \
# osm-carto style
 && cd /srv/openstreetmap-carto; carto project.mml > project.xml


EXPOSE 80

COPY ./run.sh /usr/local/bin
ENTRYPOINT ["usr/local/bin/run.sh"]

