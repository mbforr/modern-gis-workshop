
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='external') }}

select 
*,
st_point(BEGIN_LON, BEGIN_LAT) as point,
cast(st_point(BEGIN_LON, BEGIN_LAT) as POINT_2D) as point2d,
st_aswkb(st_point(BEGIN_LON, BEGIN_LAT)) as geom
from {{ source('external_source', 'd2023_c20230918')}}

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
