# E-commerce de Móveis — Modelagem de Banco de Dados

Modelagem e implementação de um banco de dados PostgreSQL para uma plataforma de e-commerce especializada em móveis de madeira, cobrindo catálogo de produtos, clientes, endereços, pedidos, pagamentos, estoque e avaliações.

- **Banco de dados:** `moveis_ecommerce`
- **SGBD:** PostgreSQL
- **Versão alvo:** PostgreSQL 15+

---

## Arquivos do projeto

| Arquivo | Descrição |
|---|---|
| `schema.sql` | DDL completo do banco (ENUM, tabelas, constraints e índices), executável do zero. |
| `sql/01_create_tables.sql` | Criação do ENUM `status_pedido` e das tabelas base, separada dos índices adicionais. |
| `sql/02_constraints_indexes.sql` | Índices adicionais (além dos já criados junto com as tabelas). |
| `sql/seed.sql` | Dados de teste (bônus) — três fluxos de compra completos até o pagamento; um deles também demonstra a avaliação de um item comprado. |
| `sql/03_consultas_teste.sql` | Queries de exemplo (bônus) — resumo de pedidos, mais vendidos por categoria, estoque baixo, ticket médio. |
| `sql/04_drop_tables.sql` | Remove todas as tabelas e o ENUM, na ordem correta, para recriar o banco do zero. |
| `docs/regras-negocio.md` | Regras de negócio consideradas na modelagem. |
| `docs/diagrama-er.md` | Mapeamento textual dos relacionamentos entre entidades + link do diagrama ER visual (dbdiagram.io, bônus). |
| `docs/fluxo-carrinho-pedido.md` | Fluxo de compra do carrinho até a criação do pedido. |

`schema.sql` é o arquivo de referência — `sql/01` e `sql/02` contêm o mesmo DDL separado por etapa, para facilitar a leitura.

---

## Padrões adotados

### Nomenclatura

`snake_case` em tabelas, colunas, constraints e índices — evita problemas de case-sensitivity e caracteres especiais no Postgres.

- Tabelas no plural (`clientes`, `produtos`, `pedidos`).
- Chave primária sempre chamada `id`.
- Chave estrangeira sempre `nome_da_entidade_id` (ex.: `cliente_id`, `produto_id`, `variacao_produto_id`).

### Constraints e índices

Nomes com prefixo padronizado:

- `pk_` chave primária
- `fk_` chave estrangeira
- `uq_` unicidade
- `ck_` regra de validação (`CHECK`)
- `idx_` índice

Exemplos: `pk_clientes`, `fk_enderecos_cliente_id`, `uq_clientes_email`, `ck_variacoes_produto_preco_positivo`, `idx_pedidos_cliente_id`.

### Chaves primárias: `BIGINT GENERATED ALWAYS AS IDENTITY`

```sql
id BIGINT GENERATED ALWAYS AS IDENTITY
```

Optei por identity sequencial em vez de `UUID` porque:

- É um projeto com um único banco/nó de escrita — não há necessidade de gerar IDs de forma distribuída ou offline (o principal motivo para usar UUID).
- Chaves sequenciais de 8 bytes mantêm os índices B-tree mais compactos e com melhor localidade de inserção do que UUIDs aleatórios (que fragmentam o índice), o que importa em tabelas de alto volume como `itens_pedido`.
- São mais fáceis de ler e depurar durante o desenvolvimento.

O trade-off é que IDs sequenciais expõem volume de dados (dá pra estimar quantos pedidos existem) e são previsíveis. Se o catálogo fosse exposto publicamente por ID (ex.: URLs de produto) ou precisasse de geração de ID no cliente antes do insert, UUID seria a escolha mais adequada.

### Auditoria

Tabelas principais têm `created_at` e `updated_at` em `TIMESTAMPTZ` (preserva fuso horário). `updated_at` é atualizado pela aplicação — não há trigger no banco para isso (ver seção "o que faria diferente").

---

## Decisões de modelagem

### Catálogo: categorias, produtos, variações e imagens

O catálogo foi dividido em quatro tabelas: `categorias`, `produtos`, `variacoes_produto` e `imagens_produto`.

**Categorias e subcategorias** — `categorias` tem auto-relacionamento via `categoria_pai_id` (referencia `categorias(id)`), permitindo hierarquia de qualquer profundidade (ex.: `Mesas` → `Mesas de Jantar`). Usei `ON DELETE SET NULL` para que apagar uma categoria-pai não apague as subcategorias, apenas as "promova" a categorias de topo.

