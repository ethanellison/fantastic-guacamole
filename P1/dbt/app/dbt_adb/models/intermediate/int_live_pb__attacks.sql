with
attacks as (
  SELECT
    {{ dbt_utils.star(ref('stg_live_pb__contacts'), except=['file_line_number']) }}
  FROM {{ ref('stg_live_pb__contacts') }} 
  where skill = 'Attack' and START_ZONE > 0
),

attacking as (
  SELECT DISTINCT
    {{ dbt_utils.star(ref('stg_live_pb__contacts'), except=['file_line_number','SETTER_POSITION']) }},
    case
      when TS_PASS_EVALUATION_CODE in ('+', '#') then 'IN SYSTEM'
      else 'OUT SYSTEM'
    end as IN_OUT_SYSTEM,
    case
      when EVALUATION_CODE = '#' then 1
      when EVALUATION_CODE in ('=', '/') then -1
      else 0
    end as EVALUATION_CODE_NUM,
    case
      when NUM_PLAYERS_NUMERIC < 0 then null
      else NUM_PLAYERS
    end as blockers_desc,
    SETTER_POSITION as ROTATION,
    CASE
        WHEN ATTACK_DESCRIPTION LIKE 'MIDDLE%' THEN 'MID'
        WHEN START_ZONE IN (3,8) THEN 'MID'
        WHEN START_ZONE IN (2,9) THEN 'RS'
        WHEN START_ZONE IN (4) THEN 'LS'
        ELSE ATTACK_DESCRIPTION 
    END as attack_zone,
    case 
      when team_id = home_team_id then visiting_team_id
      else home_team_id
    end as opposing_team_id
  FROM
    attacks
  order by SETTER_POSITION
)

select * from attacking
