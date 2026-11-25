select
    trim(upper(symbol)) as symbol,
    datetime::date as trade_date,
    open::float as open,
    high::float as high,
    low::float as low,
    close::float as close,
    volume::number(38,0) as volume
from {{ source('snowbearair', 'STOCKS_BARNETT_A') }}
where symbol is not null
  and volume > 0
qualify row_number() over (partition by trim(upper(symbol)), datetime::date order by loaded_at desc, datetime desc) = 1
