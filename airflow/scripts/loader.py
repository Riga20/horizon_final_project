import csv, json, os
from datetime import datetime, date
import psycopg2
from psycopg2.extras import execute_values

DB = dict(
    host=os.getenv("POSTGRES_HOST","postgres"),
    port=os.getenv("POSTGRES_PORT","5432"),
    dbname=os.getenv("POSTGRES_DB","horizon"),
    user=os.getenv("POSTGRES_USER","horizon"),
    password=os.getenv("POSTGRES_PASSWORD","horizon"),
)

def conn():
    return psycopg2.connect(**DB)

def load_sales(file_path, load_date):
    rows=[]
    with open(file_path, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows.append((r["transaction_id"],r["product_id"],r["amount"],r["oquantity"],
                         r["store_id"],r["datetime"],load_date,os.path.basename(file_path)))
    sql = """INSERT INTO staging.sales_raw
    (transaction_id,product_id,amount,oquantity,store_id,datetime,load_date,source_file)
    VALUES %s ON CONFLICT (transaction_id,product_id,datetime)
    DO UPDATE SET amount=EXCLUDED.amount,oquantity=EXCLUDED.oquantity,
                  store_id=EXCLUDED.store_id,load_date=EXCLUDED.load_date,
                  source_file=EXCLUDED.source_file,loaded_at=now()"""
    with conn() as c, c.cursor() as cur:
        execute_values(cur,sql,rows)

def load_csv(path, table, columns, pk_columns):
    rows=[]
    with open(path, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows.append(tuple(r.get(c) or None for c in columns))
    placeholders=", ".join(columns)
    updates=", ".join([f"{c}=EXCLUDED.{c}" for c in columns if c not in pk_columns])
    sql=f"""INSERT INTO {table} ({placeholders}) VALUES %s
            ON CONFLICT ({", ".join(pk_columns)}) DO UPDATE SET {updates}"""
    with conn() as c, c.cursor() as cur:
        execute_values(cur,sql,rows)

def load_hr(path):
    data=json.load(open(path,encoding="utf-8"))
    cols=["employee_id","full_name","position","store_id","hire_date","termination_date"]
    rows=[tuple(x.get(c) for c in cols) for x in data]
    sql="""INSERT INTO staging.hr_raw
    (employee_id,full_name,position,store_id,hire_date,termination_date)
    VALUES %s ON CONFLICT (employee_id) DO UPDATE SET
    full_name=EXCLUDED.full_name,position=EXCLUDED.position,store_id=EXCLUDED.store_id,
    hire_date=EXCLUDED.hire_date,termination_date=EXCLUDED.termination_date,loaded_at=now()"""
    with conn() as c, c.cursor() as cur:
        execute_values(cur,sql,rows)
