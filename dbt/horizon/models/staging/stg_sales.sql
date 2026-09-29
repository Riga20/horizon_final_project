select transaction_id, product_id, amount::numeric(10,2) as amount,
oquantity::numeric(10,3) as quantity, store_id, datetime::timestamp as transaction_datetime,
load_date, source_file from {{ source('staging','sales_raw') }}