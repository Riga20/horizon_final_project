{{ config(unique_key='link_loyalty_txn_hk', incremental_strategy='merge') }}
select {{ hash_key(['t.loyalty_transaction_id']) }} link_loyalty_txn_hk,
       hl.loyalty_txn_hk,hc.card_hk,current_timestamp load_dts
from {{ ref('stg_loyalty_transactions') }} t
join {{ ref('hub_loyalty_transaction') }} hl on hl.loyalty_txn_bk=t.loyalty_transaction_id
join {{ ref('hub_card') }} hc on hc.card_bk=t.card_id
{% if is_incremental() %} where {{ hash_key(['t.loyalty_transaction_id']) }} not in (select link_loyalty_txn_hk from {{ this }}) {% endif %}