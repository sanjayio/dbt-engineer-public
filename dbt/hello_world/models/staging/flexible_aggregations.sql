{{ config(materialized='view') }}

{% set companies = [{
  "name": "google",
  "filter": "email_provider = 'Google'"
}, {
  "name": "yahoo",
  "filter": "email_provider = 'Yahoo'"
}, {
  "name": "microsoft",
  "filter": "email_provider = 'Microsoft'"
}] %}
{% set metrics = [{
  "name": "count",
  "sql": "count(*)"
}, {
  "name": "count_distinct",
  "sql": "count(distinct email)"
}] %}

select
  {% for company in companies %}
    {% for metric in metrics %}
      {{ metric.sql }} as {{ company.name }}_{{ metric.name }}
      {% if not loop.last %}, {% endif %}
    {% endfor %}
    {% if not loop.last %}, {% endif %}
  {% endfor %}
from {{ ref('dynamic_case') }}