{{ config(unique_key='transaction_hk', incremental_strategy='merge') }}
select ht.transaction_hk,
       min(s.transaction_datetime) as transaction_datetime,
       sum(s.amount)::numeric(12,2) as total_amount,
       current_timestamp as load_dts,'cash_csv' as record_source
from {{ ref('stg_sales') }} s
join {{ ref('hub_transaction') }} ht on ht.transaction_bk=s.transaction_id
group by ht.transaction_hk