**Produto vs. variação** — o desafio pede que o mesmo produto tenha variações com preço e estoque próprios, então separei:

- `produtos`: dados gerais e fixos do móvel — nome, descrição, categoria, tipo de madeira, dimensões (largura/altura/profundidade) e peso.
- `variacoes_produto`: o que muda entre versões comerciais do mesmo produto — SKU, acabamento/cor e preço.

Exemplo: o produto "Mesa de Jantar Aurora" pode ter variações em acabamento natural, castanho e preto fosco, cada uma com seu próprio SKU e preço.

**Imagens** — `imagens_produto` referencia sempre `produto_id` e, opcionalmente, `variacao_produto_id`, permitindo tanto fotos gerais do produto quanto fotos específicas de um acabamento.

### Pedidos e itens do pedido

`pedidos` registra cliente, endereço de entrega, status, frete e total. `itens_pedido` guarda cada variação comprada, com `quantidade` e `preco_unitario` — o preço é duplicado no item (em vez de buscar sempre em `variacoes_produto`) para preservar o valor praticado no momento da compra, mesmo que o preço do catálogo mude depois.

### Status do pedido: ENUM nativo

```sql
CREATE TYPE status_pedido AS ENUM (
    'aguardando_pagamento', 'pago', 'em_separacao',
    'enviado', 'entregue', 'cancelado'
);
```

Usei `ENUM` porque o pedido tem um fluxo de status fixo e conhecido de antemão — o Postgres já garante que nenhum valor fora da lista seja gravado, sem precisar de uma tabela de domínio extra com JOIN.

Para o **pagamento**, mantive `status` como `VARCHAR(30)` em vez de ENUM, porque esse campo tende a espelhar o status devolvido por gateways de pagamento externos (ex.: Stripe, Mercado Pago), que variam entre provedores e mudam com mais frequência que o status do pedido — um ENUM engessaria isso. Em uma versão futura, uma tabela de domínio (`status_pagamento`) seria mais flexível que ambos.

### Frete

O banco não calcula frete — apenas guarda os dados necessários para o cálculo (peso e dimensões em `produtos`, endereço de entrega em `enderecos`). O valor final calculado pela aplicação é armazenado em `pedidos.valor_frete`. Envio e entrega são representados pelos próprios status do pedido (`enviado`, `entregue`), sem uma tabela separada de "entrega".

### Estoque

`estoques` guarda a quantidade disponível por **variação de produto e por depósito** (`UNIQUE (variacao_produto_id, deposito_id)`), já que o controle é por variação, não por produto — cada acabamento/cor tem sua própria quantidade em cada centro de distribuição. `depositos` (bônus) modela os centros de distribuição (nome, localização); uma mesma variação pode ter estoque em mais de um depósito, e o estoque total do produto é a soma entre eles. `quantidade_disponivel` é `INTEGER` com `CHECK >= 0`.

### Carrinho e itens do carrinho

`carrinhos` representa a intenção de compra do cliente antes de virar pedido — 1:N com `clientes`, com `status` (`aberto`, `finalizado`, `abandonado`) validado por `CHECK`. `carrinho_itens` guarda a variação e a quantidade escolhida, com `UNIQUE (carrinho_id, variacao_produto_id)` para não duplicar a mesma variação como duas linhas no mesmo carrinho — adicionar de novo deve atualizar a quantidade, não inserir outra linha. Ao contrário de `itens_pedido`, não guarda `preco_unitario`: o carrinho reflete o preço atual do catálogo, não um valor congelado (isso só passa a existir quando o pedido é criado). Ver `docs/fluxo-carrinho-pedido.md` para o fluxo completo até o pedido.

### Avaliações

`avaliacoes` referencia `item_pedido_id` (não `produto_id` ou `cliente_id` diretamente), com `UNIQUE` nesse campo. Isso garante, pela própria FK, que só é possível avaliar um item efetivamente comprado, e no máximo uma vez por item — sem precisar de uma trigger para checar "o cliente comprou esse produto?". `nota` tem `CHECK BETWEEN 1 AND 5`.

---

## Tipos de dados

- `NUMERIC` para dinheiro, medidas e peso — nunca `FLOAT`/`REAL`, para não ter erro de arredondamento em valor monetário.
- `INTEGER` para quantidades.
- `TIMESTAMPTZ` para todas as datas.
- `VARCHAR` para textos curtos e limitados (nome, SKU, e-mail); `TEXT` para descrição/comentário, sem limite natural de tamanho.
- `BOOLEAN` para flags (`ativo`).

