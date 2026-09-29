{{ config(unique_key='employee_hk', incremental_strategy='merge') }}
select {{ hash_key(['employee_id']) }} employee_hk,employee_id employee_bk,current_timestamp load_dts,'hr_api' record_source
from {{ ref('stg_hr') }}
{% if is_incremental() %} where employee_id not in (select employee_bk from {{ this }}) {% endif %}