{% macro grant_select_on_all_tables_in_source_schemas(user) %}

  {% set all_source_schemas = ["dbt_eike_r_marketing", "dbt_eike_r_production", "dbt_eike_r_reporting", "dbt_eike_r_staging"] %}
  grant usage on schema {{ all_source_schemas|join(', ') }} to {{ user }};
  {% for schemas in all_source_schemas %}
  grant select on all tables in schema {{ schemas }} to {{ user }};
  {% endfor %}
{% endmacro %}