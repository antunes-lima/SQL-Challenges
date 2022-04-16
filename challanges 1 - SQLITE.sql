/* EXERCISE 1
Select data from the payment table where the payment type is either “VOUCHER” or “BOLETO”.
*/
SELECT * FROM olist_order_payments_dataset
WHERE payment_type = 'boleto'
OR payment_type = 'voucher'


/* EXERCISE 2
Return all the fields from the products table and calculate the volume of each product in a new field.
*/
SELECT 	*, 
		product_length_cm * product_width_cm * product_height_cm AS product_volume_cm_3
FROM olist_products_dataset


/* EXERCISE 3
Return only reviews that do not have comments.
*/
SELECT * FROM olist_order_reviews_dataset
WHERE review_comment_message IS NULL


/* EXERCISE 4
Return orders that were placed in the year 2017 only.
*/
SELECT * FROM olist_orders_dataset
WHERE strftime('%Y', order_purchase_timestamp) = '2017'
ORDER BY order_purchase_timestamp


/* EXERCISE 5
Find customers from the state of SP that do not live in the city of São Paulo.
*/
SELECT * FROM olist_customers_dataset
WHERE customer_state = 'SP'
AND customer_city IS NOT 'sao paulo'
