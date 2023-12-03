
-- Use the `ref` function to select from other models

{{ config(materialized='table') }}

select distinct
player_id,
player_name,
player_number
from LIVE_PB
where player_id is not null