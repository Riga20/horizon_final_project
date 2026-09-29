{{ config(unique_key='loyalty_txn_hk', incremental_strategy='merge') }}
select h.loyalty_txn_hk,t.points,t.transaction_date,
       case when t.points >= 0 then 'accrual' else 'redemption' end operation_type,
       current_timestamp load_dts,'loyalty_db' record_source
from {{ ref('stg_loyalty_transactions') }} t
join {{ ref('hub_loyalty_transaction') }} h on h.loyalty_txn_bk=t.loyalty_transaction_id