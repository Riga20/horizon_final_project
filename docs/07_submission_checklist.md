# Чек-лист сдачи

## Что подготовлено
- [x] Распаковываемый проект PostgreSQL + Airflow + dbt.
- [x] 3 параллельные source-ветки в DAG.
- [x] Идемпотентная загрузка через ON CONFLICT DO UPDATE.
- [x] Data Vault Core: Hubs / Links / Satellites.
- [x] Marts: dim_calendar / dim_product / dim_store / fct_sales_daily.
- [x] dbt DQ tests.
- [x] Reconciliation SQL.
- [x] Incremental/idempotency SQL check.
- [x] BI specification.
- [x] Local validation evidence и BI-визуализация.

## Что требует среды пользователя
В текущем рабочем окружении нет Docker/PostgreSQL/Airflow/dbt CLI, поэтому живой запуск этих компонентов здесь не выполнен.
Также публикация в GitHub/GitLab/GitVerse требует доступа к аккаунту пользователя.

Перед сдачей нужно выполнить в реальной среде:
1. `docker compose up -d`;
2. выполнить `sql/01_init.sql`;
3. запустить DAG `horizon_elt_daily`;
4. `dbt deps` и `dbt build --profiles-dir .`;
5. выполнить `sql/03_reconciliation.sql`;
6. повторно запустить pipeline и выполнить `sql/05_incremental_check.sql`;
7. открыть BI-инструмент и построить два графика из `dashboard/bi_specification.md`;
8. сделать скриншоты живого Airflow/dbt/BI интерфейсов;
9. загрузить репозиторий в GitHub/GitLab/GitVerse.

## Важно
Файлы `evidence/*.png` являются локальными доказательствами расчётов на demo-данных. Их нельзя выдавать за скриншоты живого Airflow/dbt/BI интерфейса.
