WITH BASE AS (
    select *
    from {{ ref('whales_alert') }}
    order by total_sent desc
    limit 10
)
select *
from BASE
