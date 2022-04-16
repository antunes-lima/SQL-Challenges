/* QUESTAO 1
Crie uma view (SELLER_STATS) para mostrar por fornecedor, 
a quantidade de itens enviados, 
o tempo médio de postagem após a aprovação da compra, 
a quantidade total de pedidos de cada Fornecedor, 
note que trabalharemos na mesma query com 2 granularidades diferentes.
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


/* QUESTAO 2
Queremos dar um cupom de 10% do valor da última compra do cliente. 
Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última (a partir da data de aprovação do pedido) 
que tenha sido maior ou igual o valor da última compra. 
Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis.
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
