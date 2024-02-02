with
source as (
	select * from {{ref('int_live_pb__attacks')}}
),

attacks_pivotted_on_evaluation as (

select
	player_id,
	opposing_team_id,
  match_id,
	phase,
	{{ dbt_utils.pivot(
		'evaluation',
		dbt_utils.get_column_values(ref('int_live_pb__attacks'),'evaluation'),
    agg='count',
    then_value='contact_id',
    else_value='null',
    prefix='Number of ',
    distinct=True
	) }}
from 
	source
group by 
	player_id,opposing_team_id,phase,match_id
)

select * from attacks_pivotted_on_evaluation
