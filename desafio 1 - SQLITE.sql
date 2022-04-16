/* QUESTAO 1
Selecione os dados da tabela de pagamentos onde só apareçam os tipos de pagamento “VOUCHER” e “BOLETO”.
*/
SELECT * FROM olist_order_payments_dataset
where payment_type = 'boleto'
OR payment_type = 'voucher'

/* QUESTAO 2
Retorne os campos da tabela de produtos e calcule o volume de cada produto em um novo campo.
*/
SELECT 	*, 
		product_length_cm * product_width_cm * product_height_cm AS product_volume_cm_3
FROM olist_products_dataset

/* QUESTAO 3
Retorne somente os reviews que não tem comentários.
*/
SELECT * FROM olist_order_reviews_dataset
WHERE review_comment_message IS NULL

/* QUESTAO 4
Retorne pedidos que foram feitos somente no ano de 2017.
*/
SELECT * FROM olist_orders_dataset
WHERE strftime('%Y', order_purchase_timestamp) = '2017'
ORDER BY order_purchase_timestamp

/* QUESTAO 5
Encontre os clientes do estado de SP e que não morem na cidade de São Paulo.
*/
SELECT * FROM olist_customers_dataset
WHERE customer_state = 'SP'
AND customer_city IS NOT 'sao paulo'