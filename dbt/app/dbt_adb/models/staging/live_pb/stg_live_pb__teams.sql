with
source as (
	select * from {{ source('live_pb','live_pb') }}
),

teams as (
	SELECT DISTINCT 
		upper(team_id) as team_id,
		upper(team) as team_name
	FROM source
	where team_id is not null
)

SELECT * FROM teams
