{{ config(materialized='table') }}
with line_sales as (
  select ls.link_sale_hk,ls.transaction_hk,ls.product_hk,ls.store_hk,
         ss.sales_amount,td.transaction_datetime
  from {{ ref('link_sale') }} ls
  join {{ ref('sat_sale') }} ss on ss.link_sale_hk=ls.link_sale_hk
  join {{ ref('sat_transaction_details') }} td on td.transaction_hk=ls.transaction_hk
),
ticket_totals as (
  select transaction_hk, date(transaction_datetime) sale_date,
         store_hk, sum(sales_amount) total_ticket_amount
  from line_sales
  group by transaction_hk,date(transaction_datetime),store_hk
),
daily_product as (
  select date(l.transaction_datetime) sale_date,l.store_hk,l.product_hk,
         sum(l.sales_amount)::numeric(12,2) sum_sales,
         count(distinct l.transaction_hk)::integer num_transactions
  from line_sales l
  group by date(l.transaction_datetime),l.store_hk,l.product_hk
),
avg_ticket as (
  select l.sale_date,l.store_hk,l.product_hk,
         avg(t.total_ticket_amount)::numeric(10,2) avg_transaction_amount
  from (select distinct transaction_hk, sale_date, store_hk, product_hk from
        (select transaction_hk,date(transaction_datetime) sale_date,store_hk,product_hk from line_sales) x) l
  join ticket_totals t on t.transaction_hk=l.transaction_hk
  group by l.sale_date,l.store_hk,l.product_hk
)
select to_char(d.sale_date,'YYYYMMDD')::integer date_key,
       ds.store_key,dp.product_key,d.sum_sales,d.num_transactions,a.avg_transaction_amount
from daily_product d
join avg_ticket a using(sale_date,store_hk,product_hk)
join {{ ref('dim_store') }} ds on ds.store_id=(select store_bk from {{ ref('hub_store') }} where store_hk=d.store_hk)
join {{ ref('dim_product') }} dp on dp.product_id=(select product_bk from {{ ref('hub_product') }} where product_hk=d.product_hk)
