CREATE TABLE categorias (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    categoria_pai_id BIGINT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_categorias PRIMARY KEY (id),

    CONSTRAINT fk_categorias_categoria_pai_id
        FOREIGN KEY (categoria_pai_id)
        REFERENCES categorias(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE produtos (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    categoria_id BIGINT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    tipo_madeira VARCHAR(100) NOT NULL,
    largura_cm NUMERIC(10,2) NOT NULL,
    altura_cm NUMERIC(10,2) NOT NULL,
    profundidade_cm NUMERIC(10,2) NOT NULL,
    peso_kg NUMERIC(10,3) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_produtos PRIMARY KEY (id),

    CONSTRAINT fk_produtos_categoria_id
        FOREIGN KEY (categoria_id)
        REFERENCES categorias(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_produtos_largura_positiva
        CHECK (largura_cm > 0),

    CONSTRAINT ck_produtos_altura_positiva
        CHECK (altura_cm > 0),

    CONSTRAINT ck_produtos_profundidade_positiva
        CHECK (profundidade_cm > 0),

    CONSTRAINT ck_produtos_peso_positivo
        CHECK (peso_kg > 0),

    CONSTRAINT uq_produtos_categoria_id_nome
        UNIQUE (categoria_id, nome)
);

CREATE TABLE variacoes_produto (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    produto_id BIGINT NOT NULL,
    sku VARCHAR(60) NOT NULL,
    acabamento_cor VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_variacoes_produto PRIMARY KEY (id),

    CONSTRAINT fk_variacoes_produto_produto_id
        FOREIGN KEY (produto_id)
        REFERENCES produtos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_variacoes_produto_sku
        UNIQUE (sku),

    CONSTRAINT uq_variacoes_produto_produto_id_acabamento_cor
        UNIQUE (produto_id, acabamento_cor),

    CONSTRAINT ck_variacoes_produto_preco_positivo
        CHECK (preco > 0)
);

CREATE TABLE imagens_produto (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    produto_id BIGINT NOT NULL,
    variacao_produto_id BIGINT,
    url VARCHAR(500) NOT NULL,

    CONSTRAINT pk_imagens_produto PRIMARY KEY (id),

    CONSTRAINT fk_imagens_produto_produto_id
        FOREIGN KEY (produto_id)
        REFERENCES produtos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_imagens_produto_variacao_produto_id
        FOREIGN KEY (variacao_produto_id)
        REFERENCES variacoes_produto(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE clientes (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_clientes PRIMARY KEY (id),

    CONSTRAINT uq_clientes_email
        UNIQUE (email)
);

CREATE TABLE enderecos (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cliente_id BIGINT NOT NULL,
    tipo_endereco VARCHAR(20) NOT NULL,
    cep VARCHAR(20) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_enderecos PRIMARY KEY (id),

    CONSTRAINT fk_enderecos_cliente_id
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_enderecos_tipo_endereco
        CHECK (tipo_endereco IN ('entrega', 'cobranca'))
);

CREATE TYPE status_pedido AS ENUM (
    'aguardando_pagamento',
    'pago',
    'em_separacao',
    'enviado',
    'entregue',
    'cancelado'
);

CREATE TABLE pedidos (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cliente_id BIGINT NOT NULL,
    endereco_entrega_id BIGINT NOT NULL,
    status status_pedido NOT NULL DEFAULT 'aguardando_pagamento',
    valor_frete NUMERIC(10,2) NOT NULL DEFAULT 0,
    valor_total NUMERIC(10,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_pedidos PRIMARY KEY (id),

    CONSTRAINT fk_pedidos_cliente_id
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pedidos_endereco_entrega_id
        FOREIGN KEY (endereco_entrega_id)
        REFERENCES enderecos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_pedidos_valor_frete_nao_negativo
        CHECK (valor_frete >= 0),

    CONSTRAINT ck_pedidos_valor_total_nao_negativo
        CHECK (valor_total >= 0)
);

CREATE TABLE itens_pedido (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    pedido_id BIGINT NOT NULL,
    variacao_produto_id BIGINT NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_itens_pedido PRIMARY KEY (id),

    CONSTRAINT fk_itens_pedido_pedido_id
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_itens_pedido_variacao_produto_id
        FOREIGN KEY (variacao_produto_id)
        REFERENCES variacoes_produto(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_itens_pedido_quantidade_positiva
        CHECK (quantidade > 0),

    CONSTRAINT ck_itens_pedido_preco_unitario_positivo
        CHECK (preco_unitario > 0)
);

CREATE TABLE pagamentos (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    pedido_id BIGINT NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_pagamento TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_pagamentos PRIMARY KEY (id),

    CONSTRAINT fk_pagamentos_pedido_id
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_pagamentos_valor_positivo
        CHECK (valor > 0)
);

CREATE TABLE estoques (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    variacao_produto_id BIGINT NOT NULL,
    quantidade_disponivel INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_estoques PRIMARY KEY (id),

    CONSTRAINT fk_estoques_variacao_produto_id
        FOREIGN KEY (variacao_produto_id)
        REFERENCES variacoes_produto(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT uq_estoques_variacao_produto_id
        UNIQUE (variacao_produto_id),

    CONSTRAINT ck_estoques_quantidade_disponivel_nao_negativa
        CHECK (quantidade_disponivel >= 0)
);

CREATE TABLE avaliacoes (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    item_pedido_id BIGINT NOT NULL,
    nota INTEGER NOT NULL,
    comentario TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_avaliacoes PRIMARY KEY (id),

    CONSTRAINT fk_avaliacoes_item_pedido_id
        FOREIGN KEY (item_pedido_id)
        REFERENCES itens_pedido(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_avaliacoes_nota
        CHECK (nota BETWEEN 1 AND 5),

    CONSTRAINT uq_avaliacoes_item_pedido_id
        UNIQUE (item_pedido_id)
);