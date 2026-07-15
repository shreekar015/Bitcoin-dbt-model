{{
    config(materialized = 'incremental',
    incremental_strategy = 'append',
    )
}}


with flattened_output as (
select
tx.hash_key,
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address::string as output_address,
f.value:value::float as output_value

from

{{ref("stg_btc")}} tx,

lateral flatten (input => outputs) f
where f.value:address is not null

{% if is_incremental() %}
and tx.block_timestamp >= (select max(block_timestamp) from {{this}})
{%endif%}
)

select 
hash_key,
block_number,
block_timestamp,
is_coinbase,
output_address,
output_value
from flattened_output