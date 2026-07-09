# Fluxo Carrinho → Pedido

Este documento descreve o fluxo de compra do e-commerce de móveis, considerando a etapa de carrinho antes da criação do pedido.

## Objetivo

O carrinho representa uma intenção de compra temporária do cliente.

Nele são armazenadas as variações dos produtos escolhidos e suas respectivas quantidades. Quando o cliente finaliza a compra, os dados do carrinho são utilizados para gerar um pedido e seus itens.

## Fluxo principal

```text
Cliente escolhe um produto
↓
Seleciona uma variação do produto
↓
Adiciona a variação ao carrinho
↓
O carrinho armazena a variação e a quantidade
↓
Cliente finaliza a compra
↓
Sistema cria um pedido
↓
Itens do carrinho viram itens do pedido
↓
Pagamento é vinculado ao pedido
↓
Carrinho muda para finalizado