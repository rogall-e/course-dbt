{{
    config(
        materialized = 'table'
    )
}}


select
    int_user_order.user_guid
    , stg_greenery__users.first_name
    , stg_greenery__users.last_name
    , stg_greenery__users.email
    , stg_greenery__users.address_guid
    , stg_greenery__addresses.address
    , stg_greenery__addresses.zipcode
    , stg_greenery__addresses.country
    , has_one_purchase
    , has_two_purchases
    , has_three_plus_purchases
    , user_recieved_no_discount
    , user_recieved_discount
    , minimum_order_cost
    , average_order_cost
    , maximum_order_cost 
    , ROUND(average_order_quantity) as average_order_quantity
from {{ ref('int_user_order') }}

left join {{ ref('stg_greenery__users') }}
    on int_user_order.user_guid = stg_greenery__users.user_guid
left join {{ ref('stg_greenery__addresses') }}
    on stg_greenery__users.address_guid = stg_greenery__addresses.address_guid