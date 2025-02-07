--- EXERCISE 4
select
  ivr_id,
  case
    when vdn_label like 'ATC%' then 'FRONT'
    when vdn_label like 'TECH%' then 'TECH'
    when vdn_label like 'ABSORPTION' then 'ABSORPTION'
    else 'RESTO'
  end as vdn_aggregation
from keepcoding.ivr_calls;

