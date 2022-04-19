/* EXERCISE 1
Return the number of items sold in each category by state the customer is in, showing only categories that have sold more than 1000 items.
*/
SELECT	count(Products.product_id) AS Quantity,
	Products.product_category_name AS Category,
	Customers.customer_state AS State
FROM olist_customers_dataset AS Customers
INNER JOIN olist_orders_dataset AS Orders ON Orders.customer_id = Customers.customer_id
INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Orders.order_id
INNER JOIN olist_products_dataset AS Products ON Products.product_id = Items.product_id
GROUP BY Category, State
HAVING Quantity > 1000
ORDER BY State, Quantity DESC

/* EXERCISE 2
Show the 5 customers (customer_id) who spent the most money on purchases, the total value of all their purchases, quantity of purchases, and average amount spent per purchases.
Order them in descending order by the average purchase value.
*/
WITH Top_5_Customers AS
	(SELECT 
	Customers.customer_unique_id AS Customer_ID,
	SUM(Payments.payment_value) AS Total_Purchase_Amount,
	count(Orders.order_id) AS Purchase_Quantity,
	avg(Payments.payment_value) AS Avg_Purchase_Value
	FROM olist_customers_dataset AS Customers
	INNER JOIN olist_orders_dataset AS Orders ON Orders.customer_id = Customers.customer_id
	INNER JOIN olist_order_payments_dataset AS Payments ON Pagamentos.order_id = Orders.order_id
	WHERE Orders.order_status NOT IN ('canceled')
	GROUP BY Customer_ID
	ORDER BY Total_Purchase_Amount DESC
	LIMIT 5)
SELECT *
FROM Top_5_Customers
ORDER BY Avg_Purchase_Value DESC
/* Obs: "customer_unique_id" is the actual unique identifier for each client, according to the dataset information on Kaggle. 
"customer_id" is a value generated for each order ("order_id"), so each client ("customer_unique_id") can have more than one "customer_id".*/

/* EXERCISE 3
Show the total sales value of each seller (seller_id) in each of the product categories,
only returning the sellers who in this sum and grouping sold more than $1000.
We want to see the product category and the sellers. For each of these categories, show your sales figures in descending order.
*/
SELECT	Sellers.seller_id AS Seller_ID,
	Products.product_category_name AS Product_Category,
	sum(Items.Price) AS Sales_Value
FROM olist_sellers_dataset AS Sellers
INNER JOIN olist_order_items_dataset AS Items ON Items.seller_id = Sellers.seller_id
INNER JOIN olist_products_dataset AS Products ON Products.product_id = Items.product_id
GROUP BY Seller_ID, Product_Category
HAVING Sales_Value > 1000
ORDER BY Product_Category, Sales_Value DESC
