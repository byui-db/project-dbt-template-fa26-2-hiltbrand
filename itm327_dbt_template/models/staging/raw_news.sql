-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_NEWS)
select 
    id::VARCHAR AS id,
    category::VARCHAR as category,
    headline::VARCHAR AS headline,
    datetime::TIMESTAMP AS datetime,
    image::VARCHAR AS img,
    source::VARCHAR as source,
    summary::VARCHAR as summary,
    TRIM(UPPER(related))::VARCHAR AS symbol,
    url::VARCHAR as url,
from {{ source('snowbearair', 'NEWS_DAG_SHAW_A') }}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id
    ORDER BY datetime DESC
) = 1