{{
    config(
        materialized = 'table'
    )
}}

with order_item_source as (
    select * from {{ source('src_greenery', 'order_items') }}
)

, renamed_recast as (
    SELECT
    order_id as order_guid
    , product_id as product_guid
    , quantity
    from order_item_source
)

select * from renamed_recast