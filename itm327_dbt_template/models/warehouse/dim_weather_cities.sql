-- ============================================================
-- dim_weather_cities
-- Dimension table: one row per financial hub city
-- Grain: CITY
-- Source: {{ ref('raw_weather') }}
-- ============================================================
--
-- Contains climatological statistics for each city tracked by
-- your weather pipeline. Marts that analyze market performance
-- by geography join against this table to compare current
-- conditions against historical norms for that city.
--
-- COLUMNS TO BUILD:
--
--   Key:
--     CITY
--
--   Date range this city appears in your weather data:
--     FIRST_OBSERVATION_DATE  — earliest DATE for this city
--     LAST_OBSERVATION_DATE   — latest DATE for this city
--     TOTAL_OBSERVATION_DAYS  — count of observation days
--
--   Typical conditions (averages across the full history):
--     AVG_MAX_TEMP      — round to 2 decimal places
--     AVG_MIN_TEMP      — round to 2 decimal places
--     AVG_DAILY_PRECIP  — round to 2 decimal places
--     AVG_MAX_WIND      — round to 2 decimal places
--
--   Extreme conditions:
--     HOTTEST_DAY_TEMP    — highest MAX_TEMP ever recorded
--     COLDEST_DAY_TEMP    — lowest MIN_TEMP ever recorded
--     WETTEST_DAY_PRECIP  — highest single day precipitation
--
-- HINT:
--   Like dim_symbols, this table collapses many daily rows into
--   one descriptive row per CITY. The average columns become the
--   "normal" baseline that your weather mart uses to calculate
--   how much today's conditions deviate from historical norms.
--
-- HINT:
--   Add a city-to-exchange mapping if you want to associate each
--   city with a specific stock exchange (e.g., New York → NYSE/NASDAQ).
--
-- ============================================================

-- TODO: Write your SELECT statement below
-- select 1 as placeholder  -- placeholder so the template compiles; DELETE this line when you write your own SELECT
SELECT
    city
    , min(date) as first_observation_date
    , max(date) as last_observation_date
    , count(city) as total_observation_days
    , avg(max_temp) as avg_max_temp
    , avg(min_temp) as avg_min_temp
    , avg(precip) as avg_daily_precip
    , avg(wind_speed) as avg_max_wind
    , max(max_temp) as hottest_day_temp
    , min(min_temp) as coldest_day_temp
    , max(precip) as wettest_day_precip
    , case
        when city = 'New York City' then 'NYC/NASDAQ'
        when city = 'Tokyo' then 'TOK/TSE'
        when city = 'London' then 'LON/LSE'
      end as exchange_mapping
FROM {{ ref('raw_weather') }}
GROUP BY city