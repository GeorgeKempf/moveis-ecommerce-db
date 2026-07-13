-- =========================================================
-- DADOS DE TESTE — E-COMMERCE DE MÓVEIS
-- Executar somente após o schema.sql
-- =========================================================


-- =========================================================
-- 1. CATEGORIAS PRINCIPAIS
-- =========================================================

INSERT INTO categorias (nome, descricao)
VALUES
    ('Quarto', 'Móveis para quarto'),
    ('Cozinha e Sala de Jantar', 'Móveis para refeições'),
    ('Sala de Estar', 'Móveis para sala de estar');


-- =========================================================
-- 2. SUBCATEGORIAS
-- =========================================================

INSERT INTO categorias (
    categoria_pai_id,
    nome,
    descricao
)
SELECT
    id,
    'Camas',
    'Camas de madeira'
FROM categorias
WHERE nome = 'Quarto'
  AND categoria_pai_id IS NULL;


INSERT INTO categorias (
    categoria_pai_id,
    nome,
    descricao
)
SELECT
    id,
    'Mesas de Jantar',
    'Mesas de jantar de madeira'
FROM categorias
WHERE nome = 'Cozinha e Sala de Jantar'
  AND categoria_pai_id IS NULL;


INSERT INTO categorias (
    categoria_pai_id,
    nome,
    descricao
)
SELECT
    id,
    'Racks',
    'Racks de madeira para televisão'
FROM categorias
WHERE nome = 'Sala de Estar'
  AND categoria_pai_id IS NULL;


-- =========================================================
-- 3. PRODUTOS
-- =========================================================

INSERT INTO produtos (
    categoria_id,
    nome,
    descricao,
    tipo_madeira,
    largura_cm,
    altura_cm,
    profundidade_cm,
    peso_kg
)
SELECT
    id,
    'Cama de Casal',
    'Cama de casal em madeira',
    'Pinus',
    140.00,
    100.00,
    200.00,
    55.000
FROM categorias
WHERE nome = 'Camas';


INSERT INTO produtos (
    categoria_id,
    nome,
    descricao,
    tipo_madeira,
    largura_cm,
    altura_cm,
    profundidade_cm,
    peso_kg
)
SELECT
    id,
    'Mesa de Jantar',
    'Mesa de jantar para seis pessoas',
    'Eucalipto',
    160.00,
    78.00,
    90.00,
    40.000
FROM categorias
WHERE nome = 'Mesas de Jantar';


INSERT INTO produtos (
    categoria_id,
    nome,
    descricao,
    tipo_madeira,
    largura_cm,
    altura_cm,
    profundidade_cm,
    peso_kg
)
SELECT
    id,
    'Rack para TV',
    'Rack de madeira para televisão',
    'MDF',
    180.00,
    60.00,
    45.00,
    30.000
FROM categorias
WHERE nome = 'Racks';


-- =========================================================
-- 4. VARIAÇÕES DOS PRODUTOS
-- Uma variação para cada produto
-- =========================================================

INSERT INTO variacoes_produto (
    produto_id,
    sku,
    acabamento_cor,
    preco
)
SELECT
    id,
    'CAMA-CASAL-NAT',
    'Natural',
    1500.00
FROM produtos
WHERE nome = 'Cama de Casal';


INSERT INTO variacoes_produto (
    produto_id,
    sku,
    acabamento_cor,
    preco
)
SELECT
    id,
    'MESA-JANTAR-NAT',
    'Natural',
    1200.00
FROM produtos
WHERE nome = 'Mesa de Jantar';


INSERT INTO variacoes_produto (
    produto_id,
    sku,
    acabamento_cor,
    preco
)
SELECT
    id,
    'RACK-TV-NAT',
    'Natural',
    700.00
FROM produtos
WHERE nome = 'Rack para TV';


-- =========================================================
-- 5. IMAGEM
-- Uma imagem já demonstra o relacionamento
-- =========================================================

INSERT INTO imagens_produto (
    produto_id,
    variacao_produto_id,
    url
)
SELECT
    p.id,
    v.id,
    'https://example.com/imagens/rack-tv.jpg'
FROM produtos p
JOIN variacoes_produto v
    ON v.produto_id = p.id
WHERE v.sku = 'RACK-TV-NAT';


-- =========================================================
-- 6. CLIENTES
-- =========================================================

