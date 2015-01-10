 begin ;

  -- Create temp containers
  create temp table temp_containers on commit drop
  as 
    select 
      regexp_split_to_array(substring(path from 2), '/') as container_path_components,
      array_length(regexp_split_to_array(substring(path from 2), '/'), 1) as container_path_components_length
    from containers;

  -- Create temp entries without project
  create temp table entries_without_project on commit drop 
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

  -- Create temp projects
  drop table if exists projects;
  create table projects 
  as 
    select distinct 
      false as none,
      schema, 
      path_components[(container_path_components_length + 1)] as name, 
      path_components[1:(container_path_components_length + 1)] as project_path_components,
      (container_path_components_length + 1) as project_path_components_length
    from entries_without_project cross join temp_containers 
    where 
      path_components[1:container_path_components_length] = container_path_components and
      path_components[(container_path_components_length + 1)] <> '';

  -- Add preset "None" project
  insert into projects values (true, '', 'None', NULL, NULL);

  -- Add id to projects
  drop sequence project_id_seq;
  create sequence project_id_seq;
  alter table projects add column id bigserial;

  -- Train entries
  -- Create entries by adding project id to entries_without_project table
  create temp table entries_with_project on commit drop 
  as
    select *, 
      (select id from projects 
        where project_path_components = entries_without_project.path_components[1:project_path_components_length]
        limit 1) as project_id
      from entries_without_project;

  -- Set anything without a project to be none
  update entries_with_project set project_id = (select id from projects where none = true limit 1) where project_id is null;

  -- Calculate last active project
  -- Add user defined functions for last active project
  drop function if exists last_active_project(cumulative_project bigint, project bigint, scheme text) cascade;
  create function last_active_project(cumulative_project bigint, project bigint, scheme text) returns bigint as $$
    begin
      if scheme = 'file' then
        return project;
      else
        return cumulative_project;
      end if;
    end;
  $$ language plpgsql;

  create aggregate agg_last_active_project(bigint, text)
  (
      sfunc = last_active_project,
      stype = bigint
  );

  -- Create entries complete with last active project
  drop table if exists entries;
  create table entries
  as
    select *, agg_last_active_project(entries_with_project.project_id, entries_with_project.schema) over(order by started_at asc) as last_active_project_id
    from entries_with_project;

commit;

-- Print out results
select * from projects;
select * from entries;
