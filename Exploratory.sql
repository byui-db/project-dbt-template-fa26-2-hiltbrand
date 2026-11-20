-- SELECT MIN(TRADE_DATE), MAX(TRADE_DATE) FROM PROJECT_DB.STAGING.RAW_STOCKS_SHAWA;
-- SELECT MIN(DATE), MAX(DATE) FROM PROJECT_DB.STAGING.RAW_WEATHER_SHAWA;
-- SELECT symbol, COUNT(*) FROM PROJECT_DB.STAGING.RAW_NEWS_SHAWA
-- GROUP BY symbol;
-- select
--     symbol
--     , min(trade_date) as first_seen_date
--     , max(trade_date) as last_seen_date
--     , count(symbol) as total_trading_days
--     , max(high) as all_time_high
--     , min(low) as all_time_low
--     , avg(close) as avg_close_price
--     , avg(volume) as average_daily_volume
-- from PROJECT_DB.STAGING.RAW_STOCKS_SHAWA
-- group by symbol

-- SELECT symbol FROM PROJECT_DB.STAGING.RAW_NEWS_SHAWA WHERE symbol NOT IN (SELECT symbol FROM PROJECT_DB.STAGING.RAW_STOCKS_SHAWA)

SELECT city, COUNT(city) FROM PROJECT_DB.STAGING.RAW_WEATHER_SHAWA GROUP BY city;

-- SELECT DISTINCT f.symbol
-- FROM PROJECT_DB.STAGING.FCT_DAILY_STOCKS_SHAWA AS f
-- LEFT JOIN PROJECT_DB.STAGING.RAW_STOCKS_SHAWA AS r
--     ON f.symbol = r.symbol
-- WHERE r.symbol IS NULL