docker pull osgeo/gdal

docker run --rm -v //Users:/Users osgeo/gdal \
--network="host" ogrinfo -so -al /Users/mattforrest/Documents/modern-gis-workshop/data/BuildingFootprints.geojson

ogr2ogr -f 'Parquet' data/footprints.parquet data/BuildingFootprints.geojson

# Open Colab notebook for speed comparison https://colab.research.google.com/drive/1tMwNR3j0UDkZPLHd3Dx4g7x2CUkdEJdJ#scrollTo=PUY1U-loaA6u

ogr2ogr -f 'Parquet' data/sea_rise.parquet data/sea_rise.geojson
