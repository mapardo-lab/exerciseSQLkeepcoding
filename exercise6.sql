--- EXERCISE 6
--- EXERCISE 6
with step_select_dni as (
  select
    ivr_id,
    customer_phone,
  from keepcoding.ivr_steps
  where customer_phone != 'UNKNOWN'
)
select
  cll.ivr_id,
  coalesce(stp.customer_phone,'UNKNOWN') as customer_phone,
from keepcoding.ivr_calls cll
left join step_select_dni stp
on cll.ivr_id = stp.ivr_id;

--- Se comprueba que no hay duplicidades en el campo customer_phone para las llamadas
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.customer_phone
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.customer_phone != 'UNKNOWN'
)
select
  count(*) as total,
  count(distinct ivr_id) as total_unique
from ivrid_document
--- total: 15878 / total_unique: 15878

