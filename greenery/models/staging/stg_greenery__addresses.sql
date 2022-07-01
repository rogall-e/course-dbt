{{
    config(
        materialized = 'table'
    )
}}

with address_source as (
    select * from {{ source('src_greenery', 'addresses') }}
)

, renamed_recast as (
    SELECT
    address_id as address_guid
    , address
    , zipcode
    , state
    , country
    from address_source
)

select * from renamed_recast