--- EXERCISE 5
--- Se asume que interesan sólamente las ivr_id que tienen identificación asociada se realiza un 
--- inner join y se suprimen todas las entradas que tengan document_type como UNKNOWN.
--- Existen cuatro identificadores ivr_id para las que se tienen dos identificaciones diferentes.
--- A continuación de esta query se muestra el análisis realizado
select 
    distinct cll.ivr_id,
    stp.document_type,
    stp.document_identification
from keepcoding.ivr_calls cll
inner join keepcoding.ivr_steps stp
on cll.ivr_id = stp.ivr_id
where stp.document_type != 'UNKNOWN'

--- ANALISIS IDENTIFICADOR UNICO
--- Como se quieren identificaciones únicas para cada llamada (ivr_id),
--- se comprueba que todas las llamadas tienen identificadores únicos
--- (document_type, document_identification)
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
order by ivr_id;

--- Durante estas llamadas se aportan dos identificaciones diferentes? Llegado a este punto,
--- si esto fuera un caso real se me ocurre dejar toda la información y comentar las duplicidades
--- a la persona que vaya a recibir la información

