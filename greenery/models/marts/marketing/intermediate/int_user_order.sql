{{
    config(
        materialized = 'table'
    )
}}


with order_item_agg as (
    select
        stg_greenery__orders.order_guid
        , stg_greenery__orders.user_guid
        , stg_greenery__orders.address_guid
        , stg_greenery__orders.order_cost
        , stg_greenery__order_item.quantity
        , stg_greenery__orders.promo_guid
    from {{ ref('stg_greenery__orders') }}
    left join {{ ref('stg_greenery__order_item') }}
        on stg_greenery__orders.order_guid = stg_greenery__order_item.order_guid
)


SELECT 
    t.user_guid
    , (t.user_orders = 1)::int as has_one_purchase
    , (t.user_orders = 2)::int as has_two_purchases
    , (t.user_orders >= 3)::int as has_three_plus_purchases
    , (t.number_promos = 0)::int as user_recieved_no_discount
    , (t.number_promos >= 1)::int as user_recieved_discount
    , t.minimum_order_cost
    , t.average_order_cost
    , t.maximum_order_cost
    , t.average_order_quantity
from  (SELECT 
    user_guid
    , count(order_guid) as user_orders
    , count(promo_guid) as number_promos
    , min(order_cost) as minimum_order_cost
    , avg(order_cost) as average_order_cost
    , max(order_cost) as maximum_order_cost
    , avg(quantity) as average_order_quantity
  from order_item_agg
  group by 1) as t

