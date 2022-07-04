{{
    config(
        materialized = 'table'
    )
}}

with session_events_agg as (
    {{ categorical_counter_agg(agg = "user_guid") }}
)
, agg_total as (
    select 
        sum(page_view) as total_page_views
        , sum(add_to_cart) as total_add_to_carts
        , sum(checkout) as total_checkouts
    from session_events_agg
)
, agg_avg as(
        select 
        ROUND(AVG(page_view),2) as avg_page_views
        , ROUND(AVG(add_to_cart),2) as avg_add_to_carts
        , ROUND(AVG(checkout),2) as avg_checkouts
    from session_events_agg
)


select
    ROW_NUMBER() OVER (ORDER BY 2) as funnel_id
    , NOW()::date as updated_at
    , agg_total.total_page_views
    , agg_avg.avg_page_views
    , agg_total.total_add_to_carts
    , agg_avg.avg_add_to_carts
    , agg_total.total_page_views - agg_total.total_add_to_carts AS diff_view_to_cart
    , ROUND((agg_total.total_add_to_carts / agg_total.total_page_views) * 100,2) AS pct_view_to_cart
    , agg_total.total_checkouts
    , agg_avg.avg_checkouts
    , agg_total.total_page_views - agg_total.total_checkouts AS diff_view_checkouts
    , ROUND((agg_total.total_checkouts / agg_total.total_page_views) * 100,2) AS pct_view_checkouts
from agg_total, agg_avg