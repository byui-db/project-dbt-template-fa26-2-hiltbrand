-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_WEATHER)
-- Milestone 4: weather staging model

WITH cleaned AS (
    SELECT 
        TRY_CAST("date" AS DATE) AS date,
        TRIM(UPPER("city")) AS city, --string standardization 
        "max_temp"::FLOAT AS max_temp, --explicit type casting
        "min_temp"::FLOAT AS min_temp,
        COALESCE("precip", 0)::FLOAT AS precip, --null handling 
        COALESCE("max_wind", 0)::FLOAT AS max_wind

from {{ source('snowbearair', 'RITTA_ALFREDO_M1') }}
)

SELECT 
    date,
    city,
    max_temp,
    min_temp,
    precip,
    max_wind
FROM cleaned

WHERE date IS NOT NULL
AND city IS NOT NULL
AND city != ''

--deduplication
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY city, date
    ORDER BY date DESC
    
) = 1
