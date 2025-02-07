--- EXERCISE 10
with ivr_id_info_dni as (
  select
  distinct ivr_id,
  1 as info_by_dni_lg
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYDNI.TX' and step_result = 'OK'
)
select 
  cll.ivr_id,
  coalesce(info_by_dni_lg,0) as info_by_dni_lg
from keepcoding.ivr_calls cll
left join ivr_id_info_dni dni
on cll.ivr_id = dni.ivr_id;

