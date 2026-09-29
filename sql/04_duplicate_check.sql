SELECT 'hub_customer' table_name, customer_hk key FROM core.hub_customer GROUP BY customer_hk HAVING count(*)>1
UNION ALL SELECT 'hub_transaction', transaction_hk FROM core.hub_transaction GROUP BY transaction_hk HAVING count(*)>1
UNION ALL SELECT 'hub_product', product_hk FROM core.hub_product GROUP BY product_hk HAVING count(*)>1
UNION ALL SELECT 'hub_store', store_hk FROM core.hub_store GROUP BY store_hk HAVING count(*)>1;
