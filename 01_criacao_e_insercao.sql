-- ============================================================
-- PROJETO: PLATAFORMA DE GESTAO DE SALOES DE BELEZA
-- Ficheiro: 01_criacao_e_insercao.sql
-- SGBD: MySQL 8.0+
-- ATENCAO: este script elimina a base de dados homonima se existir.
-- Execute apenas se nao tiver dados importantes nessa base de dados.
-- ============================================================

DROP DATABASE IF EXISTS plataforma_saloes;
CREATE DATABASE plataforma_saloes
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE plataforma_saloes;

CREATE TABLE Salao (
    id_salao INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    provincia VARCHAR(60) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    bairro VARCHAR(80) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    endereco VARCHAR(180) NOT NULL,
    hora_abertura TIME NOT NULL,
    hora_fecho TIME NOT NULL,
    estado ENUM('Ativo','Inativo') NOT NULL DEFAULT 'Ativo'
);

CREATE TABLE Utilizador (
    id_utilizador INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    nome_completo VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    palavra_passe_hash VARCHAR(255) NOT NULL,
    perfil ENUM('Proprietario','Gestor','Funcionario') NOT NULL,
    estado ENUM('Ativo','Bloqueado') NOT NULL DEFAULT 'Ativo',
    data_criacao DATE NOT NULL,
    CONSTRAINT fk_utilizador_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao)
);

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(120) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(120) UNIQUE,
    data_registo DATE NOT NULL,
    estado ENUM('Ativo','Inativo') NOT NULL DEFAULT 'Ativo'
);

CREATE TABLE Funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    nome_completo VARCHAR(120) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    data_admissao DATE NOT NULL,
    estado ENUM('Ativo','Inativo') NOT NULL DEFAULT 'Ativo',
    CONSTRAINT fk_funcionario_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao)
);

CREATE TABLE Procedimento (
    id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NOT NULL,
    duracao_minutos INT NOT NULL,
    estado ENUM('Disponivel','Desativado') NOT NULL DEFAULT 'Disponivel',
    CONSTRAINT chk_procedimento_preco CHECK (preco >= 0),
    CONSTRAINT chk_procedimento_duracao CHECK (duracao_minutos > 0),
    CONSTRAINT fk_procedimento_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao)
);

CREATE TABLE Marcacao (
    id_marcacao INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    id_cliente INT NOT NULL,
    id_procedimento INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_hora DATETIME NOT NULL,
    estado ENUM('Pendente','Confirmada','Em atendimento','Concluida','Cancelada','Nao compareceu')
      NOT NULL DEFAULT 'Pendente',
    observacao VARCHAR(255),
    data_criacao DATETIME NOT NULL,
    CONSTRAINT fk_marcacao_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao),
    CONSTRAINT fk_marcacao_cliente FOREIGN KEY (id_cliente)
      REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_marcacao_procedimento FOREIGN KEY (id_procedimento)
      REFERENCES Procedimento(id_procedimento),
    CONSTRAINT fk_marcacao_funcionario FOREIGN KEY (id_funcionario)
      REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE HistoricoMarcacao (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_marcacao INT NOT NULL,
    estado_anterior VARCHAR(30),
    estado_novo VARCHAR(30) NOT NULL,
    data_alteracao DATETIME NOT NULL,
    observacao VARCHAR(255),
    CONSTRAINT fk_historico_marcacao FOREIGN KEY (id_marcacao)
      REFERENCES Marcacao(id_marcacao)
);

CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 3,
    preco_unitario DECIMAL(10,2) NOT NULL,
    estado ENUM('Disponivel','Desativado') NOT NULL DEFAULT 'Disponivel',
    CONSTRAINT chk_produto_quantidade CHECK (quantidade >= 0),
    CONSTRAINT chk_produto_stock_minimo CHECK (stock_minimo >= 0),
    CONSTRAINT chk_produto_preco CHECK (preco_unitario >= 0),
    CONSTRAINT fk_produto_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao)
);

