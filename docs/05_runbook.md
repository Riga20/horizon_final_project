# Runbook защиты

## 1. Инициализация
`psql ... -f sql/01_init.sql`

## 2. Airflow
Запустить `horizon_elt_daily`.
Для даты запуска DAG должен искать файл предыдущего календарного дня.

## 3. dbt
```bash
cd dbt/horizon
dbt deps
dbt build --profiles-dir .
dbt docs generate --profiles-dir .
```

## 4. DQ
`dbt build` должен завершиться без failed tests.

## 5. Reconciliation
Выполнить `sql/03_reconciliation.sql` с датой вчера.
Ожидаемый `difference = 0`, `status = PASS`.

## 6. Incremental test
Повторно запустить DAG/dbt.
Сравнить количество строк и сумму `marts.fct_sales_daily` до/после.
Они не должны измениться из-за дублей.

## 7. BI
Подключить `marts.fct_sales_daily`.
Построить:
- продажи по дням;
- Top-10 товаров по `sum_sales`.
