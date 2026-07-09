# Regras de negócio

## Clientes e endereços

- Um cliente pode possuir vários endereços.
- Cada endereço pertence a apenas um cliente.
- Cada endereço deve indicar seu tipo: entrega ou cobrança.
- O e-mail do cliente não pode ser repetido.
- O cliente possui uma senha para autenticação, apenas modelada no banco, sem implementação real de hashing.

## Categorias e produtos

- Uma categoria pode possuir subcategorias.
- Uma categoria pode possuir vários produtos.
- Um produto pertence a uma categoria.
- Um produto possui atributos próprios de móveis, como tipo de madeira, dimensões e peso.
- As dimensões e o peso devem ser maiores que zero.
- O preço e o estoque não ficam diretamente no produto, pois são controlados por variação.

## Variações de produto

- Um produto pode possuir várias variações.
- Cada variação pertence a apenas um produto.
- Cada variação possui SKU único.
- Cada variação possui acabamento ou cor própria.
- Cada variação possui seu próprio preço.
- O preço da variação deve ser maior que zero.
- Cada variação pode possuir imagens vinculadas.

## Imagens de produto

- Uma imagem pertence a um produto.
- Uma imagem pode estar vinculada a uma variação específica.
- A imagem deve armazenar uma URL ou caminho.
- Ao excluir um produto ou variação, as imagens relacionadas podem ser excluídas junto.

## Pedidos

- Um cliente pode realizar vários pedidos.
- Cada pedido pertence a apenas um cliente.
- Cada pedido possui um endereço de entrega.
- Um pedido pode possuir vários itens.
- Cada item do pedido representa uma variação de produto comprada.
- A quantidade do item deve ser maior que zero.
- O preço praticado no momento da compra deve ser preservado no item do pedido.
- O pedido deve possuir um status.
- O pedido deve armazenar o valor do frete.
- O valor total do pedido pode ser calculado a partir dos itens do pedido e do frete.
- O frete será calculado pela aplicação usando peso, dimensões e endereço de entrega.

## Pagamentos

- Um pagamento pertence a um pedido.
- O pagamento deve possuir uma forma de pagamento.
- O pagamento deve possuir um status.
- O pagamento deve possuir um valor.
- O valor do pagamento deve ser maior que zero.
- A data do pagamento deve ser registrada quando o pagamento for realizado.

## Estoque

- O estoque é controlado por variação de produto.
- Cada variação deve possuir no máximo um registro de estoque.
- A quantidade disponível deve ser um número inteiro.
- O estoque não pode possuir quantidade negativa.
- O suporte a múltiplos depósitos não foi implementado, pois é bônus/opcional no desafio.

## Avaliações

- Uma avaliação deve estar vinculada a um item de pedido.
- A avaliação só pode existir para um item comprado.
- Cada item comprado pode possuir no máximo uma avaliação.
- A avaliação possui nota e comentário.
- A nota deve estar entre 1 e 5.