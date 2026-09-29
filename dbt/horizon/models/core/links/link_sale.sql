{{ config(unique_key='link_sale_hk', incremental_strategy='merge') }}
select {{ hash_key(['s.transaction_id','s.product_id']) }} link_sale_hk,
       ht.transaction_hk,hp.product_hk,hs.store_hk,current_timestamp load_dts
from {{ ref('stg_sales') }} s
join {{ ref('hub_transaction') }} ht on ht.transaction_bk=s.transaction_id
join {{ ref('hub_product') }} hp on hp.product_bk=s.product_id
join {{ ref('hub_store') }} hs on hs.store_bk=s.store_id
{% if is_incremental() %} where {{ hash_key(['s.transaction_id','s.product_id']) }} not in (select link_sale_hk from {{ this }}) {% endif %}