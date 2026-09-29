{{ config(unique_key='product_hk', incremental_strategy='merge') }}
select {{ hash_key(['product_id']) }} product_hk, product_id product_bk,current_timestamp load_dts,'reference' record_source
from {{ ref('stg_products') }}
{% if is_incremental() %} where product_id not in (select product_bk from {{ this }}) {% endif %}