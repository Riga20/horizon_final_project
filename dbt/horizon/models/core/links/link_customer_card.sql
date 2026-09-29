{{ config(unique_key='link_customer_card_hk', incremental_strategy='merge') }}
select {{ hash_key(['c.client_id','c.card_id']) }} link_customer_card_hk,
       hc.customer_hk,hcard.card_hk,current_timestamp load_dts
from {{ ref('stg_cards') }} c
join {{ ref('hub_customer') }} hc on hc.customer_bk=c.client_id
join {{ ref('hub_card') }} hcard on hcard.card_bk=c.card_id
{% if is_incremental() %} where {{ hash_key(['c.client_id','c.card_id']) }} not in (select link_customer_card_hk from {{ this }}) {% endif %}