{{ config(unique_key='product_hk', incremental_strategy='merge') }}
select h.product_hk,p.product_name,p.category,p.brand,current_timestamp load_dts,'reference' record_source
from {{ ref('stg_products') }} p join {{ ref('hub_product') }} h on h.product_bk=p.product_id