{{ config(unique_key='card_hk', incremental_strategy='merge') }}
select {{ hash_key(['card_id']) }} card_hk,card_id card_bk,current_timestamp load_dts,'loyalty_db' record_source
from {{ ref('stg_cards') }}
{% if is_incremental() %} where card_id not in (select card_bk from {{ this }}) {% endif %}