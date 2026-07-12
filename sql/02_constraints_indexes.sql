CREATE UNIQUE INDEX IF NOT EXISTS uq_categorias_nome_sem_pai
ON categorias (nome)
WHERE categoria_pai_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_categorias_categoria_pai_id_nome
ON categorias (categoria_pai_id, nome)
WHERE categoria_pai_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_produtos_categoria_id
ON produtos (categoria_id);

CREATE INDEX IF NOT EXISTS idx_variacoes_produto_produto_id
ON variacoes_produto (produto_id);

CREATE INDEX IF NOT EXISTS idx_imagens_produto_produto_id
ON imagens_produto (produto_id);

CREATE INDEX IF NOT EXISTS idx_imagens_produto_variacao_produto_id
ON imagens_produto (variacao_produto_id);

CREATE INDEX IF NOT EXISTS idx_enderecos_cliente_id
ON enderecos (cliente_id);

CREATE INDEX IF NOT EXISTS idx_carrinhos_cliente_id
ON carrinhos (cliente_id);

CREATE INDEX IF NOT EXISTS idx_carrinhos_status
ON carrinhos (status);

CREATE INDEX IF NOT EXISTS idx_carrinho_itens_carrinho_id
ON carrinho_itens (carrinho_id);

CREATE INDEX IF NOT EXISTS idx_carrinho_itens_variacao_produto_id
ON carrinho_itens (variacao_produto_id);

CREATE INDEX IF NOT EXISTS idx_pedidos_cliente_id
ON pedidos (cliente_id);

CREATE INDEX IF NOT EXISTS idx_pedidos_endereco_entrega_id
ON pedidos (endereco_entrega_id);

CREATE INDEX IF NOT EXISTS idx_pedidos_status
ON pedidos (status);

CREATE INDEX IF NOT EXISTS idx_itens_pedido_pedido_id
ON itens_pedido (pedido_id);

CREATE INDEX IF NOT EXISTS idx_itens_pedido_variacao_produto_id
ON itens_pedido (variacao_produto_id);

CREATE INDEX IF NOT EXISTS idx_pagamentos_pedido_id
ON pagamentos (pedido_id);

CREATE INDEX IF NOT EXISTS idx_pagamentos_status
ON pagamentos (status);

CREATE INDEX IF NOT EXISTS idx_estoques_deposito_id
ON estoques (deposito_id);