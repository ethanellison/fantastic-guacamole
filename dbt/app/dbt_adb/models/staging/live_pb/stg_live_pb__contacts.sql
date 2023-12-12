with
source as (
	select * from {{ source('live_pb','live_pb') }}
),

contacts as (
	SELECT
		{{ dbt_utils.star(from=source('live_pb','live_pb'), except=['time','video_team','video_file_number']) }},
		trunc(time) as trunc_date,
		{{ dbt_utils.generate_surrogate_key(['match_id','file_line_number']) }} as contact_id
	FROM	
		source
)

select * from contacts

-- TODO add identity resolution based on team name and number
