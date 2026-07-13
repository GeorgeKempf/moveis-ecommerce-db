# Mapeamento dos relacionamentos

## Categorias

- Uma categoria pode possuir várias subcategorias.
- Uma subcategoria pertence a uma categoria principal.
- Uma categoria pode possuir vários produtos.
- Cada produto pertence a apenas uma categoria.

```text
categorias 1:N categorias
categorias 1:N produtos
```

## Produtos, variações e imagens

- Um produto pode possuir várias variações.
- Cada variação pertence a apenas um produto.
- Uma variação possui seu próprio SKU, acabamento ou cor e preço.
- Um produto pode possuir várias imagens.
- Uma imagem pertence a apenas um produto.
- Uma imagem pode estar vinculada a uma variação específica.

```text
produtos 1:N variacoes_produto
produtos 1:N imagens_produto
variacoes_produto 1:N imagens_produto
```

## Clientes e endereços

- Um cliente pode possuir vários endereços.
- Cada endereço pertence a apenas um cliente.
- Um cliente pode possuir vários carrinhos.
- Um cliente pode realizar vários pedidos.
- Cada carrinho pertence a apenas um cliente.
- Cada pedido pertence a apenas um cliente.

```text
clientes 1:N enderecos
clientes 1:N carrinhos
clientes 1:N pedidos
```

## Carrinhos

- Um carrinho pode possuir vários itens.
- Cada item pertence a apenas um carrinho.
- Cada item do carrinho referencia uma variação de produto.
- Uma variação pode aparecer em vários carrinhos.
- O relacionamento N:N entre carrinhos e variações é resolvido pela tabela `carrinho_itens`.

```text
carrinhos 1:N carrinho_itens
variacoes_produto 1:N carrinho_itens
```

## Pedidos

- Um pedido pode possuir vários itens.
- Cada item pertence a apenas um pedido.
- Cada item do pedido referencia uma variação de produto.
- Uma variação pode aparecer em vários pedidos.
- O relacionamento N:N entre pedidos e variações é resolvido pela tabela `itens_pedido`.
- Cada pedido possui um endereço de entrega.

```text
pedidos 1:N itens_pedido
variacoes_produto 1:N itens_pedido
enderecos 1:N pedidos
```

## Pagamentos

- Um pedido pode possuir vários registros de pagamento.
- Cada pagamento pertence a apenas um pedido.

```text
pedidos 1:N pagamentos
```

## Estoque e depósitos

- Uma variação de produto pode possuir estoque em vários depósitos.
- Um depósito pode armazenar várias variações.
- O relacionamento N:N entre variações e depósitos é resolvido pela tabela `estoques`.
- Cada registro de estoque armazena a quantidade disponível daquela variação em um depósito.

```text
variacoes_produto 1:N estoques
depositos 1:N estoques
```

## Avaliações

- Uma avaliação pertence a apenas um item do pedido.
- Um item comprado pode possuir no máximo uma avaliação.
- O produto avaliado é identificado pela variação registrada no item do pedido.
- O cliente responsável pela avaliação é identificado pelo pedido.
- A avaliação só pode existir para uma compra registrada.

```text
itens_pedido 1:0..1 avaliacoes
```

## Relacionamentos N:N resolvidos

Os relacionamentos muitos-para-muitos foram resolvidos por tabelas intermediárias:

```text
carrinhos N:N variacoes_produto
→ carrinho_itens

pedidos N:N variacoes_produto
→ itens_pedido

variacoes_produto N:N depositos
→ estoques
```

# Diagrama Entidade-Relacionamento

O diagrama representa as entidades, os atributos principais, as chaves primárias, as chaves estrangeiras e as cardinalidades do banco de dados do e-commerce de móveis.

[Abrir o Diagrama Entidade-Relacionamento no dbdiagram.io](https://dbdiagram.io/d/6a4e425036d348d1209646fc)