from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.task_group import TaskGroup
from datetime import datetime, timedelta
import sys
sys.path.append("/opt/airflow/scripts")
from loader import load_sales, load_csv, load_hr

BASE="/opt/airflow/data"

def cash_branch(ds=None):
    d=(datetime.strptime(ds,"%Y-%m-%d").date()-timedelta(days=1))
    path=f"{BASE}/sales/sales_{d.strftime('%Y%m%d')}.csv"
    load_sales(path,d)
    # Reference data are a documented technical supplement, not a fourth business source.
    load_csv(f"{BASE}/reference/products.csv","staging.products_raw",
             ["product_id","product_name","category","brand"],["product_id"])
    load_csv(f"{BASE}/reference/stores.csv","staging.stores_raw",
             ["store_id","address","region","phone","store_type"],["store_id"])

def loyalty_branch():
    load_csv(f"{BASE}/loyalty/clients.csv","staging.clients_raw",
             ["client_id","full_name","birth_date","phone","email","registration_date"],["client_id"])
    load_csv(f"{BASE}/loyalty/cards.csv","staging.cards_raw",
             ["card_id","client_id","card_number","issue_date","status"],["card_id"])
    load_csv(f"{BASE}/loyalty/transactions.csv","staging.loyalty_transactions_raw",
             ["loyalty_transaction_id","card_id","points","transaction_date","store_id","source_transaction_id"],
             ["loyalty_transaction_id"])

def hr_branch():
    load_hr(f"{BASE}/hr/hr.json")

with DAG(
    dag_id="horizon_elt_daily",
    start_date=datetime(2026,9,28),
    schedule="@daily",
    catchup=False,
    default_args={"owner":"data-engineering","retries":2,"retry_delay":timedelta(minutes=2)},
    tags=["horizon","elt","daily"],
) as dag:
    with TaskGroup("cash_source") as cash:
        load_cash = PythonOperator(task_id="load_sales_yesterday", python_callable=cash_branch)
    with TaskGroup("loyalty_source") as loyalty:
        load_loyalty = PythonOperator(task_id="load_loyalty_db", python_callable=loyalty_branch)
    with TaskGroup("hr_source") as hr:
        load_hr_task = PythonOperator(task_id="load_hr_json", python_callable=hr_branch)

    [cash, loyalty, hr]
