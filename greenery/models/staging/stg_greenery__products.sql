{{
    config(
        materialized = 'table'
    )
}}

with product_source as (
    select * from {{ source('src_greenery', 'products') }}
)

, renamed_recast as (
    SELECT
    product_id as product_guid
    , name as product_name
    , price
    , inventory
    from product_source
)

select * from renamed_recast