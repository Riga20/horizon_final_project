{{ config(unique_key='store_hk', incremental_strategy='merge') }}
select {{ hash_key(['store_id']) }} store_hk,store_id store_bk,current_timestamp load_dts,'reference' record_source
from {{ ref('stg_stores') }}
{% if is_incremental() %} where store_id not in (select store_bk from {{ this }}) {% endif %}