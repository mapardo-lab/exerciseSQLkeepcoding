--- EXERCISE 7
--- Esta es la propuesta de consulta para este ejercicio
with step_select_billing as (
  select
    ivr_id,
    billing_account_id
  from keepcoding.ivr_steps
  where step_name='CUSTOMERINFOBYPHONE.TX' and billing_account_id != 'UNKNOWN'
)
select
  cll.ivr_id,
  coalesce(stp.billing_account_id,'UNKNOWN') as billing_account_id,
from keepcoding.ivr_calls cll
left join step_select_billing stp
on cll.ivr_id = stp.ivr_id;

--- A continuación se justifica la elección de esta consulta:

--- Se aplica el filtrado billing_account_id != 'UNKNOWN' para eliminar todas las entradas sin información.
--- Para el resto de entradas se observa que existe información duplicada para algunas llamadas (ivr_id)
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

--- Durante estas llamadas se aportan dos identificaciones diferentes? Se decide mantener los datos
--- de identificación de las entradas que tienen como valor en campo step_name 'CUSTOMERINFOBYPHONE.TX',
--- para que así allá un sólo identificador por llamada (campo ivr_id)
--- En un caso real, se consultaría con la persona conveniente.

