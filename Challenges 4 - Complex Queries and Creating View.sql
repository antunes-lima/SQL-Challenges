/* EXERCISE 1
Create a view (SELLER_STATS) to show by supplier,
the quantity of items shipped,
the average postage time after approval of the purchase,
the total quantity of orders from each Supplier,
note that we will work on the same query with 2 different granularities.
*/
CREATE VIEW IF NOT EXISTS SELLER_STATS AS (
	SELECT	Sellers.seller_id AS Seller,
		count(Items.product_id) AS Items_Quantity,
		avg(julianday(Orders.order_delivered_carrier_date) - julianday(Orders.order_approved_at)) AS Avg_Time_to_Post
		count(DISTINCT Orders.order_id) AS Orders_Quantity
	FROM olist_orders_dataset AS Orders
	INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Orders.order_id
	INNER JOIN olist_sellers_dataset AS Sellers ON Sellers.seller_id = Items.seller_id
	WHERE Orders.order_status NOT IN ('canceled')
	GROUP BY Seller
	)

/* EXERCISE 2
We want to give a coupon of 10% of the value of the customer's last purchase.
However, customers eligible for this coupon must have made a prior to last purchase (from the order approval date)
that was greater than or equal to the value of the last purchase.
Create a query that returns the coupon values for each of the eligible customers.
*/
SELECT *
FROM 	(
	SELECT	*,
		lag(Order_Value) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS Last_Order_Value,
		Order_Value*0.1 AS Coupon_Value
	FROM 	(
		SELECT	Customers.customer_unique_id AS Customer_ID,
			Orders.order_id AS Order_ID,
			Orders.order_approved_at AS Order_Date,
			sum(Payments.payment_value) AS Order_Value
		FROM olist_customers_dataset AS Customers
		INNER JOIN olist_orders_dataset AS Orders ON Orders.customer_id = Customers.customer_id
		INNER JOIN olist_order_payments_dataset AS Payments ON Payments.order_id = Orders.order_id
		WHERE Orders.order_status NOT IN ('canceled')
		GROUP BY Customers.Customer_ID, Orders.Order_ID, Orders.order_approved_at
		ORDER BY Customers.Customer_ID
		)
	)
WHERE Last_Order_Value >= Order_Value
