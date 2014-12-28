# To Do

 * We should train projects in batch using sql windowing functions
 * This will improve performance when changing the containers.

```
select 
 entries.id,
 started_at,
 name as project,
 lag(name, 1) over (order by started_at) as prev_project 
 from entries inner join projects on entries.project_id = projects.id 
 order by started_at DESC 
 limit 100;
```
