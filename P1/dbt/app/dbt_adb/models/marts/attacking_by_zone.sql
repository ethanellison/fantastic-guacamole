with
source as (
	select * from {{ref('int_live_pb__attacks')}}
),

attacks_pivotted_on_zone as (

select
	team_id,
	opposing_team_id,
	phase,
  rotation,
	{{ dbt_utils.pivot(
		'attack_zone',
		dbt_utils.get_column_values(ref('int_live_pb__attacks'),'attack_zone'),
    agg='avg',
    then_value='evaluation_code_num'
	) }}
from 
	source
group by 
  team_id,opposing_team_id,phase,rotation
)

select * from attacks_pivotted_on_zone
