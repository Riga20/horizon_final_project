{{ config(materialized='table') }}
select row_number() over(order by hs.store_bk)::integer store_key,
       hs.store_bk store_id,ss.address,ss.region,
       current_date valid_from,null::date valid_to,true is_current
from {{ ref('hub_store') }} hs join {{ ref('sat_store') }} ss on ss.store_hk=hs.store_hk