## Constraints de integridade

`NOT NULL` em obrigatórios, `UNIQUE` contra duplicidade (e-mail do cliente, SKU da variação, uma avaliação por item), `CHECK` para regras de negócio (preço e peso/dimensões > 0, estoque e frete >= 0, quantidade do item > 0, nota entre 1 e 5) e `FOREIGN KEY` em todos os relacionamentos.

## ON DELETE / ON UPDATE

`ON UPDATE CASCADE` em todas as FKs, para manter os relacionamentos consistentes se algum ID mudar.

Para `ON DELETE`, a regra que segui foi: **dado histórico não pode sumir, dado dependente sem o pai não faz sentido existir**.

- `RESTRICT` — pedidos, itens de pedido (via variação), pagamentos: impede apagar cliente, endereço, produto/variação ou pedido que já tem histórico associado.
- `CASCADE` — endereços de um cliente, imagens de um produto/variação, estoque de uma variação, itens de um pedido, carrinhos de um cliente, itens de um carrinho: fazem sentido apenas enquanto o "dono" existir.
- `SET NULL` — `categoria_pai_id`: apagar uma categoria-pai não deve apagar as subcategorias.

## Índices

Todas as FKs têm índice (categoria do produto, produto da variação, cliente/endereço/status do pedido, pedido/variação do item, pedido/status do pagamento). Também criei índices únicos parciais em `categorias` (um para categorias de topo, outro para subcategorias dentro do mesmo pai) para evitar nomes duplicados sem impedir o mesmo nome em ramos diferentes da hierarquia. Colunas com `PRIMARY KEY`/`UNIQUE` já geram índice automático no Postgres, então evitei duplicar índice nelas.

---

## Suposições feitas

- Cada produto pertence a exatamente uma categoria; subcategorias são a mesma tabela `categorias` com `categoria_pai_id` preenchido.
- Endereço de entrega e de cobrança são o mesmo modelo (`enderecos`), diferenciados pelo campo `tipo_endereco`.
- O cálculo de frete é responsabilidade da aplicação; o banco só armazena peso/dimensões (entrada) e o valor final (saída, em `pedidos.valor_frete`).
- Avaliação exige compra: vinculei `avaliacoes` a `itens_pedido`, não a `produtos`, para que a integridade referencial já impeça avaliação sem compra.
- Hashing de senha não foi implementado de verdade — só o campo `senha_hash` foi modelado.
- `valor_total` do pedido fica em `pedidos`, a ser preenchido pela aplicação a partir dos itens + frete (o banco não recalcula isso via trigger).

---

## Como executar

```sql
-- cria tudo do zero
\i schema.sql

-- popula com dados de teste (bônus)
\i sql/seed.sql

-- para recriar do zero
\i sql/04_drop_tables.sql
\i schema.sql
```

`schema.sql` cria, na ordem: o ENUM `status_pedido`, as 14 tabelas (`categorias`, `produtos`, `variacoes_produto`, `imagens_produto`, `clientes`, `enderecos`, `carrinhos`, `carrinho_itens`, `pedidos`, `itens_pedido`, `pagamentos`, `depositos`, `estoques`, `avaliacoes`) e os índices.

---

## Bônus entregues

- **`sql/seed.sql`** — dados de teste com três fluxos de compra completos até o pagamento; um deles também demonstra a avaliação de um item comprado.
- **`sql/03_consultas_teste.sql`** — queries de exemplo: resumo de pedidos, produtos mais vendidos por categoria, produtos com estoque baixo, ticket médio por cliente.
- **Múltiplos depósitos** — tabela `depositos`, com `estoques` relacionando variação de produto a depósito.
- **Diagrama ER visual** — ver link em `docs/diagrama-er.md` (dbdiagram.io).

## O que faria diferente com mais tempo

- Trigger para atualizar `updated_at` automaticamente, em vez de depender da aplicação.
- Tabela de domínio para status de pagamento, em vez de `VARCHAR` livre.
- Histórico de movimentações de estoque (auditoria de entradas/saídas), não só a quantidade atual.
- Trigger ou constraint adicional para validar transições de status do pedido (hoje qualquer status pode ir para qualquer status).
- No `seed.sql`, demonstrar um produto com mais de uma variação (cores/acabamentos diferentes) — hoje cada produto de exemplo tem só uma.
