duckdb

install httpfs;
load httpfs;

select * from 'data/footprints.parquet' limit 10;

from 'data/footprints.parquet' limit 10;

describe select * from 'data/footprints.parquet' limit 10;

select * from read_csv('https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_locations-ftp_v1.0_d2021_c20230918.csv.gz', auto_detect=true);

select * from read_csv(['https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2021_c20230918.csv.gz', 'https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2022_c20230918.csv.gz'], auto_detect=true);

-- Exit DuckDB

duckdb iguide.ddb

install fts;
load fts;

create table events as 
select * from read_csv(['https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2021_c20230918.csv.gz', 'https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2022_c20230918.csv.gz'], auto_detect=true);

PRAGMA create_fts_index('events', 'EVENT_NARRATIVE', 'EPISODE_NARRATIVE');

SELECT EVENT_NARRATIVE, score
FROM (SELECT *, fts_main_events.match_bm25(EVENT_NARRATIVE, 'flooding') AS score
      FROM events) sq
WHERE score IS NOT NULL
ORDER BY score DESC;

SELECT EVENT_NARRATIVE, score
FROM (SELECT *, fts_main_events.match_bm25(EVENT_NARRATIVE, 'flash flood') AS score
      FROM events) sq
WHERE score IS NOT NULL
ORDER BY score DESC;

install spatial;
load spatial;

select *, ST_GeomFromWKB(wkb_geometry) as geom from st_read('data/BuildingFootprints.geojson') limit 10;

create table BuildingFootprints as 
select *, ST_GeomFromWKB(wkb_geometry) as geom, CAST(ST_Centroid(ST_GeomFromWKB(wkb_geometry)) AS POINT_2D) as geom2d from st_read('data/BuildingFootprints.geojson');

install postgres;
load postgres;

CALL postgres_attach('dbname=gis user=docker password=docker port=25432 host=127.0.0.1', source_schema='public');

PRAGMA show_tables;

SELECT * FROM postgres_scan('dbname=gis user=docker password=docker port=25432 host=127.0.0.1', 'public', 'sea_rise');



