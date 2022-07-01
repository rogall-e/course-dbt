{{
    config(
        materialized = 'table'
    )
}}



with products as (
    select
        product_guid
        , product_name
        , price
        , inventory
        , total_quantity_ordered
    from {{ ref('int_orders_agg') }}
)

SELECT
    product_guid
    , product_name
    , price
    , inventory
    , total_quantity_ordered
    , CASE
        when inventory > total_quantity_ordered then 'sufficient'
        when inventory = total_quantity_ordered then 'sufficient_but_has_to_be_replenished'
        when inventory < total_quantity_ordered then 'not_sufficient_has_to_be_replenished'
     END as inventory_status
from products