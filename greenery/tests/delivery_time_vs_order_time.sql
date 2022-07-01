SELECT *
FROM {{ ref('stg_greenery__orders') }}
WHERE delivered_at_utc < order_created_at_utc