INSERT INTO clientes (
    nome,
    email,
    senha_hash
)
VALUES
    ('Ana Souza', 'ana@example.com', 'senha_teste_ana'),
    ('Bruno Lima', 'bruno@example.com', 'senha_teste_bruno'),
    ('Carla Mendes', 'carla@example.com', 'senha_teste_carla');


-- =========================================================
-- 7. ENDEREÇOS
-- Um endereço de entrega para cada cliente
-- =========================================================

INSERT INTO enderecos (
    cliente_id,
    tipo_endereco,
    cep,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado
)
SELECT
    id,
    'entrega',
    '88130-000',
    'Rua das Flores',
    '100',
    NULL,
    'Centro',
    'Palhoça',
    'SC'
FROM clientes
WHERE email = 'ana@example.com';


INSERT INTO enderecos (
    cliente_id,
    tipo_endereco,
    cep,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado
)
SELECT
    id,
    'entrega',
    '88110-000',
    'Rua Central',
    '200',
    NULL,
    'Campinas',
    'São José',
    'SC'
FROM clientes
WHERE email = 'bruno@example.com';


INSERT INTO enderecos (
    cliente_id,
    tipo_endereco,
    cep,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado
)
SELECT
    id,
    'entrega',
    '88010-000',
    'Avenida Brasil',
    '300',
    NULL,
    'Centro',
    'Florianópolis',
    'SC'
FROM clientes
WHERE email = 'carla@example.com';


-- =========================================================
-- 8. CARRINHOS
-- Um carrinho finalizado para cada compra
-- =========================================================

INSERT INTO carrinhos (cliente_id, status)
SELECT id, 'finalizado'
FROM clientes
WHERE email = 'ana@example.com';


INSERT INTO carrinhos (cliente_id, status)
SELECT id, 'finalizado'
FROM clientes
WHERE email = 'bruno@example.com';


INSERT INTO carrinhos (cliente_id, status)
SELECT id, 'finalizado'
FROM clientes
WHERE email = 'carla@example.com';


-- =========================================================
-- 9. ITENS DOS CARRINHOS
-- =========================================================

-- Ana adicionou a cama

INSERT INTO carrinho_itens (
    carrinho_id,
    variacao_produto_id,
    quantidade
)
SELECT
    c.id,
    v.id,
    1
FROM carrinhos c
JOIN clientes cli
    ON cli.id = c.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'CAMA-CASAL-NAT'
WHERE cli.email = 'ana@example.com';


-- Bruno adicionou a mesa

INSERT INTO carrinho_itens (
    carrinho_id,
    variacao_produto_id,
    quantidade
)
SELECT
    c.id,
    v.id,
    1
FROM carrinhos c
JOIN clientes cli
    ON cli.id = c.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'MESA-JANTAR-NAT'
WHERE cli.email = 'bruno@example.com';


-- Carla adicionou o rack

INSERT INTO carrinho_itens (
    carrinho_id,
    variacao_produto_id,
    quantidade
)
SELECT
    c.id,
    v.id,
    1
FROM carrinhos c
JOIN clientes cli
    ON cli.id = c.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'RACK-TV-NAT'
WHERE cli.email = 'carla@example.com';


-- =========================================================
-- 10. PEDIDOS
-- =========================================================

-- Compra 1: cama

INSERT INTO pedidos (
    cliente_id,
    endereco_entrega_id,
    status,
    valor_frete,
    valor_total
)
SELECT
    c.id,
    e.id,
    'entregue',
    100.00,
    1600.00
FROM clientes c
JOIN enderecos e
    ON e.cliente_id = c.id
WHERE c.email = 'ana@example.com'
  AND e.tipo_endereco = 'entrega';


-- Compra 2: mesa

INSERT INTO pedidos (
    cliente_id,
    endereco_entrega_id,
    status,
    valor_frete,
    valor_total
)
SELECT
    c.id,
    e.id,
    'entregue',
    80.00,
    1280.00
FROM clientes c
JOIN enderecos e
    ON e.cliente_id = c.id
WHERE c.email = 'bruno@example.com'
  AND e.tipo_endereco = 'entrega';


-- Compra 3: rack

INSERT INTO pedidos (
    cliente_id,
    endereco_entrega_id,
    status,
    valor_frete,
    valor_total
)
SELECT
    c.id,
    e.id,
    'entregue',
    60.00,
    760.00
FROM clientes c
JOIN enderecos e
    ON e.cliente_id = c.id
WHERE c.email = 'carla@example.com'
  AND e.tipo_endereco = 'entrega';


-- =========================================================
-- 11. ITENS DOS PEDIDOS
-- =========================================================

