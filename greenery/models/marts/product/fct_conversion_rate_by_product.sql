{{
    config(
        materialized = 'table'
    )
}}

with session_events_agg as (
    {{ categorical_counter_agg(agg = "product_guid") }}
)
, product_page_view as(
    SELECT
        session_events_agg.product_guid
        , stg_greenery__products.product_name
        , sum(session_events_agg.page_view) as num_page_view
    from session_events_agg
    left join  {{ ref('stg_greenery__products') }}
        on session_events_agg.product_guid = stg_greenery__products.product_guid
    {{ dbt_utils.group_by(2) }}
)

, product_check_outs as (
    SELECT 
        stg_greenery__order_item.product_guid
        , count(distinct stg_greenery__events.session_guid) as num_checkout
    from {{ ref('stg_greenery__events') }}
    left join {{ ref('stg_greenery__order_item') }}
        on stg_greenery__order_item.order_guid = stg_greenery__events.order_guid
    where stg_greenery__events.event_type = 'checkout'
    {{ dbt_utils.group_by(1) }}
)

SELECT
    product_page_view.product_guid
    , product_page_view.product_name
    , product_page_view.num_page_view
    , product_check_outs.num_checkout
    , ROUND(product_check_outs.num_checkout::numeric / product_page_view.num_page_view::numeric * 100, 2) AS product_conversion_rate
from product_page_view
LEFT JOIN product_check_outs
    on product_check_outs.product_guid = product_page_view.product_guid