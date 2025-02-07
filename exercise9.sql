--- EXERCISE 9
with ivr_id_info_phone as (
  select
  ivr_id,
  1 as info_by_phone_lg
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYPHONE.TX' and step_result = 'OK'
)
select 
  cll.ivr_id,
  coalesce(info_by_phone_lg,0) as info_by_phone_lg
from keepcoding.ivr_calls cll
left join ivr_id_info_phone pho
on cll.ivr_id = pho.ivr_id;

