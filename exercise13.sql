--- exercise 13
create or replace function keepcoding.fnc_clean_integer(num int64) returns int64 as
(( select ifnull(num, -999999, num)))

