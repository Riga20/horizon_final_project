{{ config(unique_key='link_transaction_hk', incremental_strategy='merge') }}
select {{ hash_key(['s.transaction_id']) }} link_transaction_hk,
       ht.transaction_hk, hs.store_hk, current_timestamp load_dts
from {{ ref('stg_sales') }} s
join {{ ref('hub_transaction') }} ht on ht.transaction_bk=s.transaction_id
join {{ ref('hub_store') }} hs on hs.store_bk=s.store_id
group by s.transaction_id,ht.transaction_hk,hs.store_hk
{% if is_incremental() %} having {{ hash_key(['s.transaction_id']) }} not in (select link_transaction_hk from {{ this }}) {% endif %}