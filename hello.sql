drop function if exists calculated_project(cumulative_project integer, project integer, url varchar) cascade;

create function calculated_project(cumulative_project integer, project integer, url varchar) returns integer as $$
begin
  if substring(url from 0 for 8) = 'file://' then
    return project;
  else
    return cumulative_project;
  end if;
end;
$$ language plpgsql;

CREATE AGGREGATE agg_calc_project(integer, varchar)
(
    sfunc = calculated_project,
    stype = integer
);

select 
entries.id,
started_at, 
finished_at, 
substring(url from 0 for 8) as schema,
project_id,
agg_calc_project(project_id, url) over(order by started_at asc) as calc,
url
from 
entries 
inner join projects on entries.project_id = projects.id 
where 
started_at > '2014-12-17 05:43:09'
order by started_at asc;

-- lag(name, 1) over(order by started_at asc) as last_project,
-- update entries set project_id = 4 where id = 9907;

-- select * from entries where id = 9908;

create or replace function add_em(integer, integer) returns integer as $$
  select $1 + $2;
$$ language sql;

