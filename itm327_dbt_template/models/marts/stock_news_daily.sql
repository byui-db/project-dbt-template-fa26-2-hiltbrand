-- ============================================================
-- stock_news_daily
-- DA Mart: daily stock performance enriched with news coverage
-- Grain: SYMBOL + TRADE_DATE
-- Sources: {{ ref('fct_daily_stocks') }}, {{ ref('dim_news') }},
--          {{ ref('dim_symbols') }}, {{ ref('dim_date') }}
-- Client: Data Analyst — queried in SQL and BI tools
-- ============================================================
--
-- This mart answers: "What happened in the market yesterday,
-- was it news-driven, and where does each stock sit relative
-- to its historical performance?"
--
-- COLUMNS TO BUILD:
--
--   From fct_daily_stocks:
--     SYMBOL, TRADE_DATE
--     OPEN, HIGH, LOW, CLOSE, VOLUME
--     DAILY_RANGE, DAILY_CHANGE, PCT_CHANGE, DIRECTION
--
--   From dim_news (aggregated to SYMBOL + DATE grain in a CTE):
--     NEWS_ARTICLE_COUNT  — total articles for this symbol today
--     HEADLINES           — all headlines concatenated as a string
--
--   From dim_symbols (joined on SYMBOL):
--     ALL_TIME_HIGH, ALL_TIME_LOW, AVG_CLOSE_PRICE
--
--   Calculated in this mart:
--     PCT_FROM_ATH  — how far today's close is from the all-time high
--                     always zero or negative — a singular test in
--                     Sprint 6 will verify this
--
-- GRAIN HINT:
--   dim_news is at article grain — one row per article.
--   You must aggregate it to SYMBOL + DATE grain in a CTE
--   before joining to fct_daily_stocks.
--   See models/marts/README.md for the CTE pattern.
--
-- JOIN HINT:
--   Use LEFT JOINs so stocks with no news that day and symbols
--   with no dimension record are not dropped from your results.
--
-- ============================================================

-- TODO: Write your CTEs and SELECT statement below

WITH news_daily AS (
    SELECT
        SYMBOL,
        DATE_KEY,
        COUNT(*) AS NEWS_ARTICLE_COUNT, -- counts artilces for each stock per day
        LISTAGG(HEADLINE, ' | ') 
            WITHIN GROUP (ORDER BY PUBLISHED_AT) AS HEADLINES  -- combine headlines into one string
    FROM {{ ref('dim_news') }}
    GROUP BY SYMBOL, DATE_KEY
)

SELECT
    f.SYMBOL,
    f.TRADE_DATE,
    f.OPEN,
    f.HIGH,
    f.LOW,
    f.CLOSE,
    f.VOLUME,
    f.DAILY_RANGE,
    f.DAILY_CHANGE,
    f.PCT_CHANGE,
    f.DIRECTION,
    COALESCE(n.NEWS_ARTICLE_COUNT, 0) AS NEWS_ARTICLE_COUNT,  -- return zero when no article
    n.HEADLINES,
    s.ALL_TIME_HIGH,
    s.ALL_TIME_LOW,
    s.AVG_CLOSE_PRICE,
    ROUND(
        (f.CLOSE - s.ALL_TIME_HIGH) /
        NULLIF(s.ALL_TIME_HIGH, 0) * 100, 2
    ) AS PCT_FROM_ATH

FROM {{ ref('fct_daily_stocks') }} f

LEFT JOIN news_daily n
    ON f.SYMBOL = n.SYMBOL
    AND f.TRADE_DATE = n.DATE_KEY

LEFT JOIN {{ ref('dim_symbols') }} s
    ON f.SYMBOL = s.SYMBOL

LEFT JOIN {{ ref('dim_date') }} d
    ON f.TRADE_DATE = d.DATE_KEY

