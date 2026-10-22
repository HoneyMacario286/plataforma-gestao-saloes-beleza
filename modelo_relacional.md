# Modelo Relacional — Plataforma de Gestão de Salões de Beleza

Convenções: **negrito** identifica a chave primária (PK); `FK → Tabela.coluna` identifica uma chave estrangeira; `UNIQUE` indica valor único.

- **Salao**(**id_salao**, nome, provincia, cidade, bairro, telefone, email [UNIQUE], endereco, hora_abertura, hora_fecho, estado)
- **Utilizador**(**id_utilizador**, id_salao [FK → Salao.id_salao], nome_completo, email [UNIQUE], palavra_passe_hash, perfil, estado, data_criacao)
- **Cliente**(**id_cliente**, nome_completo, telefone, email [UNIQUE, opcional], data_registo, estado)
- **Funcionario**(**id_funcionario**, id_salao [FK → Salao.id_salao], nome_completo, telefone, especialidade, data_admissao, estado)
- **Procedimento**(**id_procedimento**, id_salao [FK → Salao.id_salao], nome, descricao, preco, duracao_minutos, estado)
- **Marcacao**(**id_marcacao**, id_salao [FK → Salao.id_salao], id_cliente [FK → Cliente.id_cliente], id_procedimento [FK → Procedimento.id_procedimento], id_funcionario [FK → Funcionario.id_funcionario], data_hora, estado, observacao, data_criacao)
- **HistoricoMarcacao**(**id_historico**, id_marcacao [FK → Marcacao.id_marcacao], estado_anterior, estado_novo, data_alteracao, observacao)
- **Produto**(**id_produto**, id_salao [FK → Salao.id_salao], nome, categoria, quantidade, stock_minimo, preco_unitario, estado)
- **MovimentoStock**(**id_movimento**, id_produto [FK → Produto.id_produto], tipo, quantidade, data_movimento, motivo)
- **HorarioFuncionario**(**id_horario**, id_funcionario [FK → Funcionario.id_funcionario], dia_semana, hora_inicio, hora_fim, tipo_dia, observacao)
- **Atendimento**(**id_atendimento**, id_salao [FK → Salao.id_salao], id_cliente [FK → Cliente.id_cliente], id_funcionario [FK → Funcionario.id_funcionario], id_procedimento [FK → Procedimento.id_procedimento], id_marcacao [FK → Marcacao.id_marcacao, opcional], data_hora, tipo, valor_pago, observacao)

## Cardinalidades principais
- Salao 1:N Utilizador
- Salao 1:N Funcionario
- Salao 1:N Procedimento
- Salao 1:N Produto
- Salao 1:N Marcacao
- Salao 1:N Atendimento
- Cliente 1:N Marcacao
- Cliente 1:N Atendimento
- Funcionario 1:N Marcacao
- Funcionario 1:N Atendimento
- Funcionario 1:N HorarioFuncionario
- Procedimento 1:N Marcacao
- Procedimento 1:N Atendimento
- Marcacao 1:N HistoricoMarcacao
- Produto 1:N MovimentoStock
- Marcacao 1:N Atendimento, com a nota de que `Atendimento.id_marcacao` é opcional. Como essa FK não tem uma restrição `UNIQUE`, o esquema permite vários atendimentos associados à mesma marcação. Se o negócio exigir no máximo um atendimento por marcação, essa regra deve ser imposta na base de dados e/ou validada pela aplicação.

## Nota de conceção
A base de dados é centralizada: todos os salões usam as mesmas tabelas. Os registos administrativos e operacionais incluem `id_salao` para identificar o salão a que pertencem. A aplicação web futura deve validar permissões para impedir que um utilizador de um salão consulte ou altere dados de outro salão.
