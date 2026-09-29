{{ config(unique_key='loyalty_txn_hk', incremental_strategy='merge') }}
select {{ hash_key(['loyalty_transaction_id']) }} loyalty_txn_hk,loyalty_transaction_id loyalty_txn_bk,current_timestamp load_dts,'loyalty_db' record_source
from {{ ref('stg_loyalty_transactions') }}
{% if is_incremental() %} where loyalty_transaction_id not in (select loyalty_txn_bk from {{ this }}) {% endif %}