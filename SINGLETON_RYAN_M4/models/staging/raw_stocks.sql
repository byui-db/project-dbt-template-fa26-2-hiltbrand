-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_STOCKS)
select
    trim(upper(symbol)) as symbol,
    try_to_date(trade_date) as trade_date,
    open::float as open,
    high::float as high,
    low::float as low,
    close::float as close,
    volume::number(38,0) as volume
from {{ source('snowbearair', 'STOCKS_MONGO_SINGLETON_R') }}
where symbol is not null
  and volume > 0 -- WBD had a 0 volume day on 10/6
qualify row_number() over (partition by symbol, trade_date order by trade_date desc) = 1
