{{
    config(
        materialized = 'table'
    )
}}

with session_length as (
    SELECT
        session_guid
        , min(event_created_at_utc) as first_event
        , max(event_created_at_utc) as last_event
    from {{ ref('stg_greenery__events') }}
    {{ dbt_utils.group_by(1) }}
)

, session_events_agg as (
    {{ categorical_counter_agg(agg = "user_guid") }}
)



SELECT
    session_events_agg.session_guid
    , session_events_agg.user_guid
    , stg_greenery__users.first_name
    , stg_greenery__users.last_name
    , stg_greenery__users.email
    , session_events_agg.package_shipped
    , session_events_agg.page_view
    , session_events_agg.checkout
    , session_events_agg.add_to_cart
    , session_length.first_event as first_session_event
    , session_length.last_event as last_session_event
    , session_length.last_event - session_length.first_event as session_length
from session_events_agg


left join  {{ ref('stg_greenery__users') }}
    on session_events_agg.user_guid = stg_greenery__users.user_guid
left join session_length
    on session_events_agg.session_guid = session_length.session_guid