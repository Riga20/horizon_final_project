# Архитектура

```text
Cash CSV ───────┐
Loyalty DB ─────┼──> Airflow Extract/Load ──> STAGING ──> dbt ──> CORE/Data Vault ──> MARTS ──> BI
HR JSON ─────────┘                                      │
                                                       └── DQ tests
```

### Почему ELT
Сырые данные сначала сохраняются в PostgreSQL staging, затем SQL/dbt выполняет преобразования внутри приемника.

### Инкремент
Для кассовых файлов DAG вычисляет `execution_date - 1 day` и ищет `sales_YYYYMMDD.csv`.
Для повторного запуска используется `ON CONFLICT DO UPDATE`, а dbt-модели имеют детерминированные hash keys и merge-стратегию.

### Data Vault
Hubs: customer, transaction, product, store, card, loyalty transaction, employee.
Links: transaction, sale, customer-card, loyalty transaction-card.
Satellites: transaction details, sale, client, card, loyalty transaction, employee, product static, store.
