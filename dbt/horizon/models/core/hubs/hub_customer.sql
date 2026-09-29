{{ config(unique_key='customer_hk', incremental_strategy='merge') }}
select {{ hash_key(['client_id']) }} as customer_hk, client_id as customer_bk,
       current_timestamp as load_dts, 'loyalty_db' as record_source
from {{ ref('stg_clients') }}
{% if is_incremental() %} where client_id not in (select customer_bk from {{ this }}) {% endif %}