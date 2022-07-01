{% macro categorical_counter_agg(agg="None")  %}

    {%
    set event_types = dbt_utils.get_query_results_as_dict(
        "select distinct quote_literal(event_type) as event_type, event_type as column_name from"
        ~ ref('stg_greenery__events')
    )
    %}
   {% if agg == "None" %}
        SELECT
        session_guid
        {% for event_type in event_types['event_type'] %}
        , sum(case when event_type = {{ event_type }} then 1 else 0 end) as {{ event_type.replace("'", '"') }}
        {% endfor %}
        from {{ ref('stg_greenery__events') }}
        {{ dbt_utils.group_by(1) }}
    {% else %}
        SELECT
        session_guid
        , {{ agg }}
        {% for event_type in event_types['event_type'] %}
        , sum(case when event_type = {{ event_type }} then 1 else 0 end) as {{ event_type.replace("'", '"') }}
        {% endfor %}
        from {{ ref('stg_greenery__events') }}
        {{ dbt_utils.group_by(2) }}
    {% endif %}      
{% endmacro %}