CREATE TABLE MovimentoStock (
    id_movimento INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    tipo ENUM('Entrada','Saida','Ajuste') NOT NULL,
    quantidade INT NOT NULL,
    data_movimento DATETIME NOT NULL,
    motivo VARCHAR(180) NOT NULL,
    CONSTRAINT chk_movimento_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_movimento_produto FOREIGN KEY (id_produto)
      REFERENCES Produto(id_produto)
);

CREATE TABLE HorarioFuncionario (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT NOT NULL,
    dia_semana ENUM('Segunda','Terca','Quarta','Quinta','Sexta','Sabado','Domingo') NOT NULL,
    hora_inicio TIME,
    hora_fim TIME,
    tipo_dia ENUM('Trabalho','Folga','Ausencia') NOT NULL DEFAULT 'Trabalho',
    observacao VARCHAR(180),
    CONSTRAINT fk_horario_funcionario FOREIGN KEY (id_funcionario)
      REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE Atendimento (
    id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
    id_salao INT NOT NULL,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_procedimento INT NOT NULL,
    id_marcacao INT NULL,
    data_hora DATETIME NOT NULL,
    tipo ENUM('Com marcacao','Sem marcacao') NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    observacao VARCHAR(255),
    CONSTRAINT chk_atendimento_valor CHECK (valor_pago >= 0),
    CONSTRAINT fk_atendimento_salao FOREIGN KEY (id_salao)
      REFERENCES Salao(id_salao),
    CONSTRAINT fk_atendimento_cliente FOREIGN KEY (id_cliente)
      REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_atendimento_funcionario FOREIGN KEY (id_funcionario)
      REFERENCES Funcionario(id_funcionario),
    CONSTRAINT fk_atendimento_procedimento FOREIGN KEY (id_procedimento)
      REFERENCES Procedimento(id_procedimento),
    CONSTRAINT fk_atendimento_marcacao FOREIGN KEY (id_marcacao)
      REFERENCES Marcacao(id_marcacao)
);

-- 20 saloes
INSERT INTO Salao (nome,provincia,cidade,bairro,telefone,email,endereco,hora_abertura,hora_fecho,estado) VALUES
('Beleza Natural','Sofala','Beira','Ponta-Gea','258840000001','beleza1@example.com','Rua 1, Ponta-Gea','08:00:00','18:00:00','Ativo'),
('Estilo Chic','Sofala','Beira','Macuti','258840000002','beleza2@example.com','Rua 2, Macuti','08:30:00','18:30:00','Ativo'),
('Rainha do Cabelo','Sofala','Dondo','Centro','258840000003','beleza3@example.com','Rua 3, Centro','08:00:00','17:00:00','Ativo'),
('Toque de Ouro','Maputo Cidade','Maputo','Polana','258840000004','beleza4@example.com','Rua 4, Polana','09:00:00','19:00:00','Ativo'),
('Charme Feminino','Maputo Provincia','Matola','Liberdade','258840000005','beleza5@example.com','Rua 5, Liberdade','08:00:00','18:00:00','Ativo'),
('Cabelo e Arte','Nampula','Nampula','Central','258840000006','beleza6@example.com','Rua 6, Central','08:00:00','17:30:00','Ativo'),
('Mao Magica','Zambezia','Quelimane','Coalane','258840000007','beleza7@example.com','Rua 7, Coalane','08:00:00','18:00:00','Ativo'),
('Brilho Puro','Tete','Tete','Matundo','258840000008','beleza8@example.com','Rua 8, Matundo','08:30:00','18:00:00','Ativo'),
('Estetica Bella','Manica','Chimoio','Centro','258840000009','beleza9@example.com','Rua 9, Centro','09:00:00','18:00:00','Ativo'),
('Diva Moderna','Gaza','Xai-Xai','Praia','258840000010','beleza10@example.com','Rua 10, Praia','08:00:00','17:00:00','Ativo'),
('Tesoura Fina','Inhambane','Inhambane','Balane','258840000011','beleza11@example.com','Rua 11, Balane','08:00:00','17:00:00','Ativo'),
('Pente de Prata','Cabo Delgado','Pemba','Natite','258840000012','beleza12@example.com','Rua 12, Natite','08:00:00','18:00:00','Ativo'),
('Espaco Glamour','Niassa','Lichinga','Centro','258840000013','beleza13@example.com','Rua 13, Centro','08:00:00','17:00:00','Ativo'),
('Flor de Loto','Sofala','Beira','Munhava','258840000014','beleza14@example.com','Rua 14, Munhava','08:00:00','18:00:00','Ativo'),
('Afro Estilo','Sofala','Beira','Chingussura','258840000015','beleza15@example.com','Rua 15, Chingussura','08:00:00','18:00:00','Ativo'),
('Linda Sempre','Maputo Cidade','Maputo','Maxaquene','258840000016','beleza16@example.com','Rua 16, Maxaquene','08:00:00','18:00:00','Ativo'),
('Coroa de Beleza','Nampula','Nacala','Centro','258840000017','beleza17@example.com','Rua 17, Centro','08:00:00','17:00:00','Ativo'),
('Estilo Jovem','Tete','Moatize','Centro','258840000018','beleza18@example.com','Rua 18, Centro','08:00:00','17:00:00','Ativo'),
('Arte Capilar','Zambezia','Mocuba','Centro','258840000019','beleza19@example.com','Rua 19, Centro','08:00:00','18:00:00','Ativo'),
('Elegancia','Manica','Gondola','Centro','258840000020','beleza20@example.com','Rua 20, Centro','08:00:00','17:00:00','Ativo');

-- 20 utilizadores de exemplo. As palavras-passe abaixo sao dados demonstrativos,
-- nao sao hashes reais e nao devem ser usados num sistema publicado.
INSERT INTO Utilizador (id_salao,nome_completo,email,palavra_passe_hash,perfil,estado,data_criacao) VALUES
(1,'Ana Mucavele','utilizador1@example.com','DEMO_NAO_E_HASH_01','Proprietario','Ativo','2026-01-01'),
(2,'Berta Sitoe','utilizador2@example.com','DEMO_NAO_E_HASH_02','Proprietario','Ativo','2026-01-02'),
(3,'Celina Mussa','utilizador3@example.com','DEMO_NAO_E_HASH_03','Proprietario','Ativo','2026-01-03'),
(4,'Dina Macuacua','utilizador4@example.com','DEMO_NAO_E_HASH_04','Proprietario','Ativo','2026-01-04'),
(5,'Elsa Jamal','utilizador5@example.com','DEMO_NAO_E_HASH_05','Proprietario','Ativo','2026-01-05'),
(6,'Fatima Cossa','utilizador6@example.com','DEMO_NAO_E_HASH_06','Proprietario','Ativo','2026-01-06'),
(7,'Graca Mbanze','utilizador7@example.com','DEMO_NAO_E_HASH_07','Proprietario','Ativo','2026-01-07'),
(8,'Helena Bila','utilizador8@example.com','DEMO_NAO_E_HASH_08','Proprietario','Ativo','2026-01-08'),
(9,'Ivone Tembe','utilizador9@example.com','DEMO_NAO_E_HASH_09','Proprietario','Ativo','2026-01-09'),
(10,'Joana Nhantumbo','utilizador10@example.com','DEMO_NAO_E_HASH_10','Proprietario','Ativo','2026-01-10'),
(11,'Lina Chongo','utilizador11@example.com','DEMO_NAO_E_HASH_11','Proprietario','Ativo','2026-01-11'),
(12,'Marta Sumbana','utilizador12@example.com','DEMO_NAO_E_HASH_12','Proprietario','Ativo','2026-01-12'),
(13,'Nadia Langa','utilizador13@example.com','DEMO_NAO_E_HASH_13','Proprietario','Ativo','2026-01-13'),
(14,'Olga Matusse','utilizador14@example.com','DEMO_NAO_E_HASH_14','Proprietario','Ativo','2026-01-14'),
(15,'Paula Manjate','utilizador15@example.com','DEMO_NAO_E_HASH_15','Proprietario','Ativo','2026-01-15'),
(16,'Quiteria Cumbane','utilizador16@example.com','DEMO_NAO_E_HASH_16','Proprietario','Ativo','2026-01-16'),
(17,'Rosa Macamo','utilizador17@example.com','DEMO_NAO_E_HASH_17','Proprietario','Ativo','2026-01-17'),
(18,'Sara Bila','utilizador18@example.com','DEMO_NAO_E_HASH_18','Proprietario','Ativo','2026-01-18'),
(19,'Teresa Mucavele','utilizador19@example.com','DEMO_NAO_E_HASH_19','Proprietario','Ativo','2026-01-19'),
(20,'Vania Cossa','utilizador20@example.com','DEMO_NAO_E_HASH_20','Proprietario','Ativo','2026-01-20');

-- 20 clientes
INSERT INTO Cliente (nome_completo,telefone,email,data_registo,estado) VALUES
('Amelia Paulo','258850000001','cliente1@example.com','2026-02-01','Ativo'),
('Beatriz Ernesto','258850000002','cliente2@example.com','2026-02-02','Ativo'),
('Carla Alberto','258850000003','cliente3@example.com','2026-02-03','Ativo'),
('Dercia Manuel','258850000004','cliente4@example.com','2026-02-04','Ativo'),
('Ermelinda Jose','258850000005','cliente5@example.com','2026-02-05','Ativo'),
('Filomena Saide','258850000006','cliente6@example.com','2026-02-06','Ativo'),
('Gloria Tomas','258850000007','cliente7@example.com','2026-02-07','Ativo'),
('Hortencia Armando','258850000008','cliente8@example.com','2026-02-08','Ativo'),
('Isabel Joaquim','258850000009','cliente9@example.com','2026-02-09','Ativo'),
('Jacinta Alberto','258850000010','cliente10@example.com','2026-02-10','Ativo'),
('Lurdes Mateus','258850000011','cliente11@example.com','2026-02-11','Ativo'),
('Madalena Paulo','258850000012','cliente12@example.com','2026-02-12','Ativo'),
('Nelia Ernesto','258850000013','cliente13@example.com','2026-02-13','Ativo'),
('Olivia Manuel','258850000014','cliente14@example.com','2026-02-14','Ativo'),
('Palmira Jose','258850000015','cliente15@example.com','2026-02-15','Ativo'),
('Rute Saide','258850000016','cliente16@example.com','2026-02-16','Ativo'),
('Sandra Tomas','258850000017','cliente17@example.com','2026-02-17','Ativo'),
('Tania Armando','258850000018','cliente18@example.com','2026-02-18','Ativo'),
('Ursula Joaquim','258850000019','cliente19@example.com','2026-02-19','Ativo'),
('Zelia Mateus','258850000020','cliente20@example.com','2026-02-20','Ativo');

-- 20 funcionarios
INSERT INTO Funcionario (id_salao,nome_completo,telefone,especialidade,data_admissao,estado) VALUES
(1,'Alina Cossa','258860000001','Trancas','2025-01-10','Ativo'),
(2,'Bruna Mussa','258860000002','Manicure','2025-01-11','Ativo'),
(3,'Celia Sitoe','258860000003','Pedicure','2025-01-12','Ativo'),
(4,'Doris Bila','258860000004','Corte de cabelo','2025-01-13','Ativo'),
(5,'Ema Paulo','258860000005','Tratamento capilar','2025-01-14','Ativo'),
(6,'Fina Ernesto','258860000006','Trancas','2025-01-15','Ativo'),
(7,'Gina Alberto','258860000007','Manicure','2025-01-16','Ativo'),
(8,'Hilda Manuel','258860000008','Pedicure','2025-01-17','Ativo'),
(9,'Irma Jose','258860000009','Corte de cabelo','2025-01-18','Ativo'),
(10,'Julia Saide','258860000010','Tratamento capilar','2025-01-19','Ativo'),
(11,'Laila Tomas','258860000011','Trancas','2025-01-20','Ativo'),
(12,'Mena Armando','258860000012','Manicure','2025-01-21','Ativo'),
(13,'Nina Joaquim','258860000013','Pedicure','2025-01-22','Ativo'),
(14,'Olga Mateus','258860000014','Corte de cabelo','2025-01-23','Ativo'),
(15,'Pia Paulo','258860000015','Tratamento capilar','2025-01-24','Ativo'),
(16,'Rita Ernesto','258860000016','Trancas','2025-01-25','Ativo'),
(17,'Sonia Alberto','258860000017','Manicure','2025-01-26','Ativo'),
(18,'Tina Manuel','258860000018','Pedicure','2025-01-27','Ativo'),
(19,'Vera Jose','258860000019','Corte de cabelo','2025-01-28','Ativo'),
(20,'Yara Saide','258860000020','Tratamento capilar','2025-01-29','Ativo');

-- 20 procedimentos
INSERT INTO Procedimento (id_salao,nome,descricao,preco,duracao_minutos,estado) VALUES
(1,'Trancas simples','Trancas tradicionais',800.00,120,'Disponivel'),
(2,'Manicure','Tratamento das unhas das maos',350.00,45,'Disponivel'),
(3,'Pedicure','Tratamento das unhas dos pes',400.00,50,'Disponivel'),
(4,'Corte feminino','Corte e acabamento',500.00,40,'Disponivel'),
(5,'Hidratacao capilar','Hidratacao profunda',650.00,60,'Disponivel'),
(6,'Trancas africanas','Trancas africanas',1200.00,180,'Disponivel'),
(7,'Unhas em gel','Aplicacao de gel',900.00,75,'Disponivel'),
(8,'Pintura de cabelo','Coloracao capilar',1500.00,120,'Disponivel'),
(9,'Escova','Escova e finalizacao',450.00,40,'Disponivel'),
(10,'Pedicure spa','Pedicure com hidratacao',700.00,60,'Disponivel'),
(11,'Corte masculino','Corte tradicional',250.00,25,'Disponivel'),
(12,'Maquilhagem','Maquilhagem social',1000.00,60,'Disponivel'),
(13,'Alisamento','Alisamento capilar',1800.00,150,'Disponivel'),
(14,'Penteado de festa','Penteado para ocasiao especial',1300.00,90,'Disponivel'),
(15,'Limpeza facial','Limpeza basica do rosto',850.00,55,'Disponivel'),
(16,'Aplicacao de peruca','Instalacao e ajuste',600.00,45,'Disponivel'),
(17,'Tratamento antiqueda','Tratamento capilar',1100.00,70,'Disponivel'),
(18,'Design de sobrancelhas','Modelagem de sobrancelhas',250.00,20,'Disponivel'),
(19,'Unhas acrilicas','Aplicacao de unhas acrilicas',1000.00,90,'Disponivel'),
(20,'Lavagem e secagem','Lavagem e secagem de cabelo',300.00,30,'Disponivel');

-- 20 marcacoes. Cada marcacao referencia um cliente, salao, procedimento e funcionario.
INSERT INTO Marcacao (id_salao,id_cliente,id_procedimento,id_funcionario,data_hora,estado,observacao,data_criacao) VALUES
(1,1,1,1,'2026-11-01 09:00:00','Confirmada','Cliente confirmou','2026-10-20 09:00:00'),
(2,2,2,2,'2026-11-01 09:30:00','Pendente','Aguardar confirmacao','2026-10-20 09:05:00'),
(3,3,3,3,'2026-11-01 10:00:00','Concluida','Servico concluido','2026-10-20 09:10:00'),
(4,4,4,4,'2026-11-02 10:00:00','Confirmada','Corte feminino','2026-10-20 09:15:00'),
(5,5,5,5,'2026-11-02 11:00:00','Pendente','Primeira visita','2026-10-20 09:20:00'),
(6,6,6,6,'2026-11-03 09:00:00','Cancelada','Cliente cancelou','2026-10-20 09:25:00'),
(7,7,7,7,'2026-11-03 10:00:00','Confirmada','Unhas em gel','2026-10-20 09:30:00'),
(8,8,8,8,'2026-11-03 11:00:00','Em atendimento','Coloracao','2026-10-20 09:35:00'),
(9,9,9,9,'2026-11-04 09:00:00','Pendente','Aguardar confirmacao','2026-10-20 09:40:00'),
(10,10,10,10,'2026-11-04 10:00:00','Confirmada','Pedicure spa','2026-10-20 09:45:00'),
(11,11,11,11,'2026-11-05 09:00:00','Concluida','Corte realizado','2026-10-20 09:50:00'),
(12,12,12,12,'2026-11-05 10:00:00','Confirmada','Maquilhagem social','2026-10-20 09:55:00'),
(13,13,13,13,'2026-11-06 09:00:00','Nao compareceu','Cliente nao compareceu','2026-10-20 10:00:00'),
(14,14,14,14,'2026-11-06 10:00:00','Pendente','Penteado de festa','2026-10-20 10:05:00'),
(15,15,15,15,'2026-11-07 09:00:00','Confirmada','Limpeza facial','2026-10-20 10:10:00'),
(16,16,16,16,'2026-11-07 10:00:00','Pendente','Aplicacao de peruca','2026-10-20 10:15:00'),
(17,17,17,17,'2026-11-08 09:00:00','Confirmada','Tratamento capilar','2026-10-20 10:20:00'),
(18,18,18,18,'2026-11-08 10:00:00','Concluida','Sobrancelhas feitas','2026-10-20 10:25:00'),
(19,19,19,19,'2026-11-09 09:00:00','Confirmada','Unhas acrilicas','2026-10-20 10:30:00'),
(20,20,20,20,'2026-11-09 10:00:00','Pendente','Lavagem e secagem','2026-10-20 10:35:00');

-- 20 registos de historico, um para cada marcacao
INSERT INTO HistoricoMarcacao (id_marcacao,estado_anterior,estado_novo,data_alteracao,observacao) VALUES
(1,'Pendente','Confirmada','2026-10-20 09:00:00','Confirmacao inicial'),
(2,NULL,'Pendente','2026-10-20 09:05:00','Marcacao criada'),
(3,'Confirmada','Concluida','2026-10-20 09:10:00','Servico concluido'),
(4,NULL,'Confirmada','2026-10-20 09:15:00','Marcacao criada e confirmada'),
(5,NULL,'Pendente','2026-10-20 09:20:00','Marcacao criada'),
(6,'Confirmada','Cancelada','2026-10-20 09:25:00','Cancelamento solicitado'),
(7,NULL,'Confirmada','2026-10-20 09:30:00','Marcacao criada e confirmada'),
(8,'Confirmada','Em atendimento','2026-10-20 09:35:00','Atendimento iniciado'),
(9,NULL,'Pendente','2026-10-20 09:40:00','Marcacao criada'),
(10,NULL,'Confirmada','2026-10-20 09:45:00','Marcacao criada e confirmada'),
(11,'Em atendimento','Concluida','2026-10-20 09:50:00','Servico concluido'),
(12,NULL,'Confirmada','2026-10-20 09:55:00','Marcacao criada e confirmada'),
(13,'Confirmada','Nao compareceu','2026-10-20 10:00:00','Cliente ausente'),
(14,NULL,'Pendente','2026-10-20 10:05:00','Marcacao criada'),
(15,NULL,'Confirmada','2026-10-20 10:10:00','Marcacao criada e confirmada'),
(16,NULL,'Pendente','2026-10-20 10:15:00','Marcacao criada'),
(17,NULL,'Confirmada','2026-10-20 10:20:00','Marcacao criada e confirmada'),
(18,'Em atendimento','Concluida','2026-10-20 10:25:00','Servico concluido'),
(19,NULL,'Confirmada','2026-10-20 10:30:00','Marcacao criada e confirmada'),
(20,NULL,'Pendente','2026-10-20 10:35:00','Marcacao criada');

-- 20 produtos
INSERT INTO Produto (id_salao,nome,categoria,quantidade,stock_minimo,preco_unitario,estado) VALUES
(1,'Champu hidratante','Cabelo',12,3,250.00,'Disponivel'),
(2,'Condicionador','Cabelo',8,3,280.00,'Disponivel'),
(3,'Creme de pentear','Cabelo',15,4,300.00,'Disponivel'),
(4,'Gel fixador','Cabelo',6,2,220.00,'Disponivel'),
(5,'Esmalte vermelho','Unhas',20,5,90.00,'Disponivel'),
(6,'Acetona','Unhas',10,3,120.00,'Disponivel'),
(7,'Algodao','Higiene',18,5,80.00,'Disponivel'),
(8,'Luvas descartaveis','Higiene',25,8,15.00,'Disponivel'),
(9,'Tinta preta','Coloracao',7,2,350.00,'Disponivel'),
(10,'Agua oxigenada','Coloracao',9,3,180.00,'Disponivel'),
(11,'Oleo capilar','Cabelo',11,3,200.00,'Disponivel'),
(12,'Spray finalizador','Cabelo',5,2,320.00,'Disponivel'),
(13,'Lima de unhas','Unhas',30,10,25.00,'Disponivel'),
(14,'Removedor de verniz','Unhas',8,3,110.00,'Disponivel'),
(15,'Mascara facial','Pele',6,2,400.00,'Disponivel'),
(16,'Creme hidratante','Pele',10,3,270.00,'Disponivel'),
(17,'Touca descartavel','Higiene',40,10,10.00,'Disponivel'),
(18,'Pente profissional','Acessorios',14,4,100.00,'Disponivel'),
(19,'Escova de cabelo','Acessorios',4,2,180.00,'Disponivel'),
(20,'Fios para trancas','Acessorios',16,5,150.00,'Disponivel');

-- 20 movimentos de stock
INSERT INTO MovimentoStock (id_produto,tipo,quantidade,data_movimento,motivo) VALUES
(1,'Entrada',10,'2026-10-01 08:00:00','Compra ao fornecedor'),
(2,'Entrada',8,'2026-10-01 08:10:00','Reposicao de stock'),
(3,'Saida',2,'2026-10-02 09:00:00','Utilizado em atendimento'),
(4,'Entrada',6,'2026-10-02 09:10:00','Compra ao fornecedor'),
(5,'Saida',3,'2026-10-03 10:00:00','Utilizado em manicure'),
(6,'Entrada',10,'2026-10-03 10:10:00','Reposicao de stock'),
(7,'Saida',4,'2026-10-04 11:00:00','Uso diario'),
(8,'Entrada',25,'2026-10-04 11:10:00','Compra de consumiveis'),
(9,'Entrada',7,'2026-10-05 12:00:00','Compra de tinta'),
(10,'Saida',2,'2026-10-05 12:10:00','Utilizado em coloracao'),
(11,'Entrada',11,'2026-10-06 13:00:00','Compra ao fornecedor'),
(12,'Saida',1,'2026-10-06 13:10:00','Utilizado em penteado'),
(13,'Entrada',30,'2026-10-07 14:00:00','Compra de acessorios'),
(14,'Saida',2,'2026-10-07 14:10:00','Uso no servico de unhas'),
(15,'Entrada',6,'2026-10-08 15:00:00','Reposicao de produtos'),
(16,'Saida',2,'2026-10-08 15:10:00','Venda ao cliente'),
(17,'Entrada',40,'2026-10-09 16:00:00','Compra de consumiveis'),
(18,'Saida',3,'2026-10-09 16:10:00','Venda de acessorios'),
(19,'Entrada',4,'2026-10-10 17:00:00','Reposicao de escovas'),
(20,'Saida',2,'2026-10-10 17:10:00','Utilizado em trancas');

-- 20 horarios (um por funcionario)
INSERT INTO HorarioFuncionario (id_funcionario,dia_semana,hora_inicio,hora_fim,tipo_dia,observacao) VALUES
(1,'Segunda','08:00:00','17:00:00','Trabalho','Horario regular'),
(2,'Terca','08:00:00','17:00:00','Trabalho','Horario regular'),
(3,'Quarta','08:00:00','17:00:00','Trabalho','Horario regular'),
(4,'Quinta','08:00:00','17:00:00','Trabalho','Horario regular'),
(5,'Sexta','08:00:00','17:00:00','Trabalho','Horario regular'),
(6,'Sabado','08:00:00','14:00:00','Trabalho','Horario reduzido'),
(7,'Segunda','09:00:00','18:00:00','Trabalho','Horario regular'),
(8,'Terca','09:00:00','18:00:00','Trabalho','Horario regular'),
(9,'Quarta','09:00:00','18:00:00','Trabalho','Horario regular'),
(10,'Quinta','09:00:00','18:00:00','Trabalho','Horario regular'),
(11,'Sexta','09:00:00','18:00:00','Trabalho','Horario regular'),
(12,'Sabado',NULL,NULL,'Folga','Dia de descanso'),
(13,'Domingo',NULL,NULL,'Folga','Dia de descanso'),
(14,'Segunda','08:30:00','17:30:00','Trabalho','Horario regular'),
(15,'Terca','08:30:00','17:30:00','Trabalho','Horario regular'),
(16,'Quarta','08:30:00','17:30:00','Trabalho','Horario regular'),
(17,'Quinta','08:30:00','17:30:00','Trabalho','Horario regular'),
(18,'Sexta','08:30:00','17:30:00','Trabalho','Horario regular'),
(19,'Sabado','08:00:00','13:00:00','Trabalho','Horario reduzido'),
(20,'Domingo',NULL,NULL,'Folga','Dia de descanso');

-- 20 atendimentos: alguns associados a marcacoes e outros sem marcacao.
INSERT INTO Atendimento (id_salao,id_cliente,id_funcionario,id_procedimento,id_marcacao,data_hora,tipo,valor_pago,observacao) VALUES
(1,1,1,1,1,'2026-10-01 09:00:00','Com marcacao',800.00,'Atendimento concluido'),
(2,2,2,2,2,'2026-10-01 09:30:00','Com marcacao',350.00,'Atendimento concluido'),
(3,3,3,3,3,'2026-10-02 10:00:00','Com marcacao',400.00,'Atendimento concluido'),
(4,4,4,4,4,'2026-10-02 10:30:00','Com marcacao',500.00,'Atendimento concluido'),
(5,5,5,5,5,'2026-10-03 11:00:00','Com marcacao',650.00,'Atendimento concluido'),
(6,6,6,6,6,'2026-10-03 11:30:00','Com marcacao',1200.00,'Atendimento concluido'),
(7,7,7,7,7,'2026-10-04 12:00:00','Com marcacao',900.00,'Atendimento concluido'),
(8,8,8,8,8,'2026-10-04 12:30:00','Com marcacao',1500.00,'Atendimento concluido'),
(9,9,9,9,9,'2026-10-05 13:00:00','Com marcacao',450.00,'Atendimento concluido'),
(10,10,10,10,10,'2026-10-05 13:30:00','Com marcacao',700.00,'Atendimento concluido'),
(11,11,11,11,11,'2026-10-06 14:00:00','Com marcacao',250.00,'Atendimento concluido'),
(12,12,12,12,12,'2026-10-06 14:30:00','Com marcacao',1000.00,'Atendimento concluido'),
(13,13,13,13,13,'2026-10-07 15:00:00','Com marcacao',1800.00,'Atendimento concluido'),
(14,14,14,14,14,'2026-10-07 15:30:00','Com marcacao',1300.00,'Atendimento concluido'),
(15,15,15,15,15,'2026-10-08 16:00:00','Com marcacao',850.00,'Atendimento concluido'),
(16,16,16,16,NULL,'2026-10-08 16:30:00','Sem marcacao',600.00,'Cliente atendido sem reserva'),
(17,17,17,17,NULL,'2026-10-09 09:00:00','Sem marcacao',1100.00,'Cliente atendido sem reserva'),
(18,18,18,18,NULL,'2026-10-09 09:30:00','Sem marcacao',250.00,'Cliente atendido sem reserva'),
(19,19,19,19,NULL,'2026-10-10 10:00:00','Sem marcacao',1000.00,'Cliente atendido sem reserva'),
(20,20,20,20,NULL,'2026-10-10 10:30:00','Sem marcacao',300.00,'Cliente atendido sem reserva');

-- Verificacao: deve mostrar 20 registos em cada tabela.
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
