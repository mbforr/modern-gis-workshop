# Make sure to navigate into this folder and run the below command which will start the Docker version of PostGIS

docker-compose up -d

# Next we load some data into PostGIS using GDAL

docker run --rm -v //Users:/Users/ --network="host" osgeo/gdal \
ogr2ogr \
    -f PostgreSQL PG:"host=localhost user=docker password=docker \
    dbname=gis port=25432" data/footprints.parquet \
    -nln footprints -lco GEOMETRY_NAME=geometry

docker run --rm -v //Users:/Users/ --network="host" osgeo/gdal \
ogr2ogr \
    -f PostgreSQL PG:"host=localhost user=docker password=docker \
    dbname=gis port=25432" Users/mattforrest/Desktop/modern-gis-workshop/data/sea_rise.parquet \
    -nln sea_rise -lco GEOMETRY_NAME=geometry

# You don't need to run the next two commands if you are using the smaller clipped DEM, which is recommended if you have storage constraints on your machine

docker run --rm -v //Users:/Users/ --network="host" osgeo/gdal \
gdalinfo /vsizip/Users/mattforrest/Desktop/modern-gis-workshop/data/NYC_DEM_1ft_Int.zip/DEM_LiDAR_1ft_2010_Improved_NYC_int.tif

docker run --rm -v //Users:/Users/ --network="host" osgeo/gdal \
gdalwarp -te -74.027897 40.664643 -73.958733 40.760965 -t_srs EPSG:4326 \
/vsizip/Users/mattforrest/Desktop/modern-gis-workshop/data/NYC_DEM_1ft_Int.zip/DEM_LiDAR_1ft_2010_Improved_NYC_int.tif \
Users/mattforrest/Desktop/modern-gis-workshop/data/clipped-dem.tif

# Refer to README to install another verion of PostGIS to import our raster data

docker pull postgis/postgis:15-master

# This will run the second "mini-postgis" container we created 

docker run --name mini-postgis -p 35432:5432 --network="host" -v /Users/mattforrest/Documents/modern-gis-workshop/data:/mnt/mydata -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password -d postgis/postgis:15-master

# This will open a terminal connection within the "mini-postgis" Docker container for us to run commands

docker container exec -it mini-postgis bash

# This imports the clipped raster into PostGIS

raster2pgsql -s 4269 -I -C -M mnt/mydata/clipped-dem.tif -t 128x128 -F nyc_dem | psql -d gis -h 127.0.0.1 -p 25432 -U docker -W


# If you want to do the same for a cloud example from the Spatio-temporal Asset Catalog 

# https://stacindex.org/catalogs/world-bank-light-every-night#/

raster2pgsql \
  -s 990000 \
  -t 256x256 \
  -I \
  -R \
  /vsicurl/https://globalnightlight.s3.amazonaws.com/npp_202012/SVDNB_npp_d20201201_t0440375_e0446179_b47128_c20201201084618286594_nobc_ops.rade9.co.tif \
  -F nighttime_light \
  | psql -d gis -h 127.0.0.1 -p 25432 -U docker -W