INSERT INTO itens_pedido (
    pedido_id,
    variacao_produto_id,
    quantidade,
    preco_unitario
)
SELECT
    p.id,
    v.id,
    1,
    1500.00
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'CAMA-CASAL-NAT'
WHERE c.email = 'ana@example.com';


INSERT INTO itens_pedido (
    pedido_id,
    variacao_produto_id,
    quantidade,
    preco_unitario
)
SELECT
    p.id,
    v.id,
    1,
    1200.00
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'MESA-JANTAR-NAT'
WHERE c.email = 'bruno@example.com';


INSERT INTO itens_pedido (
    pedido_id,
    variacao_produto_id,
    quantidade,
    preco_unitario
)
SELECT
    p.id,
    v.id,
    1,
    700.00
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
JOIN variacoes_produto v
    ON v.sku = 'RACK-TV-NAT'
WHERE c.email = 'carla@example.com';


-- =========================================================
-- 12. PAGAMENTOS
-- =========================================================

-- Compra da cama no débito

INSERT INTO pagamentos (
    pedido_id,
    forma_pagamento,
    status,
    valor,
    data_pagamento
)
SELECT
    p.id,
    'debito',
    'aprovado',
    1600.00,
    CURRENT_TIMESTAMP
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
WHERE c.email = 'ana@example.com';


-- Compra da mesa no crédito

INSERT INTO pagamentos (
    pedido_id,
    forma_pagamento,
    status,
    valor,
    data_pagamento
)
SELECT
    p.id,
    'credito',
    'aprovado',
    1280.00,
    CURRENT_TIMESTAMP
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
WHERE c.email = 'bruno@example.com';


-- Compra do rack no PIX

INSERT INTO pagamentos (
    pedido_id,
    forma_pagamento,
    status,
    valor,
    data_pagamento
)
SELECT
    p.id,
    'pix',
    'aprovado',
    760.00,
    CURRENT_TIMESTAMP
FROM pedidos p
JOIN clientes c
    ON c.id = p.cliente_id
WHERE c.email = 'carla@example.com';


-- =========================================================
-- 13. DEPÓSITOS
-- =========================================================

INSERT INTO depositos (
    nome,
    localizacao
)
VALUES
    ('Depósito Sul', 'Palhoça - SC'),
    ('Depósito Norte', 'Joinville - SC');


-- =========================================================
-- 14. ESTOQUES
-- =========================================================

-- Estoque da cama

INSERT INTO estoques (
    variacao_produto_id,
    deposito_id,
    quantidade_disponivel
)
SELECT
    v.id,
    d.id,
    5
FROM variacoes_produto v
CROSS JOIN depositos d
WHERE v.sku = 'CAMA-CASAL-NAT'
  AND d.nome = 'Depósito Sul';


-- Estoque da mesa

INSERT INTO estoques (
    variacao_produto_id,
    deposito_id,
    quantidade_disponivel
)
SELECT
    v.id,
    d.id,
    4
FROM variacoes_produto v
CROSS JOIN depositos d
WHERE v.sku = 'MESA-JANTAR-NAT'
  AND d.nome = 'Depósito Sul';


-- Rack no primeiro depósito

INSERT INTO estoques (
    variacao_produto_id,
    deposito_id,
    quantidade_disponivel
)
SELECT
    v.id,
    d.id,
    6
FROM variacoes_produto v
CROSS JOIN depositos d
WHERE v.sku = 'RACK-TV-NAT'
  AND d.nome = 'Depósito Sul';


-- Mesmo rack no segundo depósito

INSERT INTO estoques (
    variacao_produto_id,
    deposito_id,
    quantidade_disponivel
)
SELECT
    v.id,
    d.id,
    3
FROM variacoes_produto v
CROSS JOIN depositos d
WHERE v.sku = 'RACK-TV-NAT'
  AND d.nome = 'Depósito Norte';


-- =========================================================
-- 15. AVALIAÇÃO
-- Uma avaliação já demonstra o relacionamento
-- =========================================================

INSERT INTO avaliacoes (
    item_pedido_id,
    nota,
    comentario
)
SELECT
    ip.id,
    5,
    'Produto entregue corretamente'
FROM itens_pedido ip
JOIN pedidos p
    ON p.id = ip.pedido_id
JOIN clientes c
    ON c.id = p.cliente_id
JOIN variacoes_produto v
    ON v.id = ip.variacao_produto_id
WHERE c.email = 'carla@example.com'
  AND v.sku = 'RACK-TV-NAT';