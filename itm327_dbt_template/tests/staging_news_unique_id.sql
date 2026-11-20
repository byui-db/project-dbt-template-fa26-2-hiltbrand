SELECT
    ID,
    COUNT(*) AS ROW_COUNT

FROM {{ ref('raw_news') }}

GROUP BY ID

HAVING COUNT(*) > 1