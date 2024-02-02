with
source as (
  SELECT * FROM {{ ref('stg_live_pb__teams')}}
),

valid_teams as (
  SELECT 
    {{ dbt_utils.star(ref('stg_live_pb__teams')) }},
    case
      when team_name like 'M%' then 'Y'
      else 'N'
    end as valid_team
    FROM source
)

SELECT * FROM valid_teams 
