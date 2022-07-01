{{
    config(
        materialized = 'table'
    )
}}


SELECT 
    stg_greenery__orders.order_guid
    , stg_greenery__orders.promo_guid
    , stg_greenery__promos.discount
    , stg_greenery__orders.order_cost
    , stg_greenery__order_item.quantity
from {{ ref('stg_greenery__orders') }}
left join {{ ref('stg_greenery__promos') }}
    on stg_greenery__promos.promo_guid = stg_greenery__orders.promo_guid
left join {{ ref('stg_greenery__order_item') }}
    on stg_greenery__order_item.order_guid = stg_greenery__orders.order_guid

