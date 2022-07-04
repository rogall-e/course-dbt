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
        sum(case when page_view >= 1 then 1 else 0 end) as total_page_views
        , sum(case when add_to_cart >= 1 then 1 else 0 end) as total_add_to_carts
        , sum(case when checkout >= 1 then 1 else 0 end) as total_checkouts
    from session_events_agg
)


select
    ROW_NUMBER() OVER (ORDER BY 2) as funnel_id
    , NOW()::date as updated_at
    , agg_total.total_page_views
    , agg_total.total_add_to_carts
    , agg_total.total_page_views - agg_total.total_add_to_carts AS diff_view_to_cart
    , ROUND((agg_total.total_add_to_carts::numeric / agg_total.total_page_views::numeric) * 100,2) AS pct_view_to_cart
    , agg_total.total_checkouts
    , agg_total.total_page_views - agg_total.total_checkouts AS diff_view_checkouts
    , ROUND((agg_total.total_checkouts::numeric / agg_total.total_page_views::numeric) * 100,2) AS pct_view_checkouts
    , agg_total.total_add_to_carts - agg_total.total_checkouts AS diff_cart_checkouts
    , ROUND((agg_total.total_checkouts::numeric / agg_total.total_add_to_carts::numeric) * 100,2) AS pct_cart_checkouts
from agg_total