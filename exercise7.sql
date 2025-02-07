--- EXERCISE 7
--- Se asume que interesan sólamente las ivr_id que tienen identificación asociada se realiza un 
--- inner join y se suprimen todas las entradas que tengan document_type como UNKNOWN.
--- Todas las llamadas (ivr_id) tienen un identificador (billing_account_id) único
select 
    distinct cll.ivr_id,
    stp.billing_account_id,
from keepcoding.ivr_calls cll
inner join keepcoding.ivr_steps stp
on cll.ivr_id = stp.ivr_id
where stp.customer_phone != 'UNKNOWN';

--- ANALISIS IDENTIFICADOR ÚNICO
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.billing_account_id
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.billing_account_id != 'UNKNOWN'
)
select
  count(*) as total,
  count(distinct ivr_id) as total_unique
from ivrid_document;
--- Entre los registros hay ivr_id repetidos, es decir, que tienen más 
--- de una identificación
--- total: 18178 / total_unique: 17821

--- Se busca estos ivr_id repetidos
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.document_type,
    stp.billing_account_id
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.billing_account_id != 'UNKNOWN'
)
select
    ivr_id,
    count(*) as total
  from ivrid_document
  group by ivr_id
  order by total DESC
limit 10;
--- Una muestra de ivr_id con identidades duplicadas
--- (1671436840.3316121,1671532597.338573,1670871157.314419)


--- Se busca en ivr_steps que ocurre con los registros que tienen estos ivr_id
select *
from keepcoding.ivr_steps
where ivr_id in (1671436840.3316121,1671532597.338573,1670871157.314419)
order by ivr_id;

--- Durante estas llamadas se aportan dos identificaciones diferentes? Llegado a este punto,
--- si esto fuera un caso real se me ocurre dejar toda la información y comentar las duplicidades
--- a la persona que vaya a recibir la información
