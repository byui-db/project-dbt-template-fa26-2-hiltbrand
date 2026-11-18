-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_WEATHER)
select 
    city::VARCHAR AS city,
time::TIMESTAMP AS date,
COALESCE(precipitation_sum, 0)::FLOAT AS precip,
COALESCE(max_temp, 0)::FLOAT AS max_temp,
COALESCE(min_temp, 0)::FLOAT AS min_temp,
COALESCE(wind_speed, 0)::FLOAT AS wind_speed,
COALESCE(lift, 0)::FLOAT AS lift,
COALESCE(wind_gust, 0)::FLOAT AS wind_gust,
COALESCE(DOMINANT_WIND_DIR, 0)::FLOAT AS dom_wind_dir,
sunrise::TIMESTAMP AS sunrise,
sunset::TIMESTAMP AS sunset
from {{ source('snowbearair', 'WEATHER_DAG_AS') }}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY city, date
    ORDER BY date DESC
) = 1
