{{
    config(
        materialized = 'table'
    )
}}


with order_status_agg as(
    SELECT
        user_guid
        , order_guid
        , order_created_at_utc
        , estimated_delivery_at_utc
        , delivered_at_utc
        , order_status
        , estimated_delivery_at_utc - order_created_at_utc AS estimated_days_to_delivery
        , delivered_at_utc - order_created_at_utc AS days_to_delivery
    from {{ ref('stg_greenery__orders') }}
)


SELECT
    user_guid
    , order_created_at_utc
    , estimated_delivery_at_utc
    , delivered_at_utc
    , order_status
    , estimated_days_to_delivery
    , days_to_delivery
    , case
        when estimated_days_to_delivery < days_to_delivery 
        or estimated_days_to_delivery < days_to_delivery then 'delay'
        when estimated_days_to_delivery > days_to_delivery then 'in_time'
        when estimated_days_to_delivery = days_to_delivery then 'in_time'
        when estimated_days_to_delivery is null then 'preparing'
        else 'pending'
    end as delivery_status
from order_status_agg