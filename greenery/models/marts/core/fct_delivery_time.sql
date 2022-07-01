{{
    config(
        materialized = 'table'
    )
}}

with order_time as (
    SELECT
        order_created_at_utc
        , estimated_delivery_at_utc
        , delivered_at_utc
        , estimated_days_to_delivery
        , days_to_delivery
        , days_to_delivery - estimated_days_to_delivery as estimation_delivery
    from {{ ref('int_user_order_status') }}
    where delivered_at_utc is NOT NULL
)

SELECT
    avg(days_to_delivery) as avg_time_to_deliver
    , avg(estimation_delivery) as avg_between_estimation_delivery
from order_time
