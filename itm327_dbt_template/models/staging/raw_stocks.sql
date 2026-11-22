-- TODO: Update the source table name to match your prefix (e.g., SMITHJ_STOCKS)
--Milestone 4 stocks model

WITH cleaned AS (
    SELECT
        --type casting
        TRIM(UPPER(symbol::VARCHAR)) AS symbol,
        TRY_TO_TIMESTAMP_TZ(datetime::VARCHAR)::DATE AS trade_date,
        open::FLOAT AS open,
        high::FLOAT AS high,
        low::FLOAT AS low,
        close::FLOAT AS close,
        volume::NUMBER(38,0) AS volume
        
from {{ source('snowbearair', 'STOCKS_RITTA_A_M3') }}
)

SELECT
    symbol,
    trade_date,
    open,
    high,
    low,
    close,
    volume
FROM cleaned

--remove invalid keys
WHERE symbol IS NOT NULL
AND symbol != ''
AND trade_date IS NOT NULL

--deduplication 
QUALIFY ROW_NUMBER() OVER (
PARTITION BY symbol, trade_date
ORDER BY trade_date DESC
) = 1

