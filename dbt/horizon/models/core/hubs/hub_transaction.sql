{{ config(unique_key='transaction_hk', incremental_strategy='merge') }}
select {{ hash_key(['transaction_id']) }} as transaction_hk, transaction_id as transaction_bk,
       current_timestamp as load_dts, 'cash_csv' as record_source
from {{ ref('stg_sales') }}
group by transaction_id
{% if is_incremental() %} having transaction_id not in (select transaction_bk from {{ this }}) {% endif %}