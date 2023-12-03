
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

select distinct team_id, team
from LIVE_PB 
where team is not null
/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
