# Локальный validation report

Дата проверки: 2026-09-29

## Source reconciliation
- Raw sales rows: **8**
- Unique transactions: **5**
- Raw sales sum: **1040.00**
- Mart-equivalent sales sum: **1040.00**
- Difference: **0.00**
- Result: **PASS**

## Idempotency key check
- Natural key: `(transaction_id, product_id, datetime)`
- Unique natural keys: **8**
- Maximum occurrences per natural key: **1**
- Expected after repeated load: row count remains **8** because loader uses `ON CONFLICT DO UPDATE`.

## DQ checks represented in the project
- Hub hash keys: not null + unique
- Card status: accepted values active / blocked / expired
- Sales amount: > 0
- Additional duplicate-hash test

## Important execution limitation
This report is a **local reproducibility/evidence report calculated from the supplied demo files**. The current execution environment has no Docker daemon, PostgreSQL server, Airflow CLI, or dbt CLI, so it must not be described as a live Airflow/dbt run.
