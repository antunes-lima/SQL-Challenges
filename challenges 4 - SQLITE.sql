/* EXERCISE 1
Create a view (SELLER_STATS) to show by supplier,
the quantity of items shipped,
the average postage time after approval of the purchase,
the total quantity of orders from each Supplier,
note that we will work on the same query with 2 different granularities.
*/
CREATE VIEW IF NOT EXISTS SELLER_STATS AS
	SELECT 
		Vendedores.seller_id AS Vendedor,
		count(Items.product_id) AS Quantidade_items,
		avg(julianday(Pedidos.order_delivered_carrier_date) - julianday(Pedidos.order_approved_at)) AS Tempo_medio_postagem,
		count(DISTINCT Pedidos.order_id) AS Quantidade_pedidos
	FROM olist_orders_dataset AS Pedidos
	INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Pedidos.order_id
	INNER JOIN olist_sellers_dataset AS Vendedores ON Vendedores.seller_id = Items.seller_id
	WHERE Pedidos.order_status NOT IN ('canceled')
	GROUP BY Vendedor

/* EXERCISE 2
We want to give a coupon of 10% of the value of the customer's last purchase.
However, customers eligible for this coupon must have made a prior to last purchase (from the order approval date)
that was greater than or equal to the value of the last purchase.
Create a query that returns the coupon values for each of the eligible customers.
*/
SELECT * FROM
	(SELECT *,
		lag(Valor_pedido) OVER (PARTITION BY Cliente_ID ORDER BY Data_pedido) AS Valor_pedido_anterior,
		Valor_pedido*0.1 AS Valor_cupom
	FROM (
		SELECT 
			Clientes.customer_unique_id AS Cliente_ID,
			Pedidos.order_id AS Pedido_ID,
			Pedidos.order_approved_at AS Data_pedido,
			sum(Pagamentos.payment_value) AS Valor_pedido
		FROM olist_customers_dataset AS Clientes
		INNER JOIN olist_orders_dataset AS Pedidos ON Pedidos.customer_id = Clientes.customer_id
		INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
		WHERE Pedidos.order_status NOT IN ('canceled')
		GROUP BY Cliente_ID, Pedido_ID, Data_pedido
		ORDER BY Cliente_ID
		)
	)
WHERE Valor_pedido_anterior >= Valor_pedido
