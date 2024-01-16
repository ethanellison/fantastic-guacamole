{% set evaluation_codes = ["#","+","-","=","/","!"] %} 

with
serves as (
SELECT
	{{ dbt_utils.star(ref('stg_live_pb__contacts'), except=['file_line_number']) }}
FROM {{ ref('stg_live_pb__contacts') }} where skill = 'Serve'
),

serves_augmented as (
SELECT
	s.*,
	m.sort_id as sort_id,
	CASE
	WHEN s.EVALUATION_CODE = '=' THEN
		s.EVALUATION
		|| ', '
	        || s.SPECIAL_CODE
	ELSE
		s.EVALUATION
	END AS SERVES_EVALUATION_long,
	case
	when instr(s.evaluation,',') > 0 then
		substr(s.evaluation,1,instr(s.evaluation,',')-1)
	else 
		s.evaluation
	end as serves_evaluation_short
FROM
	serves s
inner join {{ ref('int_live_pb__matches') }} m on s.match_id = m.match_id
)

SELECT * FROM serves_augmented 


