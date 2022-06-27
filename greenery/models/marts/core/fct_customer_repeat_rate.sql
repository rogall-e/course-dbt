{{
    config(
        materialized = 'table'
    )
}}

with orders_cohort as (
    SELECT
        user_guid
        , count(distinct order_guid) as user_orders
    from {{ ref('stg_greenery__orders') }}
    {{ dbt_utils.group_by(1) }}
)

, users_bucket as (
    SELECT
        user_guid
        , (user_orders = 1)::int as has_one_purchase
        , (user_orders >= 2)::int as has_two_purchases_or_more
    from orders_cohort
)

SELECT
    sum(has_two_purchases_or_more)::float / count(DISTINCT user_guid) as customer_repeat_rate
from users_bucket
