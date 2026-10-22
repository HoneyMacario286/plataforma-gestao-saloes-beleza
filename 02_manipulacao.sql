-- ============================================================
-- PROJETO: PLATAFORMA DE GESTAO DE SALOES DE BELEZA
-- Ficheiro: 02_manipulacao.sql
-- Ambiente de teste: XAMPP / phpMyAdmin (MySQL/MariaDB)
-- Executar depois de criar a base de dados com o ficheiro 01.
-- O ultimo INSERT deve falhar intencionalmente por causa da FK.
-- ============================================================
USE plataforma_saloes;

-- 1) SELECT com WHERE e ORDER BY: saloes ativos na Beira.
SELECT id_salao, nome, cidade, bairro, telefone
FROM Salao
WHERE cidade = 'Beira' AND estado = 'Ativo'
ORDER BY nome ASC;

-- 2) SELECT com WHERE e ORDER BY: procedimentos ate 900 MT.
SELECT id_procedimento, nome, preco, duracao_minutos
FROM Procedimento
WHERE preco <= 900
ORDER BY preco ASC;

-- 3) SELECT com WHERE e ORDER BY: produtos no nivel minimo de stock ou abaixo.
SELECT id_produto, nome, quantidade, stock_minimo
FROM Produto
WHERE quantidade <= stock_minimo
ORDER BY quantidade ASC;

-- 4) SELECT com JOIN: marcacoes com cliente, salao, procedimento e funcionario.
SELECT m.id_marcacao, c.nome_completo AS cliente, s.nome AS salao,
       p.nome AS procedimento, f.nome_completo AS funcionario,
       m.data_hora, m.estado
FROM Marcacao m
JOIN Cliente c ON m.id_cliente = c.id_cliente
JOIN Salao s ON m.id_salao = s.id_salao
JOIN Procedimento p ON m.id_procedimento = p.id_procedimento
JOIN Funcionario f ON m.id_funcionario = f.id_funcionario
ORDER BY m.data_hora;

-- 5) SELECT com JOIN: movimentos de stock com produto e salao.
SELECT p.nome AS produto, s.nome AS salao, ms.tipo, ms.quantidade,
       ms.data_movimento, ms.motivo
FROM MovimentoStock ms
JOIN Produto p ON ms.id_produto = p.id_produto
JOIN Salao s ON p.id_salao = s.id_salao
ORDER BY ms.data_movimento DESC;

-- 6) UPDATE: confirmar a marcacao 2.
UPDATE Marcacao
SET estado = 'Confirmada', observacao = 'Confirmada pelo salao'
WHERE id_marcacao = 2;

-- 7) UPDATE: atualizar o stock do produto 1 para 17 unidades.
-- No conjunto inicial, o produto 1 tem 12 unidades. Definir 17 torna
-- o exemplo repetivel sem somar mais 5 sempre que o script for reexecutado.
UPDATE Produto
SET quantidade = 17
WHERE id_produto = 1;

-- 8) DELETE respeitando a chave estrangeira.
-- Criamos dados temporarios, apagamos primeiro o registo dependente
-- (MovimentoStock) e depois o produto. Assim, mantemos os 20 registos
-- originais em cada tabela no final da demonstracao.
INSERT INTO Produto
(id_produto, id_salao, nome, categoria, quantidade, stock_minimo, preco_unitario, estado)
VALUES
(21, 1, 'Produto temporario de teste', 'Teste', 1, 1, 1.00, 'Disponivel');

INSERT INTO MovimentoStock
(id_movimento, id_produto, tipo, quantidade, data_movimento, motivo)
VALUES
(21, 21, 'Entrada', 1, NOW(), 'Movimento temporario de teste');

DELETE FROM MovimentoStock
WHERE id_movimento = 21;

DELETE FROM Produto
WHERE id_produto = 21;

-- Verificacao opcional: depois do DELETE, as 11 tabelas devem ter 20 registos.
SELECT 'Salao' AS tabela, COUNT(*) AS total FROM Salao
UNION ALL SELECT 'Utilizador', COUNT(*) FROM Utilizador
UNION ALL SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL SELECT 'Funcionario', COUNT(*) FROM Funcionario
UNION ALL SELECT 'Procedimento', COUNT(*) FROM Procedimento
UNION ALL SELECT 'Marcacao', COUNT(*) FROM Marcacao
UNION ALL SELECT 'HistoricoMarcacao', COUNT(*) FROM HistoricoMarcacao
UNION ALL SELECT 'Produto', COUNT(*) FROM Produto
UNION ALL SELECT 'MovimentoStock', COUNT(*) FROM MovimentoStock
UNION ALL SELECT 'HorarioFuncionario', COUNT(*) FROM HorarioFuncionario
UNION ALL SELECT 'Atendimento', COUNT(*) FROM Atendimento;

-- 9) Teste de integridade referencial: este INSERT DEVE falhar.
-- O salao 9999 nao existe; o MySQL/MariaDB deve rejeitar a linha pela FK.
-- Execute este INSERT isoladamente no phpMyAdmin para ver o erro esperado.
INSERT INTO Utilizador
(id_salao, nome_completo, email, palavra_passe_hash, perfil, estado, data_criacao)
VALUES
(9999, 'Teste Integridade', 'teste.integridade@example.com',
 'DEMO_NAO_E_HASH', 'Gestor', 'Ativo', '2026-10-20');
