# Спецификация BI

Источник: `marts.fct_sales_daily`.

## График 1 — Динамика продаж
X: `date_key`/дата.
Y: `SUM(sum_sales)`.
Фильтры: регион, магазин, категория, бренд, период.

## График 2 — Top-10 товаров
Dimension: `product_key` (через dim_product).
Metric: `SUM(sum_sales)`.
Сортировка по убыванию, Top 10.

## Дополнительные KPI
- Выручка = SUM(sum_sales)
- Количество чеков = SUM(num_transactions) — с оговоркой о зерне витрины
- Средний чек = среднее `avg_transaction_amount` только при корректной агрегации по выбранному зерну.
