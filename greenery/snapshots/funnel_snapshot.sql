{% snapshot funnel_snapshot %}

  {{
    config(
        target_schema='snapshots',
        unique_key='funnel_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
  }}

  SELECT * from {{ ref('fct_product_funnel') }}

{% endsnapshot %}