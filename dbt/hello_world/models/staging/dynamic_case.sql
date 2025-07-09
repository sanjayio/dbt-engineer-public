{{ config(materialized='view') }}

{% set email_provider_mapping = {
  "gmail.com": {"company": "Google", "country": "US"},
  "yahoo.com": {"company": "Yahoo", "country": "US"},
  "hotmail.com": {"company": "Microsoft", "country": "US"},
  "outlook.com": {"company": "Microsoft", "country": "US"},
  "aol.com": {"company": "AOL", "country": "US"},
  "protonmail.com": {"company": "Proton", "country": "CH"},
  "posteo.de": {"company": "Posteo", "country": "DE"},
  "gmx.net": {"company": "GMX", "country": "DE"},
  "zoho.com": {"company": "Zoho", "country": "IN"}
} %}

select
  name,
  email,
  case
    {% for key, value in email_provider_mapping.items() %}
      when email like '%{{ key }}' then '{{ value.company }}'
    {% endfor %}
    else 'other'
  end as email_provider,
  case
    {% for key, value in email_provider_mapping.items() %}
      when email like '%{{ key }}' then '{{ value.country }}'
    {% endfor %}
    else 'other'
  end as country
from {{ ref('raw_emails') }}
