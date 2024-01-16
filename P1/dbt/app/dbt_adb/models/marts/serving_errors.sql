with 
source as (
	select * from {{ref('int_live_pb__serves')}} where serves_evaluation_short = 'Error'
),

serve_errors_pivotted_on_evaluation_long as (

select
	player_id,
	match_id,
	receiving_team,
	{{ dbt_utils.pivot(
		'serves_evaluation_long',
		dbt_utils.get_column_values(ref('int_live_pb__serves'),'serves_evaluation_long')
	) }}
from 
	source
group by 
	player_id,match_id,receiving_team

),

serve_errors_pivotted_joined_to_matches as (
SELECT 
	s.*,
	m.sort_id as sort_id,
	m.sort_id || '-' || receiving_team as match_name
FROM 
	serve_errors_pivotted_on_evaluation_long s
join {{ ref('int_live_pb__matches') }} m on m.match_id = s.match_id
)

select * from serve_errors_pivotted_joined_to_matches 

