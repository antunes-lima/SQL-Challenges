/* EXERCISE 1
Create an analytical table of all items that were sold, showing only interstate orders.
We want to know how many days it takes suppliers to post the product,
whether or not the product arrived on time.
*/
SELECT
	Items.product_id AS Item,
	(julianday(Pedidos.order_delivered_carrier_date) - julianday(Pedidos.order_approved_at)) AS Dias_postagem,
	CASE
		WHEN Pedidos.order_delivered_customer_date > Pedidos.order_estimated_delivery_date THEN 'NAO'
		WHEN Pedidos.order_delivered_customer_date < Pedidos.order_estimated_delivery_date THEN 'SIM'
		ELSE 'ERROR'
	END Chegou_no_prazo
FROM olist_customers_dataset AS Clientes
INNER JOIN olist_orders_dataset AS Pedidos ON Pedidos.customer_id = Clientes.customer_id
INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Pedidos.order_id
INNER JOIN olist_sellers_dataset AS Vendedores ON Vendedores.seller_id = Items.seller_id
WHERE Clientes.customer_state <> Vendedores.seller_state

/* EXERCISE 2
Return all customer payments, with their approval dates,
purchase amount and the total amount that the customer has already spent on all their purchases,
showing only customers where the purchase amount is different from the total amount already spent.
*/
WITH Tabela AS 
(
SELECT 
	Cliente,
	Data_aprovacao,
	Valor_da_compra,
	sum(Valor_da_compra) OVER (PARTITION BY Cliente) AS Soma_do_cliente
FROM 
(
SELECT 
	Clientes.customer_id AS Cliente,
	Pedidos.order_approved_at AS Data_aprovacao,
	Pagamentos.payment_value AS Valor_da_compra
FROM olist_customers_dataset AS Clientes
INNER JOIN olist_orders_dataset AS Pedidos ON Pedidos.customer_id = Clientes.customer_id
INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
)
)
SELECT * FROM Tabela
WHERE Valor_da_compra <> Soma_do_cliente

/* EXERCISE 3
Return valid categories, their total sums of sales amounts,
a ranking from highest value to lowest value along with the
cumulative sum of values by the same ranking rule.
*/
SELECT 
	*,
	sum(Total_vendas) OVER (ORDER BY Total_vendas DESC) AS Soma_acumulada
FROM 
(
SELECT 
	Produtos.product_category_name AS Categoria,
	sum(Items.price) AS Total_vendas,
	rank() OVER (ORDER BY sum(Items.price) DESC) AS Ranque
FROM olist_orders_dataset AS Pedidos
INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Pedidos.order_id
INNER JOIN olist_products_dataset AS Produtos ON Produtos.product_id = Items.product_id
WHERE Pedidos.order_status NOT IN ('canceled')
AND Produtos.product_category_name IS NOT NULL
GROUP BY Categoria
ORDER BY Total_vendas DESC
)
