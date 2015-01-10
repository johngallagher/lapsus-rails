-- create entries from events
 begin ;
  drop table if exists entries;
  create table entries 
  as
    select 
      time                                                                          as started_at, 
      lead (time, 1) over (order by time)                                           as finished_at,
      (lead (time, 1) over (order by time) - time)                                  as duration,
      (regexp_split_to_array(url, E'(:///|://|:/)'))[1]                             as schema,
      regexp_split_to_array((regexp_split_to_array(url, E'(:///|://|:/)'))[2], '/') as path_components,
      (regexp_split_to_array(url, E'(:///|://|:/)'))[2]                             as path,
      application_bundle_id,
      application_name 
    from events;

  create temp table temp_containers on commit drop
  as 
    select 
      regexp_split_to_array(substring(path from 2), '/') as container_path_components,
      array_length(regexp_split_to_array(substring(path from 2), '/'), 1) as container_path_components_length
    from containers;

  drop table if exists projects;
  create table projects 
  as 
    select distinct 
      schema, 
      path_components[(container_path_components_length + 1)] as project_name, 
      path_components[1:(container_path_components_length + 1)] as project_path_components 
    from entries cross join temp_containers 
    where 
      path_components[1:container_path_components_length] = container_path_components and
      path_components[(container_path_components_length + 1)] <> '';

commit;

drop sequence project_id_seq;
create sequence project_id_seq;
alter table projects add column id bigserial;

select * from projects;

select * from entries;
\d+ projects;

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

