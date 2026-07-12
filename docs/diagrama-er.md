# Mapeamento dos relacionamentos

## Categorias

- Uma categoria pode possuir várias subcategorias.
- Uma categoria pode possuir vários produtos.
- Cada produto pertence a uma categoria.

## Produtos

- Um produto pode possuir várias variações.
- Cada variação pertence a apenas um produto.
- Um produto pode possuir várias imagens.
- Cada imagem pertence a apenas um produto.

## Clientes

- Um cliente pode possuir vários endereços.
- Cada endereço pertence a apenas um cliente.
- Um cliente pode realizar vários pedidos.
- Cada pedido pertence a apenas um cliente.

## Pedidos

- Um pedido pode possuir vários itens.
- Cada item pertence a apenas um pedido.
- Cada item do pedido referencia uma variação de produto.
- Um pedido pode possuir um registro de pagamento.
- Cada pagamento pertence a apenas um pedido.

## Estoque

- Cada variação de produto possui controle de estoque.

## Avaliações

- Um produto pode receber várias avaliações.
- Cada avaliação pertence a apenas um produto.
- Cada avaliação pertence a apenas um cliente.
- Uma avaliação deve estar vinculada a uma compra realizada.

# Diagrama Entidade-Relacionamento

O diagrama abaixo representa as entidades, os atributos principais e os relacionamentos do banco de dados do e-commerce de móveis.

![Diagrama Entidade-Relacionamento](https://dbdiagram.io/d/6a4e425036d348d1209646fc)