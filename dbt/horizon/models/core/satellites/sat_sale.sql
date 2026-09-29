{{ config(unique_key='link_sale_hk', incremental_strategy='merge') }}
select ls.link_sale_hk,s.amount::numeric(12,2) sales_amount,s.quantity::numeric(12,3) quantity,
       current_timestamp load_dts,'cash_csv' record_source
from {{ ref('stg_sales') }} s
join {{ ref('link_sale') }} ls on ls.link_sale_hk={{ hash_key(['s.transaction_id','s.product_id']) }}