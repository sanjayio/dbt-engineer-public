{{ config(materialized='view') }}

{% set company_columns = [
  { "name": "google", "columns": ["name", "email"] },
  { "name": "yahoo", "columns": ["name", "country"] },
  { "name": "microsoft", "columns": ["email", "email_provider"] }
] %}

with google_users as (
  select *
  from {{ ref('dynamic_case') }}
  where email_provider = 'Google'
),
yahoo_users as (
  select *
  from {{ ref('dynamic_case') }}
  where email_provider = 'Yahoo'
),
microsoft_users as (
  select *
  from {{ ref('dynamic_case') }}
  where email_provider = 'Microsoft'
)

{% for company in company_columns %}
select
  {% for column in company.columns %}
    {{ column }}
    {% if not loop.last %}, {% endif %}
  {% endfor %}
from {{ company.name }}_users
{% if not loop.last %}
union all
{% endif %}
{% endfor %}