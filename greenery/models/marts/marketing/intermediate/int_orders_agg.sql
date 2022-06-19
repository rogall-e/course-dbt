{{
    config(
        materialized = 'table'
    )
}}


with ordered_products as (
    SELECT
        product_guid
        , sum(quantity) as total_quantity_ordered
    from {{ ref('stg_greenery__order_item') }}
    group by 1
)

SELECT
    stg_greenery__products.product_guid
    , stg_greenery__products.product_name
    , stg_greenery__products.price
    , stg_greenery__products.inventory
    , ordered_products.total_quantity_ordered
from {{ ref('stg_greenery__products') }}

left join ordered_products
    on ordered_products.product_guid = stg_greenery__products.product_guid