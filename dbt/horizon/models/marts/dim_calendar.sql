{{ config(materialized='table') }}
select
  to_char(d::date,'YYYYMMDD')::integer date_key,
  d::date full_date,
  extract(isodow from d)::smallint day_of_week,
  trim(to_char(d::date,'Day')) day_name,
  extract(month from d)::smallint month,
  trim(to_char(d::date,'Month')) month_name,
  extract(quarter from d)::smallint quarter,
  extract(year from d)::smallint year,
  false as is_holiday
from generate_series('2026-01-01'::date,'2026-12-31'::date,interval '1 day') d
