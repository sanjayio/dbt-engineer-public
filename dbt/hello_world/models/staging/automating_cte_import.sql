{{ config(materialized='view') }}

{% set email_companies_with_filters = [
  { "name": "google", "filter": "name like '%John%'" },
  { "name": "yahoo", "filter": "name like '%Jill%'" },
  { "name": "microsoft", "filter": "name like '%Doe%'" }
] %}

with
{% for company in email_companies_with_filters %}
  {{ company.name }}_cte as (
    select * from {{ ref('dynamic_case') }}
    where {{ company.filter }}
  ){% if not loop.last %},{% endif %}
{% endfor %}

select * from microsoft_cte