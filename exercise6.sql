--- EXERCISE 6
--- Se asume que interesan sólamente las ivr_id que tienen identificación asociada se realiza un 
--- inner join y se suprimen todas las entradas que tengan document_type como UNKNOWN.
--- Todas las llamadas (ivr_id) tienen un identificador (customer_phone) único
select 
    distinct cll.ivr_id,
    stp.customer_phone,
from keepcoding.ivr_calls cll
inner join keepcoding.ivr_steps stp
on cll.ivr_id = stp.ivr_id
where stp.customer_phone != 'UNKNOWN'

--- ANALISIS IDENTIFICADOR ÚNICO
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

