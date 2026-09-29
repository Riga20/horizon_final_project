# Контракт ELT-пайплайна

Airflow отвечает за Extract & Load и содержит **ровно три параллельные ветки**, соответствующие трем бизнес-источникам:
1. cash source;
2. loyalty source;
3. HR source.

После успешной загрузки выполняется `dbt build` (в production это можно оформить отдельным downstream DAG/Task через dbt runner или Kubernetes/DockerOperator).

Такое разделение не смешивает оркестрацию загрузки и среду выполнения dbt: dbt должен запускаться в окружении, где установлен `dbt-postgres`.
