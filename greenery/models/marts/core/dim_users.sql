{{
    config(
        materialized = 'table'
    )
}}

SELECT
    stg_greenery__users.user_guid
    , stg_greenery__users.first_name
    , stg_greenery__users.last_name
    , stg_greenery__users.email
    , stg_greenery__users.phone_number
    , case 
        when stg_greenery__users.user_updated_as_utc is NOT null then 'user_info_was_updated' 
        else 'user_info_was_not_updated'
     end as user_info_status
    , stg_greenery__addresses.address
    , stg_greenery__addresses.zipcode
    , stg_greenery__addresses.country
from {{ ref('stg_greenery__users') }}

left join {{ ref('stg_greenery__addresses') }}
    on stg_greenery__users.address_guid = stg_greenery__addresses.address_guid