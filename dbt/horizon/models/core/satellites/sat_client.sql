{{ config(unique_key='customer_hk', incremental_strategy='merge') }}
select hc.customer_hk,c.full_name,c.birth_date,c.phone,c.email,c.registration_date,
       current_timestamp load_dts,'loyalty_db' record_source
from {{ ref('stg_clients') }} c join {{ ref('hub_customer') }} hc on hc.customer_bk=c.client_id