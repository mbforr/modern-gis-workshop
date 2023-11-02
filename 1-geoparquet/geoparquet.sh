# First run the below command to pull GDAL via Docker

docker pull osgeo/gdal

# Make sure to download the data in the README and put it in the /data folder

# This will run a command to get info about the Building Footprints GeoJSON data

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogrinfo -so -al Users/mattforrest/Desktop/modern-gis-workshop/data/BuildingFootprints.geojson

# Here we turn the GeoJSON into Geoparquet, notice the size differeve

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogr2ogr -f 'Parquet' Users/mattforrest/Desktop/modern-gis-workshop/data/footprints.parquet \
Users/mattforrest/Desktop/modern-gis-workshop/data/BuildingFootprints.geojson

# Open Colab notebook for speed comparison if you want, you will need to upload the files again if you want to run it yourself
# https://colab.research.google.com/drive/1tMwNR3j0UDkZPLHd3Dx4g7x2CUkdEJdJ#scrollTo=PUY1U-loaA6u

# Turn the sea rise data into Parquet as well

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogr2ogr -f 'Parquet' Users/mattforrest/Desktop/modern-gis-workshop/data/sea_rise.parquet \
Users/mattforrest/Desktop/modern-gis-workshop/data/sea_rise.geojson
