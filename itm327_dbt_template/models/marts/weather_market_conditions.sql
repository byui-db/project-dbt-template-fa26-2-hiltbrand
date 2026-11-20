-- ============================================================
-- weather_market_conditions
-- DA Mart: daily weather at financial hub cities alongside
--          broad market performance
-- Grain: CITY + DATE
-- Sources: {{ ref('fct_daily_weather') }}, {{ ref('dim_weather_cities') }},
--          {{ ref('fct_daily_stocks') }}, {{ ref('dim_date') }}
-- Client: Data Analyst — exploring weather vs market correlations
-- ============================================================
--
-- This mart answers: "How did weather at financial hub cities
-- relate to broad market performance on the same day?"
--
-- COLUMNS TO BUILD:
--
--   From fct_daily_weather (driving table):
--     DATE, CITY, MAX_TEMP, MIN_TEMP, PRECIP, MAX_WIND
--
--   From dim_weather_cities (joined on CITY):
--     AVG_MAX_TEMP  — alias as CITY_NORMAL_MAX_TEMP
--
--   Calculated in this mart:
--     TEMP_DEVIATION_FROM_NORMAL  — how far today's temp is from
--                                   the city's historical average
--
--   From fct_daily_stocks (aggregated across all symbols for that DATE):
--     STOCKS_TRACKED   — count of distinct symbols trading that day
--     AVG_PCT_CHANGE   — average daily return across all symbols
--     AVG_DAILY_RANGE  — average intraday range across all symbols
--     TOTAL_MARKET_VOLUME — sum of all symbol volumes
--     STOCKS_UP        — count of symbols where DIRECTION = 'UP'
--     STOCKS_DOWN      — count of symbols where DIRECTION = 'DOWN'
--     STOCKS_FLAT      — count of symbols where DIRECTION = 'FLAT'
--
-- AGGREGATION HINT:
--   This mart joins weather (one row per city per day) to stocks
--   (many rows per day — one per symbol). You must aggregate the
--   stocks data by DATE before or during your JOIN to avoid fan-out.
--   Think carefully about your GROUP BY.
--
-- TEST HINT:
--   STOCKS_UP + STOCKS_DOWN + STOCKS_FLAT must equal STOCKS_TRACKED
--   for every row. A singular test in Sprint 6 will verify this.
--   If it fails, your direction count logic has a bug.
--
-- ============================================================

-- TODO: Write your SELECT statement below
WITH daily_market AS (
    SELECT
        TRADE_DATE,

        COUNT(DISTINCT SYMBOL) AS STOCKS_TRACKED,

        AVG(PCT_CHANGE) AS AVG_PCT_CHANGE,

        AVG(DAILY_RANGE) AS AVG_DAILY_RANGE,

        SUM(VOLUME) AS TOTAL_MARKET_VOLUME,

        COUNT_IF(DIRECTION = 'UP') AS STOCKS_UP,

        COUNT_IF(DIRECTION = 'DOWN') AS STOCKS_DOWN,

        COUNT_IF(DIRECTION = 'FLAT') AS STOCKS_FLAT

    FROM {{ ref('fct_daily_stocks') }}

    GROUP BY TRADE_DATE
)

SELECT
    w.DATE,
    w.CITY,

    -- Weather measurements
    w.MAX_TEMP,
    w.MIN_TEMP,
    w.PRECIP,
    w.MAX_WIND,

    -- Historical weather comparison
    c.AVG_MAX_TEMP AS CITY_NORMAL_MAX_TEMP,

    w.MAX_TEMP - c.AVG_MAX_TEMP
        AS TEMP_DEVIATION_FROM_NORMAL,

    -- Market performance
    m.STOCKS_TRACKED,
    m.AVG_PCT_CHANGE,
    m.AVG_DAILY_RANGE,
    m.TOTAL_MARKET_VOLUME,
    m.STOCKS_UP,
    m.STOCKS_DOWN,
    m.STOCKS_FLAT

FROM {{ ref('fct_daily_weather') }} w

LEFT JOIN {{ ref('dim_weather_cities') }} c
    ON w.CITY = c.CITY

LEFT JOIN daily_market m
    ON w.DATE = m.TRADE_DATE

LEFT JOIN {{ ref('dim_date') }} d
    ON w.DATE = d.DATE_KEY