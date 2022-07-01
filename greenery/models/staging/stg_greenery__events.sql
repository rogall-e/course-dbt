{{
    config(
        materialized = 'table'
    )
}}

with event_source as (
    select * from {{ source('src_greenery', 'events') }}
)

, renamed_recast as (
    SELECT
    event_id as event_guid
    , session_id as session_guid
    , user_id as user_guid
    , event_type
    , page_url
    , created_at as event_created_at_utc
    , order_id as order_guid
    , product_id as product_guid
    from event_source
)

select * from renamed_recast