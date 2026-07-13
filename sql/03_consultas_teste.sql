-- Consulta 1 — resumo dos pedidos

SELECT
    c.nome AS cliente,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    p.valor_frete,
    p.valor_total,
    pg.forma_pagamento,
    pg.status AS status_pagamento,
    p.status AS status_pedido
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
JOIN itens_pedido ip
    ON ip.pedido_id = p.id
JOIN variacoes_produto v
    ON v.id = ip.variacao_produto_id
JOIN produtos pr
    ON pr.id = v.produto_id
JOIN pagamentos pg
    ON pg.pedido_id = p.id
ORDER BY p.id;


-- Consulta 2 — produtos mais vendidos por categoria

SELECT
    c.nome AS categoria,
    p.nome AS produto,
    SUM(ip.quantidade) AS quantidade_vendida
FROM itens_pedido ip
JOIN variacoes_produto v
    ON v.id = ip.variacao_produto_id
JOIN produtos p
    ON p.id = v.produto_id
JOIN categorias c
    ON c.id = p.categoria_id
GROUP BY
    c.nome,
    p.nome
ORDER BY
    c.nome,
    quantidade_vendida DESC;


-- Consulta 3 — produtos com estoque baixo
-- Considera estoque baixo quando o total é menor que 6 unidades

SELECT
    p.nome AS produto,
    v.sku,
    SUM(e.quantidade_disponivel) AS estoque_total
FROM estoques e
JOIN variacoes_produto v
    ON v.id = e.variacao_produto_id
JOIN produtos p
    ON p.id = v.produto_id
GROUP BY
    p.nome,
    v.sku
HAVING SUM(e.quantidade_disponivel) < 6
ORDER BY estoque_total;


-- Consulta 4 — ticket médio por cliente

SELECT
    c.nome AS cliente,
    AVG(p.valor_total) AS ticket_medio
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
GROUP BY c.nome
ORDER BY ticket_medio DESC;