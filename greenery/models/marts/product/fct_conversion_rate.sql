{{
    config(
        materialized = 'table'
    )
}}



WITH event_types AS(
SELECT 
    session_guid
    , MAX(case when event_type = 'checkout' then 1 else 0 end) as checkouts
    , MAX(case when event_type = 'page_view' then 1 else 0 end) as page_views
FROM 
		{{ ref('stg_greenery__events') }}
{{ dbt_utils.group_by(1) }}
)

, agg as (
SELECT
  	sum(event_types.page_views)::float as num_page_views
  	, sum(event_types.checkouts)::float as num_event_checkouts
FROM 
  	event_types
)
SELECT 
    num_event_checkouts
    , num_page_views
    , (num_event_checkouts/num_page_views)::float * 100 as conversion_rate
FROM 
  	agg