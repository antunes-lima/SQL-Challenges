/* QUESTAO 1
Crie os índices apropriadaos para as tabelas do nosso modelo de dados com o intuito de melhorar a performance.
*/
CREATE INDEX idx_customer ON olist_customers_dataset (customer_id);
CREATE INDEX idx_customer2 ON olist_orders_dataset (customer_id);

CREATE INDEX idx_order ON olist_orders_dataset (order_id);
CREATE INDEX idx_order2 ON olist_order_items_dataset (order_id);
CREATE INDEX idx_order3 ON olist_order_payments_dataset (order_id);
CREATE INDEX idx_order4 ON olist_order_reviews_dataset (order_id);

CREATE INDEX idx_product ON olist_order_items_dataset (product_id);
CREATE INDEX idx_product2 ON olist_products_dataset (product_id);

CREATE INDEX idx_seller ON olist_order_items_dataset (seller_id);
CREATE INDEX idx_seller2 ON olist_sellers_dataset (seller_id);

CREATE INDEX idx_geolocation ON olist_geolocation_dataset (geolocation_zip_code_prefix);
CREATE INDEX idx_geolocation2 ON olist_customers_dataset (customer_zip_code_prefix);
CREATE INDEX idx_geolocation3 ON olist_sellers_dataset (seller_zip_code_prefix);


/* QUESTAO 2 (Opcional)
Crie índices cluesterizados. Lembre-se que, para isso, você deverá recriar a tabela para poder criar as Primary e Foreign Keys.
*/
CREATE TABLE "clustered_customers" (
"customer_id" TEXT PRIMARY KEY,
"customer_unique_id" TEXT,
"customer_zip_code_prefix" INTEGER,
"customer_city" TEXT,
"customer_state" TEXT
) WITHOUT ROWID;
INSERT INTO clustered_customers SELECT * FROM olist_customers_dataset;
CREATE TABLE "clustered_orders" (
"order_id" TEXT PRIMARY KEY,
"customer_id" TEXT,
"order_status" TEXT,
"order_purchase_timestamp" TEXT,
"order_approved_at" TEXT,
"order_delivered_carrier_date" TEXT,
"order_delivered_customer_date" TEXT,
"order_estimated_delivery_date" TEXT
) WITHOUT ROWID;
INSERT INTO clustered_orders SELECT * FROM olist_orders_dataset;
CREATE TABLE "clustered_sellers" (
"seller_id"	TEXT PRIMARY KEY,
"seller_zip_code_prefix"	INTEGER,
"seller_city"	TEXT,
"seller_state"	TEXT
) WITHOUT ROWID;
INSERT INTO clustered_sellers SELECT * FROM olist_sellers_dataset;
CREATE TABLE "clustered_products" (
"product_id" TEXT PRIMARY KEY,
"product_category_name" TEXT,
"product_name_lenght" REAL,
"product_description_lenght" REAL,
"product_photos_qty" REAL,
"product_weight_g" REAL,
"product_length_cm" REAL,
"product_height_cm" REAL,
"product_width_cm" REAL
) WITHOUT ROWID;
INSERT INTO clustered_products SELECT * FROM olist_products_dataset;
DROP TABLE olist_customers_dataset;
DROP TABLE olist_orders_dataset;
DROP TABLE olist_sellers_dataset;
DROP TABLE olist_products_dataset;
/* OBS: 
Tabela order_payments usa a KEY estrangeira order_id, não tem chave primária
Tabela order_items não tem valores únicos de order_item_id
Tabela geolocation não tem valores únicos de zipcode_prefix
Tabela order_reviews não tem valores únicos de review_id
*/
