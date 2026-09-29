select customer_hk from {{ ref('hub_customer') }} group by customer_hk having count(*) > 1
union all
select transaction_hk from {{ ref('hub_transaction') }} group by transaction_hk having count(*) > 1
union all
select product_hk from {{ ref('hub_product') }} group by product_hk having count(*) > 1
union all
select store_hk from {{ ref('hub_store') }} group by store_hk having count(*) > 1
