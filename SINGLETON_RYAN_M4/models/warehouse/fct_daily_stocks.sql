-- ============================================================
-- fct_daily_stocks
-- Fact table: one row per stock symbol per trading day
-- Grain: SYMBOL + TRADE_DATE
-- Source: {{ ref('raw_stocks') }}
-- ============================================================
--
-- This is the central price fact table of your data warehouse.
-- It contains stock price data and derived price metrics only.
-- News data lives in its own warehouse models (dim_news, fct_daily_news)
-- and is joined to this table at the mart layer.
--
-- Marts must reference this table via ref() — never reach back
-- to staging directly.
--
-- COLUMNS TO BUILD:
--
--   Keys:
--     SYMBOL, TRADE_DATE
--
--   Price metrics (from raw_stocks):
--     OPEN, HIGH, LOW, CLOSE, VOLUME
--
--   Derived price metrics (calculate here so marts don't repeat logic):
--     DAILY_RANGE   — the spread between HIGH and LOW
--     DAILY_CHANGE  — the difference between CLOSE and OPEN
--     PCT_CHANGE    — DAILY_CHANGE as a percentage of OPEN (round to 4 decimals)
--                     Hint: guard against division by zero
--     DIRECTION     — 'UP', 'DOWN', or 'FLAT' based on CLOSE vs OPEN
--
-- HINT:
--   This model has no JOIN and no aggregation — one row in raw_stocks
--   produces one row here. Focus on getting the derived metrics right.
--   The DIRECTION CASE statement will be tested in Sprint 6.
--
-- ============================================================

-- TODO: Write your SELECT statement below
select
    symbol,
    trade_date,
    open,
    high,
    low,
    close,
    volume,
    high - low as daily_range,
    close - open as daily_change,
    case when open = 0 then null
         else round((close - open) / open * 100, 4)
    end as pct_change,
    case when close > open then 'UP'
         when close < open then 'DOWN'
         else 'FLAT'
    end as direction
from {{ ref('raw_stocks') }}
