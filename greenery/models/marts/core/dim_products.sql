{{
    config(
        materialized = 'table'
    )
}}


SELECT
    product_guid
    , product_name
    , price
    , inventory
from {{ ref('stg_greenery__products') }}