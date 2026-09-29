-- Выполнить до и после повторного запуска DAG/dbt.
SELECT COUNT(*) AS fact_rows, COALESCE(SUM(sum_sales),0) AS fact_sales
FROM marts.fct_sales_daily;

-- После второго запуска значения должны остаться неизменными.
