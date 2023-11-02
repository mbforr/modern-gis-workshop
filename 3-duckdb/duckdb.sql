-- Starts the DuckDB instance

duckdb

-- This will start the HTTPFS extension that 

install httpfs;
load httpfs;

-- Select data from our builiding footprints GeoParquet file

select * from 'data/footprints.parquet' limit 10;

-- Select data using the DuckDB shorthand method

from 'data/footprints.parquet' limit 10;

-- Describe the table similar to Pandas

describe select * from 'data/footprints.parquet' limit 10;

-- The below file names will change based on the date they are updated
-- For example StormEvents_locations-ftp_v1.0_d2021_c20231017 the digit at the end represent the date 20231017
-- Refer to https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/ to find the up to date files

select * from read_csv('https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_locations-ftp_v1.0_d2021_c20231017.csv.gz', auto_detect=true);

-- The same as above but with two files

select * from read_csv(['https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2021_c20231017.csv.gz', 'https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2022_c20231017.csv.gz'], auto_detect=true);

-- Exit DuckDB using CTRL + C

-- This command will start DuckDB and create a database file named db.ddb

duckdb db.ddb 

-- Turn on the timer

.timer on

-- Install the Free Text Search extension

install fts;
load fts;

-- This time we will create a table in the database file from our two remote files

create table events as 
select * from read_csv(['https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2021_c20231017.csv.gz', 'https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2022_c20231017.csv.gz'], auto_detect=true);

-- This creates a free text search index on our new "events" table on the EVENT_NARRATIVE and EPISODE_NARRATIVE columns

PRAGMA create_fts_index('events', 'EVENT_NARRATIVE', 'EPISODE_NARRATIVE');

-- This will find rows that match the word "flooding" in the EVENT_NARRATIVE column and have scores

SELECT EVENT_NARRATIVE, score
FROM (SELECT *, fts_main_events.match_bm25(EVENT_NARRATIVE, 'flooding') AS score
      FROM events) sq
WHERE score IS NOT NULL
ORDER BY score DESC;

-- This will find rows that match the word "flash flood" in the EVENT_NARRATIVE column and have scores
-- Notice how many of the results don't have the words "flash" or "flood"

SELECT EVENT_NARRATIVE, score
FROM (SELECT *, fts_main_events.match_bm25(EVENT_NARRATIVE, 'flash flood') AS score
      FROM events) sq
WHERE score IS NOT NULL
ORDER BY score DESC;

-- Install and load the spatial extension

install spatial;
load spatial;

-- Reading a GeoJSON and creating a geometry from 10 rows

select *, ST_GeomFromWKB(wkb_geometry) as geom from st_read('data/BuildingFootprints.geojson') limit 10;

-- Reading a GeoParquet and creating a geometry for the entire dataset, notice the speed increase

select *, ST_GeomFromWKB(geometry) as geom from 'data/footprints.parquet';

-- Create a table 

create table BuildingFootprints as 
select *, ST_GeomFromWKB(geometry) as geom, CAST(ST_Centroid(ST_GeomFromWKB(geometry)) AS POINT_2D) as geom2d from '../data/footprints.parquet';

-- This will run a cross join to find the distance between every building in a which has 10,000 buildings and
-- table b which has 1,000 buildings, resulting in a table with 10 million rows
-- Note: this uses the traditional geometry data type 

with a as (select mpluto_bbl as id, geom from BuildingFootprints limit 10000),
b as (select mpluto_bbl as id, geom from BuildingFootprints limit 1000 offset 20000)
select st_distance(a.geom, b.geom)
from a, b;

-- Now we do the same with the DuckDB native 2D geometry where you should see a significant performance improvement

with a as (select mpluto_bbl as id, geom2d as geom from BuildingFootprints limit 10000),
b as (select mpluto_bbl as id, geom2d as geom from BuildingFootprints limit 1000 offset 20000)
select st_distance(a.geom, b.geom)
from a, b;

-- Install and load the PostgreSQL connection extension

install postgres;
load postgres;

CALL postgres_attach('dbname=gis user=docker password=docker port=25432 host=127.0.0.1', source_schema='public');

-- Show available tables in the database

PRAGMA show_tables;

-- This just selects a table but you can actually use this with other data like files

SELECT * FROM postgres_scan('dbname=gis user=docker password=docker port=25432 host=127.0.0.1', 'public', 'sea_rise');



