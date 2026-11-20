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
-- select 1 as placeholder  -- placeholder so the template compiles; DELETE this line when you write your own SELECT
SELECT
    symbol
    , trade_date
    , open
    , high
    , low
    , close
    , volume
    , high - low AS daily_range
    , open - close AS daily_change
    , CASE
          WHEN open <> 0 THEN ROUND((open - close) / open, 4)
          ELSE 0
      END AS pct_change
    , CASE
          WHEN open < close THEN 'UP'
          WHEN open > close THEN 'DOWN'
          ELSE 'FLAT'
      END AS direction
FROM {{ ref('raw_stocks') }}