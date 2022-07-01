{{
    config(
        materialized = 'table'
    )
}}

with promo_agg as (
    SELECT
        order_guid
        , promo_guid
        , discount
        , order_cost
        , quantity
    from {{ ref('int_order_promo_agg') }}
)

, avg_wo_promo as (
    select 
        avg(order_cost) as avg_order_cost_wo_discount
        , avg(quantity) as avg_quantity_wo_discount
    from promo_agg
    where promo_guid is null
)

, avg_with_promo as (
    SELECT
        avg(order_cost) as avg_order_cost_with_discount
        , avg(quantity) as avg_quantity_with_discount
    from promo_agg
    where promo_guid is not null
)

, promo_groups as (
    SELECT
        order_guid
        , (promo_guid is null)::int as no_promo
        , (promo_guid is not null)::int promo
    from promo_agg
)
, percantage_promo as (
    SELECT 
        (sum(promo)::float / count(distinct order_guid)) * 100 as percantage_promo_order
    from promo_groups
)

SELECT
    avg_wo_promo.avg_order_cost_wo_discount
    , avg_wo_promo.avg_quantity_wo_discount
    , avg_with_promo.avg_order_cost_with_discount
    , avg_with_promo.avg_quantity_with_discount
    , percantage_promo.percantage_promo_order
from avg_wo_promo, avg_with_promo, percantage_promo