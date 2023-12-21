with
source as (
    select 
	{{ dbt_utils.star(ref('stg_live_pb__contacts'), except=['file_line_number','point_id']) }},
	{{ dbt_utils.generate_surrogate_key(['match_id','point_id']) }} as point_id
	from {{ ref('stg_live_pb__contacts')}}
	where phase = 'Reception'
),

receives as (
    SELECT
	LISTAGG(EVALUATION_CODE, ', ') as evaluation_code_agg,
        LISTAGG(SKILL, ', ') as skill_agg,
	LISTAGG(END_ZONE, ', ') as end_zone_agg,
        listagg(player_name,', ') as player_name_agg,
	POINT_ID,
        receiving_team,
        point_won_by
    FROM source
    where skill in ('Reception','Set')
    GROUP BY
	point_id,
	receiving_team,
	point_won_by
)

SELECT
    * 
    FROM receives 
