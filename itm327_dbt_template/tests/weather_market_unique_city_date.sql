SELECT
    CITY,
    DATE,
    COUNT(*) AS ROW_COUNT

FROM {{ ref('weather_market_conditions') }}

GROUP BY
    CITY,
    DATE

HAVING COUNT(*) > 1