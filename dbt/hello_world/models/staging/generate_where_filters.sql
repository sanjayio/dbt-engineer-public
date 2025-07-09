{{ config(materialized='view') }}

{% set banned_countries = ["US", "DE", "IN"] %}

select *
from {{ ref('dynamic_case') }}
where country not in (
  {% for country in banned_countries %}
    '{{ country }}'{% if not loop.last %}, {% endif %}
  {% endfor %}
)