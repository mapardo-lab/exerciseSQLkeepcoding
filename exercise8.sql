--- EXERCISE 8
with ivr_id_module_averia as (
  select
  ivr_id,
  1 as masiva_lg
  from keepcoding.ivr_modules
  where module_name = 'AVERIA_MASIVA'
)
select 
  cll.ivr_id,
  coalesce(masiva_lg,0) as masiva_lg
from keepcoding.ivr_calls cll
left join ivr_id_module_averia mod
on cll.ivr_id = mod.ivr_id;
