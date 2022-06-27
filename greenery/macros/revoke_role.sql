{% macro revoke_select_on_tables(schema, table, user) %}

  revoke select on all {{table}} in schema {{ schema }} from {{ user }};
      
{% endmacro %}