--- EXERCISE 11
with call_phone_previous_next as (
select
  ivr_id,
  phone_number,
  start_date,
  lag(start_date) over(partition by phone_number order by start_date) as previous_call,
  lag(start_date) over(partition by phone_number order by start_date desc) as next_call
from keepcoding.ivr_calls
), call_phone_diff as (
  select
    ivr_id,
    phone_number,
    start_date,
    previous_call,
    next_call,
    timestamp_diff(start_date,previous_call,minute) as diff_previous,
    timestamp_diff(next_call,start_date,minute) as diff_next
  from call_phone_previous_next
), call_phone_flag as (
  select
    ivr_id,
    phone_number,
    start_date,
    previous_call,
    next_call,
    diff_previous,
    diff_next,
    case
      when diff_previous <= 1440 then 1
      else 0
    end as repeated_phone_24h,
    case
      when diff_next <= 1440 then 1
      else 0
    end as cause_recall_24h
  from call_phone_diff
)
select 
  ivr_id,
  repeated_phone_24h,
  cause_recall_24h
from call_phone_flag;

