select
    date::date as date,
    initcap(trim(city)) as city,
    max_temp::float as max_temp,
    min_temp::float as min_temp,
    coalesce(precip, 0) as precip,
    coalesce(max_wind, 0) as max_wind
from {{ source('snowbearair', 'WEATHER_BARNETT_A') }}
where city is not null
qualify row_number() over (partition by city, date order by date desc) = 1
