ogr2ogr \
    -f PostgreSQL PG:"host=localhost user=docker password=docker \
    dbname=gis port=25432" data/footprints.parquet \
    -nln footprints -lco GEOMETRY_NAME=geometry

ogr2ogr \
    -f PostgreSQL PG:"host=localhost user=docker password=docker \
    dbname=gis port=25432" data/sea_rise.parquet \
    -nln sea_rise -lco GEOMETRY_NAME=geometry

gdalinfo /vsizip/data/NYC_DEM_1ft_Int.zip/DEM_LiDAR_1ft_2010_Improved_NYC_int.tif

gdalwarp -te -74.027897 40.664643 -73.958733 40.760965 -t_srs EPSG:4326 /vsizip/data/NYC_DEM_1ft_Int.zip/DEM_LiDAR_1ft_2010_Improved_NYC_int.tif data/clipped-dem.tif

# Refer to README to install another verion of PostGIS

docker pull postgis/postgis:15-master

docker run --name mini-postgis -p 35432:5432 --network="host" -v /Users/mattforrest/Documents/modern-gis-workshop/data:/mnt/mydata -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password -d postgis/postgis:15-master

docker container exec -it mini-postgis bash

raster2pgsql -s 4269 -I -C -M mnt/mydata/clipped-dem.tif -t 128x128 -F nyc_dem | psql -d gis -h 127.0.0.1 -p 25432 -U docker -W

# https://stacindex.org/catalogs/world-bank-light-every-night#/

raster2pgsql \
  -s 990000 \
  -t 256x256 \
  -I \
  -R \
  /vsicurl/https://globalnightlight.s3.amazonaws.com/npp_202012/SVDNB_npp_d20201201_t0440375_e0446179_b47128_c20201201084618286594_nobc_ops.rade9.co.tif \
  -F nighttime_light \
  | psql -d gis -h 127.0.0.1 -p 25432 -U docker -W