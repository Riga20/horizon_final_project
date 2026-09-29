{{ config(unique_key='card_hk', incremental_strategy='merge') }}
select h.card_hk,c.card_number,c.issue_date,c.status,current_timestamp load_dts,'loyalty_db' record_source
from {{ ref('stg_cards') }} c join {{ ref('hub_card') }} h on h.card_bk=c.card_id