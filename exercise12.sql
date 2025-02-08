--- EXERCISE 12
with ivr_id_vdn_aggregation as (
  select
    ivr_id,
    case
      when vdn_label like 'ATC%' then 'FRONT'
      when vdn_label like 'TECH%' then 'TECH'
      when vdn_label like 'ABSORPTION' then 'ABSORPTION'
      else 'RESTO'
    end as vdn_aggregation
  from keepcoding.ivr_calls
), ivr_id_identification as (
  select 
    ivr_id,
    document_type,
    document_identification
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYDNI.TX' and document_type != 'UNKNOWN'
), ivr_id_phone as (
  select 
      ivr_id,
      customer_phone,
  from keepcoding.ivr_steps
  where customer_phone != 'UNKNOWN'
), ivr_id_billing as (
  select 
      ivr_id,
      billing_account_id,
  from keepcoding.ivr_steps
  where step_name='CUSTOMERINFOBYPHONE.TX' and billing_account_id != 'UNKNOWN'
), ivr_id_masiva as (
  select
    ivr_id,
    1 as masiva_lg
  from keepcoding.ivr_modules
  where module_name = 'AVERIA_MASIVA'
), ivr_id_info_phone as (
  select
    ivr_id,
    1 as info_by_phone_lg
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYPHONE.TX' and step_result = 'OK'
), ivr_id_info_dni as (
  select
    distinct ivr_id,
    1 as info_by_dni_lg
  from keepcoding.ivr_steps
  where step_name = 'CUSTOMERINFOBYDNI.TX' and step_result = 'OK'
), call_phone_previous_next as (
  select
    ivr_id,
    start_date,
    lag(start_date) over(partition by phone_number order by start_date) as previous_call,
    lag(start_date) over(partition by phone_number order by start_date desc) as next_call
  from keepcoding.ivr_calls
), call_phone_diff as (
  select
    ivr_id,
    timestamp_diff(start_date,previous_call,minute) as diff_previous,
    timestamp_diff(next_call,start_date,minute) as diff_next
  from call_phone_previous_next
), call_phone_flag as (
  select
    ivr_id,
    case
      when diff_previous <= 1440 then 1
      else 0
    end as repeated_phone_24h,
    case
      when diff_next <= 1440 then 1
      else 0
    end as cause_recall_phone_24h
  from call_phone_diff
)
select
	cal.ivr_id as ivr_id,
	cal.phone_number as phone_number,
	cal.ivr_result as ivr_result,
	vdn_aggregation,
	cal.start_date as start_date,
	cal.end_date as end_date,
	cal.total_duration as total_duration,
	cal.customer_segment as customer_segment,
  cal.ivr_language as ivr_language,
  cal.steps_module as steps_module,
	cal.module_aggregation as module_aggregation,
  coalesce(document_type,'UNKNOWN') as document_type,
  coalesce(document_identification,'UNKNOWN') as document_identification,
  coalesce(customer_phone,'UNKNOWN') as customer_phone,
  coalesce(billing_account_id,'UNKNOWN') as billing_account_id,
  coalesce(masiva_lg,0) as masiva_lg,
  coalesce(info_by_phone_lg,0) as info_by_phone_lg,
  coalesce(info_by_dni_lg,0) as info_by_dni_lg,
  repeated_phone_24h,
  cause_recall_phone_24h
from keepcoding.ivr_calls cal
inner join ivr_id_vdn_aggregation agg
on cal.ivr_id = agg.ivr_id
left join ivr_id_identification ide
on cal.ivr_id = ide.ivr_id
left join ivr_id_phone pho
on cal.ivr_id = pho.ivr_id
left join ivr_id_billing bil
on cal.ivr_id = bil.ivr_id
left join ivr_id_masiva mas
on cal.ivr_id = mas.ivr_id
left join ivr_id_info_phone iph
on cal.ivr_id = iph.ivr_id
left join ivr_id_info_dni idn
on cal.ivr_id = idn.ivr_id
inner join call_phone_flag cpf
on cal.ivr_id = cpf.ivr_id;
