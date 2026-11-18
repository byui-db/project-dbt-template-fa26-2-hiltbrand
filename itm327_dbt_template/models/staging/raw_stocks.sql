-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_STOCKS)
select 
    datetime::DATE AS trade_date,
    opening_price::FLOAT AS open,
    high_price::FLOAT AS high,
    low_price::FLOAT AS low,
    closing_price::FLOAT AS close,
    COALESCE(volume::NUMBER(38,0), 0) AS volume,
    -- 2. Standardize strings
    TRIM(UPPER(ticker))::VARCHAR AS symbol
from {{ source('snowbearair', 'STOCK_DATA_DAG_SHAW_A') }}
WHERE volume::NUMBER(38,0) > 0

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY symbol, datetime
    ORDER BY datetime DESC
) = 1


