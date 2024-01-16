with
source as (

SELECT
    max(rownum) as sort_id,
    MATCH_ID as match_id,
    HOME_TEAM as home_team,
    VISITING_TEAM as visiting_team
FROM
	{{ source('live_pb','live_pb') }}
GROUP BY
    MATCH_ID,
    HOME_TEAM,
    VISITING_TEAM
order by 1

)

select * from source
