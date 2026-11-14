SELECT
    SYMBOL,
    TRADE_DATE,
    COUNT(*) AS ROW_COUNT
FROM {{ ref('fct_daily_stocks') }}
GROUP BY
    SYMBOL,
    TRADE_DATE
HAVING COUNT(*) > 1