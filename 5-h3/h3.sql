-- You can run this query in pgAdmin to create an approximate elevation file with H3 cells

-- Make sure to run:

-- create extension h3;
-- create extension h3_postgis;

create table nyc_elev as select
h3_lat_lng_to_cell(a.geom, 15) as h3, avg(val) as avg_ele
from (
select
r.*
from
nyc_dem,
) a
lateral ST_PixelAsCentroids(rast, 1) as r
group by 1
