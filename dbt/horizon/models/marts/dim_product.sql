{{ config(materialized='table') }}
select row_number() over(order by hp.product_bk)::integer product_key,
       hp.product_bk product_id, sp.product_name,sp.category,sp.brand,
       current_date valid_from,null::date valid_to,true is_current
from {{ ref('hub_product') }} hp join {{ ref('sat_product_static') }} sp on sp.product_hk=hp.product_hk
