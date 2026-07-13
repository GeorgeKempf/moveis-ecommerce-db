# Regras de negócio

## Clientes e endereços

- Um cliente pode possuir vários endereços.
- Cada endereço pertence a apenas um cliente.
- Cada endereço deve indicar seu tipo: entrega ou cobrança.
- O e-mail do cliente não pode ser repetido.
- O cliente possui uma senha para autenticação, apenas modelada no banco, sem implementação real de hashing.

## Categorias e produtos

- Uma categoria pode possuir várias subcategorias.
- Uma categoria pode possuir vários produtos.
- Cada produto pertence a uma categoria.
- Um produto possui atributos próprios de móveis, como tipo de madeira, dimensões e peso.
- As dimensões e o peso devem ser maiores que zero.
- O preço e o estoque não ficam diretamente no produto, pois são controlados por variação.

## Variações de produto

- Um produto pode possuir várias variações.
- Cada variação pertence a apenas um produto.
- Cada variação possui um SKU único.
- Cada variação possui acabamento ou cor própria.
- Cada variação possui seu próprio preço.
- O preço da variação deve ser maior que zero.
- Cada variação pode possuir imagens vinculadas.

## Imagens de produto

- Uma imagem deve pertencer a um produto.
- Uma imagem pode estar vinculada a uma variação específica.
- A imagem deve armazenar uma URL ou caminho.
- Ao excluir um produto, suas imagens relacionadas podem ser excluídas junto.
- Quando a imagem estiver vinculada a uma variação, ela representa especificamente aquela variação.

## Carrinhos

- Um cliente pode possuir vários carrinhos.
- Cada carrinho pertence a apenas um cliente.
- Um carrinho pode possuir os status aberto, finalizado ou abandonado.
- Um carrinho pode possuir vários itens.
- Cada item do carrinho pertence a apenas um carrinho.
- Cada item do carrinho referencia uma variação de produto.
- A quantidade de um item deve ser maior que zero.
- A mesma variação não pode aparecer mais de uma vez no mesmo carrinho.

## Pedidos

- Um cliente pode realizar vários pedidos.
- Cada pedido pertence a apenas um cliente.
- Um pedido deve possuir um endereço de entrega.
- Um pedido pode possuir vários itens.
- Cada item pertence a apenas um pedido.
- Cada item do pedido referencia uma variação de produto.
- A quantidade de cada item deve ser maior que zero.
- O preço unitário deve ser armazenado no item do pedido para preservar o valor praticado no momento da compra.
- O pedido deve possuir um status.
- O pedido deve armazenar o valor do frete e o valor total.
- O cálculo real do frete pertence à aplicação, considerando peso e dimensões dos produtos.

## Pagamentos

- Um pagamento pertence a um pedido.
- Um pedido pode possuir registros de pagamento.
- O pagamento deve possuir uma forma de pagamento.
- O pagamento deve possuir um status.
- O pagamento deve possuir um valor.
- O valor do pagamento deve ser maior que zero.
- A data do pagamento deve ser registrada quando o pagamento for realizado.

## Estoque e depósitos

- O estoque é controlado por variação de produto.
- Uma mesma variação pode possuir estoque em vários depósitos.
- Um depósito pode armazenar várias variações.
- O relacionamento N:N entre variações e depósitos é resolvido pela tabela `estoques`.
- Cada registro de estoque possui uma quantidade disponível.
- Cada combinação entre variação e depósito deve ser única.
- A quantidade disponível deve ser um número inteiro.
- O estoque não pode possuir quantidade negativa.
- O suporte a múltiplos depósitos foi implementado pelas tabelas `depositos` e `estoques`.

## Avaliações

- Uma avaliação deve estar vinculada a um item do pedido.
- A avaliação só pode existir para um item comprado.
- Cada item comprado pode possuir no máximo uma avaliação.
- O produto avaliado é identificado pela variação existente no item do pedido.
- O cliente responsável é identificado pelo pedido ao qual o item pertence.
- A avaliação possui nota e comentário.
- A nota deve estar entre 1 e 5.