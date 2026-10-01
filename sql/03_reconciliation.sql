-- Reconciliation: сравнение исходных кассовых данных с витриной
-- по фактической дате продажи, а не по дате загрузки файла.

WITH raw AS (
    SELECT
        datetime::date AS sale_date,
        COALESCE(SUM(amount), 0)::numeric(12,2) AS total_raw
    FROM staging.sales_raw
    GROUP BY datetime::date
),
mart AS (
    SELECT
        c.full_date AS sale_date,
        COALESCE(SUM(f.sum_sales), 0)::numeric(12,2) AS total_mart
    FROM marts.fct_sales_daily f
    JOIN marts.dim_calendar c
        ON c.date_key = f.date_key
    GROUP BY c.full_date
)
SELECT
    r.sale_date,
    r.total_raw,
    m.total_mart,
    (r.total_raw - m.total_mart)::numeric(12,2) AS difference,
    CASE
        WHEN r.total_raw = m.total_mart THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM raw r
LEFT JOIN mart m
    ON m.sale_date = r.sale_date
ORDER BY r.sale_date;
