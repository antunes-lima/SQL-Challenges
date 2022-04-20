/* EXERCISE 1
Create an analytical table of all items that were sold, showing only interstate orders.
We want to know how many days it takes suppliers to post the product,
whether or not the product arrived on time.
*/
SELECT	Items.product_id AS Item,
	(julianday(Orders.order_delivered_carrier_date) - julianday(Orders.order_approved_at)) AS Days_ship,
	CASE
		WHEN Orders.order_delivered_customer_date > Orders.order_estimated_delivery_date THEN 'NO'
		WHEN Orders.order_delivered_customer_date < Orders.order_estimated_delivery_date THEN 'YES'
		ELSE 'ERROR'
	END Arrived_on_time
FROM olist_customers_dataset AS Customers
INNER JOIN olist_orders_dataset AS Orders ON Orders.customer_id = Customers.customer_id
INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Orders.order_id
INNER JOIN olist_sellers_dataset AS Sellers ON Sellers.seller_id = Items.seller_id
WHERE Customers.customer_state <> Sellers.seller_state

/* EXERCISE 2
Return all customer payments, with their approval dates,
purchase amount and the total amount that the customer has already spent on all their purchases,
showing only customers where the purchase amount is different from the total amount already spent.
*/
WITH Customer_Purchace_Data AS (
	SELECT	Customer,
		Approve_Date,
		Purchase_Value,
		sum(Purchase_Value) OVER (PARTITION BY Customer) AS Customer_Sum
	FROM (
		SELECT 
			Customers.customer_id AS Customer,
			Orders.order_approved_at AS Approve_Date,
			Payments.payment_value AS Purchase_Value
		FROM olist_customers_dataset AS Customers
		INNER JOIN olist_orders_dataset AS Orders ON Orders.customer_id = Customers.customer_id
		INNER JOIN olist_order_payments_dataset AS Payments ON Payments.order_id = Orders.order_id
	))
SELECT *
FROM Customer_Purchace_Data
WHERE Purchase_Value <> Customer_Sum

/* EXERCISE 3
Return valid categories, their total sums of sales amounts,
a ranking from highest value to lowest value along with the
cumulative sum of values by the same ranking rule.
*/
SELECT	*,
	sum(Sales_value_Sum) OVER (ORDER BY Sales_value_Sum DESC) AS Accummulated_Sum
FROM (
	SELECT	Products.product_category_name AS Category,
		sum(Items.price) AS Sales_value_Sum,
		rank() OVER (ORDER BY sum(Items.price) DESC) AS Rank
	FROM olist_orders_dataset AS Orders
	INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Orders.order_id
	INNER JOIN olist_products_dataset AS Products ON Products.product_id = Items.product_id
	WHERE Orders.order_status NOT IN ('canceled')
	AND Products.product_category_name IS NOT NULL
	GROUP BY Category
	ORDER BY Sales_value_Sum DESC
	)
