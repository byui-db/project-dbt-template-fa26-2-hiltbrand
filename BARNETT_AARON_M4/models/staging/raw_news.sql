select
    id::varchar as id,
    datetime::timestamp as datetime,
    trim(upper(related)) as related,
    trim(headline) as headline,
    lower(trim(category)) as category,
    trim(source) as source,
    coalesce(trim(summary), '') as summary,
    trim(url) as url
from {{ source('snowbearair', 'NEWS_BARNETT_A') }}
where id is not null
qualify row_number() over (partition by id order by datetime desc) = 1
