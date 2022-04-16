/* EXERCISE 1
Return the number of items sold in each category by state the customer is in, showing only categories that have sold more than 1000 items.
*/
SELECT 
	count(Produtos.product_id) AS Quantidade,
	Produtos.product_category_name AS Categoria,
	Clientes.customer_state AS Estado
FROM olist_customers_dataset AS Clientes
INNER JOIN olist_orders_dataset AS Pedidos ON Pedidos.customer_id = Clientes.customer_id
INNER JOIN olist_order_items_dataset AS Items ON Items.order_id = Pedidos.order_id
INNER JOIN olist_products_dataset AS Produtos ON Produtos.product_id = Items.product_id
GROUP BY Categoria, Estado
HAVING Quantidade > 1000
ORDER BY Estado, Quantidade DESC

/* EXERCISE 2
Show the 5 customers (customer_id) who spent the most money on purchases, the total value of all their purchases, quantity of purchases, and average amount spent per purchases.
Order them in descending order by the average purchase value.
*/
WITH Top_5_Clientes AS 
(SELECT 
	Clientes.customer_unique_id AS Cliente_ID,
	SUM(Pagamentos.payment_value) AS Valor_Total_Compras,
	count(Pedidos.order_id) AS Quantidade_Compras,
	avg(Pagamentos.payment_value) AS Valor_Medio_Compras
FROM olist_customers_dataset AS Clientes
INNER JOIN olist_orders_dataset AS Pedidos ON Pedidos.customer_id = Clientes.customer_id
INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
WHERE Pedidos.order_status NOT IN ('canceled')
GROUP BY Cliente_ID
ORDER BY Valor_Total_Compras DESC
LIMIT 5)
SELECT * FROM Top_5_Clientes
ORDER BY Valor_Medio_Compras DESC
/* Obs: "customer_unique_id" is the actual unique identifier for each client, according to the dataset information on Kaggle. 
"customer_id" is a value generated for each order ("order_id"), so each client ("customer_unique_id") can have more than one "customer_id".*/

/* EXERCISE 3
Show the total sales value of each seller (seller_id) in each of the product categories,
only returning the sellers who in this sum and grouping sold more than $1000.
We want to see the product category and the sellers. For each of these categories, show your sales figures in descending order.
*/
SELECT 
	Vendedores.seller_id AS Vendedor_ID,
	Produtos.product_category_name AS Categoria_Produto,
	sum(Items.Price) AS Valor_Vendas
FROM olist_sellers_dataset AS Vendedores
INNER JOIN olist_order_items_dataset AS Items ON Items.seller_id = Vendedores.seller_id
INNER JOIN olist_products_dataset AS Produtos ON Produtos.product_id = Items.product_id
GROUP BY Vendedor_ID, Categoria_Produto
HAVING Valor_Vendas > 1000
ORDER BY Categoria_Produto, Valor_Vendas DESC
