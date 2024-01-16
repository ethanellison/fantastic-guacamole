with
source as (

SELECT * FROM {{ source('serve_speeds','ballboost') }}

),

ballboost_serves as (

SELECT 
	state as result,
	SPEED_KM_H as speed,
	OPPONENT_TEAM as opponent,
	to_char(date_,'DS') as created_date,
	replace(player,'-','') as player_name_cleaned
FROM source
)

select * from ballboost_serves


