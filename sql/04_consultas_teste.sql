-- Consulta 1 - pedidos 

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

-- Consulta 2 — estoque dos produtos por depósito

SELECT
    p.nome AS produto,
    v.sku,
    d.nome AS deposito,
    e.quantidade_disponivel
FROM estoques e
JOIN variacoes_produto v
    ON v.id = e.variacao_produto_id
JOIN produtos p
    ON p.id = v.produto_id
JOIN depositos d
    ON d.id = e.deposito_id
ORDER BY p.nome, d.nome;

-- Consulta 3 — produtos mais vendidos

SELECT
    p.nome AS produto,
    SUM(ip.quantidade) AS quantidade_vendida
FROM itens_pedido ip
JOIN variacoes_produto v
    ON v.id = ip.variacao_produto_id
JOIN produtos p
    ON p.id = v.produto_id
GROUP BY p.nome
ORDER BY quantidade_vendida DESC;

-- Consulta 4 — valor total gasto por cliente

SELECT
    c.nome AS cliente,
    SUM(p.valor_total) AS total_gasto
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
GROUP BY c.nome
ORDER BY total_gasto DESC;