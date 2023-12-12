with 

ballboost_source as (
	select * from {{ ref('stg_ballboost__serves') }}
),

speed_table as (
	select * from {{ ref('stg_speed_table__serving') }}
),

ballboost_speed_table_combined as (

SELECT
upper(RESULT) as result,
SPEED,
UPPER(OPPONENT) as opponent,
CREATED_DATE,
SUBSTR(PLAYER_NAME_CLEANED,INSTR(PLAYER_NAME_CLEANED, ' ') + 1,3) || '-' || SUBSTR(PLAYER_NAME_CLEANED, 1, 3) AS PLAYER_CODE
FROM
	ballboost_source	 

UNION ALL

SELECT
upper(RESULT) as result,
SPEED,
UPPER(OPPONENT) as opponent,
CREATED_DATE,
PLAYER_CODE
FROM
	speed_table
	
),

combined_cleaned as (
SELECT 
	rownum,
	to_date(created_date,'MM/DD/YYYY') as created_date,
	player_code,
	speed,
	case 
		when result in ('IN', 'PASS') then 'IN'
		when result in ('MISS', 'OUT') then 'MISS'
		else result
	end as result,
	opponent
	
FROM ballboost_speed_table_combined s
-- join {{ ref('stg_live_pb__teams') }} t on t.opponent like '%' || s.opponent || '%'
)
SELECT * from combined_cleaned
