{{ config(unique_key='employee_hk', incremental_strategy='merge') }}
select h.employee_hk,e.full_name,e.position,e.hire_date,e.termination_date,
       current_timestamp load_dts,'hr_api' record_source
from {{ ref('stg_hr') }} e join {{ ref('hub_employee') }} h on h.employee_bk=e.employee_id