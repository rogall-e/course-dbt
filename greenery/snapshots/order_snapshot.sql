{% snapshot order_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='check',
      check_cols=['status'],
    )
  }}

  SELECT * from {{ source('src_greenery', 'orders') }}

{% endsnapshot %}