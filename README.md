# Plataforma de Gestão de Salões de Beleza

**Disciplina:** Tecnologias de Base de Dados — 2.º ano, Licenciatura em Informática  
**Estudante:** [Escreva aqui o seu nome completo]  
**SGBD utilizado:** MySQL / MariaDB (phpMyAdmin e XAMPP)

## 1. Descrição do problema
A plataforma de Gestão de Salões de Beleza pretende organizar, numa única base de dados, a informação de vários salões. O sistema permite registar salões, utilizadores, clientes, funcionários, procedimentos, marcações, horários, atendimentos, produtos e movimentos de stock. O objectivo é facilitar a consulta de serviços e preços, a gestão de agendas e o controlo do stock. A base de dados poderá servir futuramente de suporte a uma aplicação web.

## 2. Regras de negócio
1. Cada salão possui um identificador próprio e dados de contacto.
2. Um salão pode ter vários funcionários, procedimentos e produtos.
3. Os utilizadores administrativos estão associados a um salão e possuem um perfil.
4. Cada marcação está associada a um cliente, salão, procedimento e funcionário.
5. O estado de uma marcação pode mudar ao longo do processo.
6. As alterações de estado podem ser registadas no histórico de marcações.
7. Cada movimento de stock está associado a um produto.
8. A quantidade em stock não deve ser negativa.
9. Um funcionário pode ter vários registos de horário, incluindo folgas e ausências.
10. Um atendimento pode estar associado a uma marcação ou ser registado sem marcação.
11. As chaves estrangeiras impedem referências a registos inexistentes.
12. Numa futura aplicação, as permissões devem limitar cada gestor aos dados do seu salão.
13. Os dados incluídos são fictícios e servem apenas para demonstração académica.

## 3. Sistema web previsto
A base de dados poderá suportar um sistema web no qual os clientes consultam salões, serviços e preços e solicitam marcações. Os gestores poderão administrar funcionários, horários, procedimentos, marcações e stock do respectivo salão. O desenvolvimento da aplicação web fica para o projecto de Programação Web.

## 4. Ficheiros entregues
- `diagrama_er.png` — diagrama Entidade-Relacionamento.
- `modelo_relacional.md` — tabelas, atributos e chaves primárias/estrangeiras.
- `01_criacao_e_insercao.sql` — criação da base de dados, tabelas, restrições e inserção de dados.
- `02_manipulacao.sql` — consultas SELECT, consultas JOIN, UPDATE, DELETE e teste de integridade referencial.
- `descricao_regras_negocio.md` — descrição do problema e regras de negócio.
- `diagrama_er.mmd` e `diagrama_er.svg` — versões editáveis/alternativas do diagrama.

## 5. Como executar
1. Abrir o MySQL Workbench ou phpMyAdmin e seleccionar o servidor MySQL/MariaDB.
2. Executar `01_criacao_e_insercao.sql` para criar a base de dados e preencher as tabelas.
3. Verificar as tabelas e a quantidade de registos.
4. Executar os comandos de `02_manipulacao.sql` individualmente, lendo os comentários antes de cada consulta.
5. O INSERT de teste com `id_salao = 9999` deve falhar intencionalmente devido à chave estrangeira; executá-lo isoladamente.

**Atenção:** o primeiro script recria a base de dados `plataforma_saloes` e pode substituir dados anteriores com o mesmo nome. Não o execute novamente no servidor onde já guarda dados importantes sem fazer uma cópia de segurança. O ficheiro de manipulação altera e elimina alguns registos de demonstração; para mostrar o estado inicial completo, execute primeiro o script de criação e inserção num ambiente de teste.

## 6. Vídeo de apresentação
**Link do vídeo (YouTube não listado):** [Adicionar o link após publicar o vídeo]

O vídeo deve ter entre 8 e 12 minutos, com voz e partilha de ecrã, e explicar o tema, concepção, diagrama ER, modelo relacional, criação da base de dados e execução dos comandos. Antes de executar cada comando, explicar o resultado esperado e depois compará-lo com o resultado obtido.
