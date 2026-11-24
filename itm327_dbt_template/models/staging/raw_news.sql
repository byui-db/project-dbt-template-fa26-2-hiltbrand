-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_NEWS)
--Milestone 4: news model
WITH cleaned AS (
    SELECT
    --type casting
    id::VARCHAR AS id,
    headline::VARCHAR AS headline,
    datetime::TIMESTAMP AS datetime,
    category::VARCHAR AS category,
    source::VARCHAR AS source,
    summary::VARCHAR AS summary,
    url::VARCHAR AS url,
    image::VARCHAR AS image,

    --string standardization 
    TRIM(UPPER(related::VARCHAR)) AS related

       
from {{ source('snowbearair', 'NEWS_RITTA_A') }}
)

SELECT
    id,
    headline,
    datetime,
    category,
    source,
    summary,
    url,
    image,
    related
FROM cleaned

--remove records with missing values
WHERE id IS NOT NULL
AND headline IS NOT NULL
AND datetime IS NOT NULL
AND related IS NOT NULL
AND related != ''

--deduplication
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id
    ORDER BY datetime DESC
) = 1