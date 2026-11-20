SELECT
    SYMBOL,
    DATETIME,
    VOLUME

FROM {{ source('project_raw', 'STOCKS_OWENS_C') }}

WHERE VOLUME < 0