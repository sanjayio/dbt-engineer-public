{{ config(materialized='view') }}

SELECT '{{ var("name") }}' as name