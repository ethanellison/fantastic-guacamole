with source as (
  select * from {{ ref('int_live_pb__teams') }}
)

select * from source where valid_team = 'Y'
