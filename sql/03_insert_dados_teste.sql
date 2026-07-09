-- Nível 1
INSERT INTO categorias (categoria_pai_id, nome, descricao) VALUES
(NULL, 'Móveis de Madeira', 'Todos os móveis em madeira maciça e derivados');

-- Nível 2 (pai = 1)
INSERT INTO categorias (categoria_pai_id, nome, descricao) VALUES
(1, 'Sala de Estar', 'Móveis de madeira para ambientes de convivência'),
(1, 'Quarto', 'Móveis de madeira para dormitórios'),
(1, 'Cozinha e Sala de Jantar', 'Móveis de madeira para refeições e preparo');

-- Nível 3 (pais = 2, 3, 4)
INSERT INTO categorias (categoria_pai_id, nome, descricao) VALUES
(2, 'Mesas de Centro', 'Mesas de centro em madeira maciça'),
(2, 'Racks e Painéis', 'Racks e painéis para TV em madeira'),
(3, 'Camas', 'Camas em madeira maciça'),
(3, 'Guarda-Roupas', 'Guarda-roupas e armários de madeira'),
(4, 'Mesas de Jantar', 'Mesas de jantar em madeira'),
(4, 'Cadeiras e Banquetas', 'Cadeiras e banquetas de madeira');