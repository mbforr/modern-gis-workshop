docker pull osgeo/gdal

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogrinfo -so -al Users/mattforrest/Desktop/modern-gis-workshop/data/BuildingFootprints.geojson

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogr2ogr -f 'Parquet' Users/mattforrest/Desktop/modern-gis-workshop/data/footprints.parquet \
Users/mattforrest/Desktop/modern-gis-workshop/data/BuildingFootprints.geojson

# Open Colab notebook for speed comparison https://colab.research.google.com/drive/1tMwNR3j0UDkZPLHd3Dx4g7x2CUkdEJdJ#scrollTo=PUY1U-loaA6u

docker run --rm -v //Users:/Users/ osgeo/gdal \
ogr2ogr -f 'Parquet' Users/mattforrest/Desktop/modern-gis-workshop/data/sea_rise.parquet \
Users/mattforrest/Desktop/modern-gis-workshop/data/sea_rise.geojson
