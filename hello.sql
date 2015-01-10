-- create entries from events
   begin ;
  create temp table entries
      on commit
    drop as
  select 
  time as started_at, 
  lead (time, 1) over (order by time) as finished_at,
  (lead (time, 1) over (order by time) - time) as duration,
  regexp_split_to_array(url, E'(:///|://|:/)'),
  url,
  application_bundle_id,
  application_name 
    from events;
  select *
    from entries; commit;

-- Calculate last active project
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

create aggregate agg_calc_project(integer, varchar)
(
    sfunc = calculated_project,
    stype = integer
);

-- create table events as
-- select 
-- started_at as time,
-- 'document_change' as type,
-- application_bundle_id,
-- application_name,
-- url
-- from entries 
-- where url != ''
-- order by started_at asc;

-- select 
-- entries.id,
-- started_at, 
-- finished_at, 
-- substring(url from 0 for 8) as schema,
-- project_id,
-- agg_calc_project(project_id, url) over(order by started_at asc) as calc,
-- url
-- from entries 
-- inner join projects on entries.project_id = projects.id 
-- order by started_at asc;

