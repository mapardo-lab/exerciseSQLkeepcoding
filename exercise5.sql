--- EXERCISE 5
--- Esta es la propuesta de consulta para este ejercicio
with step_select_dni as (
  select
    ivr_id,
    document_type,
    document_identification
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYDNI.TX' and document_type != 'UNKNOWN'
)
select
  cll.ivr_id,
  coalesce(stp.document_type,'UNKNOWN') as document_type,
  coalesce(stp.document_identification,'UNKNOWN') as document_identification
from keepcoding.ivr_calls cll
left join step_select_dni stp
on cll.ivr_id = stp.ivr_id


--- A continuación se justifica la elección de esta consulta:

--- Se aplica el filtrado document_type != 'UNKNOWN' para eliminar todas las entradas sin información.
--- Para el resto de entradas se observa que existe información duplicada para algunas llamadas (ivr_id)
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.document_type,
    stp.document_identification
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.document_type != 'UNKNOWN'
)
select
  count(*) as total,
  count(distinct ivr_id) as total_unique
from ivrid_document
--- Entre los registros hay ivr_id repetidos, es decir, que tienen más 
--- de una identificación
--- total: 17825 / total_unique: 17821


--- Se busca estos ivr_id repetidos
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.document_type,
    stp.document_identification
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.document_type != 'UNKNOWN'
)
select
    ivr_id,
    count(*) as total
  from ivrid_document
  group by ivr_id
  order by total DESC
limit 5;
--- (1671185617.3253191,1670865579.2748749,1671454695.29619,1671468858.31133) 2 registros

--- Se busca que identidades tienen asignadas estos registros duplicados
with ivrid_document as (
  select 
    distinct cll.ivr_id,
    stp.document_type,
    stp.document_identification
  from keepcoding.ivr_calls cll
  inner join keepcoding.ivr_steps stp
  on cll.ivr_id = stp.ivr_id
  where stp.document_type != 'UNKNOWN'
)
select *
from ivrid_document
where ivr_id in (1671185617.3253191,1670865579.2748749,1671454695.29619,1671468858.31133);
--- Por ejemplo ivr_id --> document_identification
--- 1671454695.29619 --> 10001389/10004653

--- Se busca en ivr_steps que ocurre con los registros que tienen estos ivr_id
select *
from keepcoding.ivr_steps
where ivr_id in (1671185617.3253191,1670865579.2748749,1671454695.29619,1671468858.31133)
order by ivr_id, module_sequece, step_sequence;

--- Durante estas llamadas se aportan dos identificaciones diferentes? Se decide mantener los datos
--- de identificación de las entradas que tienen como valor en campo step_name 'CUSTOMERINFOBYDNI.TX',
--- para que así allá un sólo identificador por llamada (campo ivr_id)
--- En un caso real, se consultaría con la persona conveniente.

