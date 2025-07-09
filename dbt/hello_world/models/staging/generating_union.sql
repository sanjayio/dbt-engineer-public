{{ config(materialized='view') }}

{% set email_companies = ["google", "yahoo", "microsoft"] %}

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

{% for email_company in email_companies %}
select
  name,
  email,
  email_provider,
  country
from {{ email_company }}_users
{% if not loop.last %}
union all
{% endif %}
{% endfor %}