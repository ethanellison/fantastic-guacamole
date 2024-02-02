with
source as (
	select * from {{ source('live_pb','live_pb') }}
),

contacts as (
	SELECT
		{{ dbt_utils.star(from=source('live_pb','live_pb'), except=['time','video_team','video_file_number','point_id']) }},
		trunc(time) as trunc_date,
    point_id as point_number,
		{{ dbt_utils.generate_surrogate_key(['match_id','file_line_number']) }} as contact_id, -- each file_line_number is unique to it's match_id
    {{ dbt_utils.generate_surrogate_key(['match_id','point_id'])}} as point_id, -- each match_id has a set of point_id
    {{ dbt_utils.generate_surrogate_key(['match_id','set_number'])}} as set_id -- each match_id has a set of point_id

	FROM	
		source
)

select * from contacts

-- TODO add identity resolution based on team name and number
-- Use search database in xata during load 
