CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS marts;

CREATE TABLE IF NOT EXISTS staging.sales_raw (
    transaction_id text NOT NULL,
    product_id text NOT NULL,
    amount numeric(10,2) NOT NULL,
    oquantity numeric(10,3) NOT NULL,
    store_id text NOT NULL,
    datetime timestamp NOT NULL,
    load_date date NOT NULL,
    source_file text NOT NULL,
    loaded_at timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (transaction_id, product_id, datetime)
);

CREATE TABLE IF NOT EXISTS staging.clients_raw (
    client_id integer PRIMARY KEY,
    full_name varchar(255),
    birth_date date,
    phone varchar(20),
    email varchar(255),
    registration_date date,
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staging.cards_raw (
    card_id integer PRIMARY KEY,
    client_id integer,
    card_number varchar(50),
    issue_date date,
    status varchar(20),
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staging.loyalty_transactions_raw (
    loyalty_transaction_id integer PRIMARY KEY,
    card_id integer,
    points integer,
    transaction_date timestamp,
    store_id text,
    source_transaction_id text,
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staging.hr_raw (
    employee_id integer PRIMARY KEY,
    full_name text,
    position text,
    store_id text,
    hire_date date,
    termination_date date,
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staging.products_raw (
    product_id text PRIMARY KEY,
    product_name text,
    category text,
    brand text,
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staging.stores_raw (
    store_id text PRIMARY KEY,
    address text,
    region text,
    phone text,
    store_type text,
    loaded_at timestamp NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_sales_raw_load_date ON staging.sales_raw(load_date);
CREATE INDEX IF NOT EXISTS ix_sales_raw_transaction ON staging.sales_raw(transaction_id);
CREATE INDEX IF NOT EXISTS ix_loyalty_source_tx ON staging.loyalty_transactions_raw(source_transaction_id);
