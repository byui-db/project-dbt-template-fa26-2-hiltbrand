-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_NEWS)
select
    id::varchar as id,
    try_to_timestamp(published_at) as published_at,
    try_to_date(file_date) as file_date,
    trim(upper(related)) as related,
    trim(headline) as headline,
    lower(trim(category)) as category,
    trim(source) as source,
    coalesce(trim(summary), '') as summary,
    trim(url) as url
from {{ source('snowbearair', 'NEWS_SFTP_SINGLETON_R') }}
where id is not null
-- same article comes in once for every ticker its tagged to
qualify row_number() over (partition by id order by file_date, related) = 1
