-- Сверка за вчера. Для ручного запуска замените :yesterday на дату.
WITH raw AS (
    SELECT COALESCE(SUM(amount),0)::numeric(12,2) total_raw
    FROM staging.sales_raw
    WHERE load_date = :yesterday
),
mart AS (
    SELECT COALESCE(SUM(sum_sales),0)::numeric(12,2) total_mart
    FROM marts.fct_sales_daily f
    JOIN marts.dim_calendar c ON c.date_key=f.date_key
    WHERE c.full_date = :yesterday
)
SELECT raw.total_raw, mart.total_mart,
       (raw.total_raw - mart.total_mart)::numeric(12,2) difference,
       CASE WHEN raw.total_raw = mart.total_mart THEN 'PASS' ELSE 'FAIL' END status
FROM raw CROSS JOIN mart;
