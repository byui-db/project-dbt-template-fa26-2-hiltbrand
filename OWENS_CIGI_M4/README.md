Milestone 4 – Testing Results and Alternative Approach

All three staging models were successfully created in PROJECT_DB.STAGING.

Validation results:

dbt run: PASS=3, ERROR=0

dbt test --select raw_news raw_stocks raw_weather: PASS=8, ERROR=0

Alternative composite-key testing:

The assignment requires dbt_utils.unique_combination_of_columns to validate composite keys. However, attempts to install dbt_utils using dbt deps failed because Snowflake could not connect to hub.getdbt.com. The necessary external access integration was not available in my Snowflake environment.

To complete the assignment without further delays, I used dbt's built-in unique tests with concatenated key expressions to validate the composite keys in the stocks and weather staging models.

This alternative verifies uniqueness of the combined keys without requiring an external package. The staging models passed all eight configured tests.

Additional note: The provided template includes an unfinished Python mart model, market_volatility_metrics.py, which prevented staging compilation. I temporarily renamed it to .py.bak so the staging models could compile and run. The original code has been preserved for future milestones.
