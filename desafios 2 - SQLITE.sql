/* QUESTAO 1
Retorne a quantidade de itens vendidos em cada categoria por estado em que o cliente se encontra, mostrando somente categorias que tenham vendido uma quantidade de items acima de 1000.
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


/* QUESTAO 2
Mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras, qual foi o valor total de todas as compras deles, quantidade de compras, e valor médio gasto por compras.
Ordene os mesmos por ordem decrescente pela média do valor de compra.
*/
WITH Top_5_Clientes AS 
(SELECT 
	Clientes.customer_id AS Cliente_ID,
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


/* QUESTAO 3
Mostre o valor vendido total de cada vendedor (seller_id) em cada uma das categorias de produtos, somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000.
Desejamos ver a categoria do produto e os vendedores. Para cada uma dessas categorias, mostre seus valores de venda de forma decrescente.
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
