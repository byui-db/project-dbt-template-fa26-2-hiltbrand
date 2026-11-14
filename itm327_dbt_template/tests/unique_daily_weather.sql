SELECT
    CITY,
    DATE,
    COUNT(*) AS ROW_COUNT
FROM {{ ref('fct_daily_weather') }}
GROUP BY
    CITY,
    DATE
HAVING COUNT(*) > 1