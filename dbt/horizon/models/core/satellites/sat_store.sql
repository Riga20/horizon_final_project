{{ config(unique_key='store_hk', incremental_strategy='merge') }}
select h.store_hk,s.address,s.region,s.phone,s.store_type,current_timestamp load_dts,'reference' record_source
from {{ ref('stg_stores') }} s join {{ ref('hub_store') }} h on h.store_bk=s.store_id