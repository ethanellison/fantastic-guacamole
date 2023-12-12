with
player_serves as (
SELECT 
	s.result,
	s.speed,
	s.opponent,
	to_char(s.created_date,'DS') as created_date,
	p.code as player_code,
	p.id as player_id
FROM {{ source('serve_speeds','serves') }} s
left join {{ source('serve_speeds','players') }} p
on s.player = p.id 
)

select * from player_serves
