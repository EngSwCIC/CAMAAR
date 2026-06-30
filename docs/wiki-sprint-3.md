# Sprint 3 - Refatoracao, metricas e documentacao

## Objetivo da sprint

A Sprint 3 teve como foco melhorar a qualidade interna do codigo do CAMAAR por
meio de refatoracao, documentacao e acompanhamento de metricas. O objetivo foi
reduzir complexidade dos metodos, melhorar a cobertura de testes, manter os
cenarios BDD existentes funcionando e registrar os resultados antes e depois das
alteracoes.

As atividades foram organizadas em cinco frentes:

| Frente             | Responsabilidade | Situacao |
|--------------------|---|---|
| Yuri               | Infraestrutura das ferramentas e metricas iniciais | Concluido |
| João Victor Romero | Refatoracao dos controllers | Concluido |
| João Felipe Stein  | Refatoracao dos models e regras de negocio | Concluido |
| Artur              | Testes, cobertura e happy/sad path | Concluido |
| Luidgi             | Wiki, documentacao final e revisao do PR | Concluido |

## Ferramentas usadas

| Ferramenta | Uso na sprint |
|---|---|
| SimpleCov | Medir cobertura de testes RSpec e Cucumber |
| RubyCritic | Gerar relatorio agregado de qualidade, duplicacao e smells |
| RuboCop Metrics | Medir complexidade ciclomatica e ABC Score por metodo |
| RDoc | Gerar documentacao a partir dos comentarios no codigo |

### Observacao sobre Saikuro e MetricFu

A especificacao inicial citava Saikuro/MetricFu para complexidade ciclomatica.
Durante a sprint foi identificado que essas ferramentas estao descontinuadas e
apresentaram problemas de compatibilidade. Por isso, usamos os cops de
metricas do RuboCop em uma configuracao isolada (`.rubocop_metrics.yml`) para
extrair os valores de complexidade ciclomatica e ABC Score sem alterar o lint
padrao do projeto.

## Comandos executados

### Metricas iniciais

```bash
bin/rails db:test:prepare
bundle exec rspec
bundle exec cucumber
bundle exec rubycritic app lib --no-browser -f console -f json
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity \
  app lib --format simple
bundle exec rdoc app lib --output doc
```

### Metricas finais

```bash
bin/rails db:test:prepare
bundle exec rspec
bundle exec cucumber
bundle exec rubycritic app lib --no-browser -f console -f json
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity \
  app lib --format simple
bundle exec rdoc app lib --output doc
```

## Resultados iniciais

Os resultados abaixo foram registrados antes das refatoracoes em
`docs/sprint3-metricas-iniciais.md`.

### Complexidade ciclomatica >= 10

| Metodo | Valor inicial | Arquivo |
|---|---:|---|
| `RespostasController#create` | 15 | `app/controllers/respostas_controller.rb` |
| `TurmaFormulariosController#create` | 11 | `app/controllers/turma_formularios_controller.rb` |
| `TurmaFormulariosController#destroy` | 10 | `app/controllers/turma_formularios_controller.rb` |

*Correcao: o relatorio inicial usava `Max: 10` no RuboCop, que so sinaliza valores
maiores que o Max (nao >=). O metodo `#destroy` com CC exatamente 10 so apareceu
ao reanalizar com `Max: 9`. O arquivo `.rubocop_metrics.yml` foi corrigido.*

### ABC Score >= 20

| Metodo | Valor inicial | Arquivo |
|---|---:|---|
| `RespostasController#create` | 45.71 | `app/controllers/respostas_controller.rb` |
| `SenhaController#salvar` | 39.65 | `app/controllers/senha_controller.rb` |
| `SenhaController#atualizar` | 33.97 | `app/controllers/senha_controller.rb` |
| `Formulario#mensagem_criacao_personalizada` | 31.80 | `app/models/formulario.rb` |
| `LimparDadosService#call` | 29.44 | `app/services/limpar_dados_service.rb` |
| `GerenciamentoController#importar` | 28.11 | `app/controllers/gerenciamento_controller.rb` |
| `TurmaFormulariosController#create` | 23.17 | `app/controllers/turma_formularios_controller.rb` |

### Cobertura inicial

| Metrica | Resultado inicial |
|---|---:|
| Cobertura geral mesclada (RSpec + Cucumber) | 81.02% |
| Linhas cobertas | 508 / 627 |
| RSpec isolado | 45.71% |
| Suite RSpec | 85 exemplos, 0 falhas |
| Suite Cucumber | 117 cenarios, 908 steps, 0 falhas |

### RubyCritic inicial

| Metrica | Resultado inicial |
|---|---:|
| Nota geral do projeto | 91.39 / 100 |
| Arquivo com pior nota | `app/controllers/senha_controller.rb` |
| Arquivo com mais smells | `app/services/importar_dados_service.rb` |
| Documentacao RDoc inicial | 7.06% |

## Comparacao antes/depois da refatoracao

| Item | Antes | Depois | Situacao |
|---|---:|---:|---|
| `RespostasController#create` - complexidade ciclomatica | 15 | **7** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#create` - complexidade ciclomatica | 11 | **3** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#destroy` - complexidade ciclomatica | 10 | **2** | Concluido (João Victor Romero) |
| `RespostasController#create` - ABC Score | 45.71 | **19.05** | Concluido (João Victor Romero) |
| `SenhaController#salvar` - ABC Score | 39.65 | **14.18** | Concluido (João Victor Romero) |
| `SenhaController#atualizar` - ABC Score | 33.97 | **17.92** | Concluido (João Victor Romero) |
| `Formulario#mensagem_criacao_personalizada` - ABC Score | 31.80 | **Extraido em 3 metodos (maximo < 20)** | Concluido (João Felipe Stein) |
| `LimparDadosService#call` - ABC Score | 29.44 | **Extraido em 3 metodos (maximo < 20)** | Concluido |
| `GerenciamentoController#importar` - ABC Score | 28.11 | **10.63** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#create` - ABC Score | 23.17 | **10.63** | Concluido (João Victor Romero) |
| Cobertura geral RSpec + Cucumber | 81.02% | **85.34%** | Concluido (Artur) |
| Nota geral RubyCritic | 91.39 / 100 | **90.98 / 100** | Concluido |
| Documentacao RDoc | 7.06% | **9.41%** | Concluido (`bundle exec rdoc app lib --output doc`) |

## Refatoracoes realizadas

| Arquivo/metodo | Problema inicial | Alteracao realizada                                                                                                                                                                                                              | Resultado final |
|---|---|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|
| `app/controllers/respostas_controller.rb#create` | CC 15 e ABC 45.71 | Extraido em `find_formulario`, `find_estudante`, `estudante_tem_permissao?`, `resposta_unica?`, `respostas_preenchidas?`; RDoc completo                                                                                          | CC 7 e ABC 19.05 |
| `app/controllers/turma_formularios_controller.rb` (`create` e `destroy`) | CC 11/10 e ABC 23.17/18.79 | Extraido em `find_turma_and_authorize`, `find_formulario_and_authorize`, `turma_pertence_ao_departamento?`, `turmas_do_departamento_ids`; RDoc completo                                                                          | `create`: CC 3 / ABC 10.63. `destroy`: CC 2 / ABC 6.4 |
| `app/controllers/senha_controller.rb` (`atualizar` e `salvar`) | ABC 33.97/39.65 e duplicacao da logica de erro | Extraido em `senha_antiga_correta?`, `senhas_iguais?`, `aplicar_nova_senha`, `find_usuario_by_token_or_redirect`, `password_present?`, `passwords_match?`, `new_password_different?`, `primeira_mensagem_de_erro`; RDoc completo | `atualizar`: ABC 17.92. `salvar`: ABC 14.18 |
| `app/models/formulario.rb` | ABC 31.80 em `mensagem_criacao_personalizada` | Extraido em `validar_ausencia_total`, `validar_campos_obrigatorios` e `formularios_duplicados`; RDoc adicionado em todos os metodos privados                                                                                     | Todos com ABC < 20 e CC < 10 |
| `app/services/limpar_dados_service.rb#call` | ABC 29.44 | Extraido em `limpar_registros`, `ids_a_preservar`, `remover_formularios_e_respostas`, `remover_turmas_e_matriculas`; RDoc adicionado                                                                                             | ABC 6.4 (call); todos os metodos < 20 |
| `app/controllers/gerenciamento_controller.rb#importar` | ABC 28.11 | Extraido em `arquivos_presentes?`, `redirecionar_arquivos_ausentes`, `processar_importacao`; RDoc completo                                                                                                                       | ABC 10.63 |
| `app/services/importar_dados_service.rb` | Maior numero de smells (30) | Nao refatorado — nenhum metodo viola CC >= 10 ou ABC >= 20. Os smells sao estruturais| Dentro dos limiares|

## Cobertura de testes

| Escopo | Cobertura inicial | Cobertura final | Status |
|---|---:|---:|---|
| Cobertura geral mesclada (RSpec + Cucumber) | 81.02% | **85.34%** (611/716 linhas) | Concluido |
| Controllers implementados pelo grupo | Variavel (0% a 100%) | **Todos >= 90%** | Meta atingida |
| Models implementados pelo grupo | Variavel (0% a 100%) | **Todos 100%** | Meta atingida |

#### Cobertura final por controller

| Controller | Cobertura |
|---|---:|
| `sessions_controller.rb` | **Removido** (codigo morto — model `User` nao existe no projeto) |
| `respostas_controller.rb` | 100% |
| `formularios_controller.rb` | 100% |
| `relatorios_controller.rb` | 100% |
| `usuarios_controller.rb` | 100% |
| `pages_controller.rb` | 100% |
| `turma_formularios_controller.rb` | 100% |
| `senha_controller.rb` | 100% |
| `template_formularios_controller.rb` | 96.8% |
| `departamentos_controller.rb` | 94.7% |
| `login_controller.rb` | 94.7% |
| `application_controller.rb` | 94.4% |
| `gerenciamento_controller.rb` | 93.0% |

#### Cobertura final por model

Todos os models do grupo atingiram 100%.
`resposta_pergunta.rb` foi marcado com `:nocov:` pois a tabela `resposta_perguntas`
ainda nao foi criada (feature planejada, sem migracao — fora do escopo desta sprint).

### Suites de teste

| Suite | Resultado inicial | Resultado final |
|---|---|---|
| RSpec | 85 exemplos, 0 falhas | **111 exemplos, 0 falhas** (+26 novos) |
| Cucumber | 117 cenarios, 908 steps, 0 falhas | **117 cenarios, 908 steps, 0 falhas** (sem alteracoes) |

### Achados durante a analise de cobertura (Artur — Pessoa 4)

- **`SessionsController` era codigo morto**: referenciava `User` (model inexistente) e suas rotas
  eram inacessiveis (mascaradas por rotas de `login#*` declaradas antes). O controller foi removido
  e as rotas mortas limpas de `config/routes.rb`; os helpers `login_path`/`logout_path` passaram a
  apontar para as rotas reais de `LoginController`.
- **`RespostaPergunta` sem tabela**: o model existe mas a migracao nunca foi executada.
  Marcado com `:nocov:` para nao distorcer os percentuais do grupo.
- **Filtros SimpleCov sincronizados** entre `spec/rails_helper.rb` (RSpec) e
  `features/support/00_simplecov.rb` (Cucumber), garantindo que arquivos excluidos sejam
  ignorados em ambas as medicoes antes da mesclagem.

## Happy path e sad path

As features Cucumber existentes nao devem ser alteradas apenas para acomodar a
refatoracao. A validacao final deve confirmar se os cenarios definidos continuam
passando e se os fluxos principais contem casos felizes e casos de erro.

| Area | Happy path | Sad path | Cobertura via |
|---|---|---|---|
| Cadastro de usuario | Sim | Sim (email duplicado, invalido, senha fraca, confirmacao diverge, sem nome) | RSpec (`usuarios_spec.rb`) |
| Login de usuario | Sim | Sim (credenciais erradas, email invalido, campos em branco) + logout | Cucumber (`login_usuario.feature`) + RSpec (`login_controller_spec.rb`) |
| Criacao de formulario | Sim | Sim (sem nome, sem template, sem turma, sem publico-alvo, nome duplicado) | Cucumber + RSpec (`criacao_formularios_publico_spec.rb`) |
| Templates de formulario | Sim | Sim (sem criador, pergunta radio invalida ao criar/editar) | RSpec (`template_formularios_spec.rb`) + Cucumber |
| Responder formulario | Sim | Sim (formulario inexistente, sem perfil estudante, sem matricula, ja respondeu, perguntas em branco, formulario privado) | RSpec (`respostas_spec.rb`) |
| Relatorios | Sim | Sim (formulario sem respostas, acesso negado ao estudante) | RSpec (`relatorios_spec.rb`) |
| Gerenciamento por departamento | Sim | Sim (turma de outro depto, formulario inexistente, sem admin, destroy de outro depto) | RSpec (`departamentos_spec.rb`) |
| Importacao/atualizacao SIGAA | Sim | Sim (JSON invalido, campos faltantes, sem arquivo, sem permissao) | Cucumber (`importar_dados_sigaa.feature`, `atualizar_base_dados_sigaa.feature`) |
| Redefinicao/definicao de senha | Sim | Sim (senha errada, campos diferentes, req minimos, igual atual, em branco, link expirado, sem email cadastrado) | Cucumber (`redefinir_senha.feature`) + RSpec (`senha_controller_spec.rb`) |

## Documentacao RDoc

Os metodos criados ou refatorados devem conter comentarios RDoc indicando:

- o que o metodo faz;
- quais argumentos recebe, quando houver;
- o que retorna;
- efeitos colaterais relevantes, como persistencia no banco, envio de email ou
  redirecionamento.

### Checklist RDoc

| Arquivo/metodo | Comentario RDoc conferido? | Observacao |
|---|---|---|
| `app/controllers/respostas_controller.rb` (find_formulario, find_estudante, estudante_tem_permissao?, resposta_unica?, respostas_preenchidas?) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/controllers/turma_formularios_controller.rb` (find_turma_and_authorize, find_formulario_and_authorize, turma_pertence_ao_departamento?, turmas_do_departamento_ids) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/controllers/senha_controller.rb` (senha_antiga_correta?, senhas_iguais?, aplicar_nova_senha, find_usuario_by_token_or_redirect, password_present?, passwords_match?, new_password_different?, primeira_mensagem_de_erro) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/models/formulario.rb` (validar_ausencia_total, validar_campos_obrigatorios, formularios_duplicados, turma_possui_matricula_ativa, vincular_perguntas_do_template) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/models/usuario.rb` (normalize_email, password_meets_complexity_requirements) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/services/limpar_dados_service.rb#call` (limpar_registros, ids_a_preservar, remover_formularios_e_respostas, remover_turmas_e_matriculas) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/controllers/gerenciamento_controller.rb` (arquivos_presentes?, redirecionar_arquivos_ausentes, processar_importacao) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/services/importar_dados_service.rb` | Nao aplicavel | Nenhum metodo foi criado ou refatorado nesta sprint — nenhum violava CC/ABC. Smells documentados como divida tecnica. |

## Checklist do PR final

- [x] Branch final da Sprint 3 atualizada com a base correta do projeto (PR para o repositorio principal pendente).
- [x] Refatoracoes dos controllers integradas (RespostasController, TurmaFormulariosController, SenhaController, GerenciamentoController).
- [x] Refatoracoes dos models integradas (Formulario, Usuario).
- [x] Complexidade ciclomatica final menor que 10 por metodo (todos os controllers, models e services refatorados).
- [x] ABC Score final menor que 20 por metodo (todos os controllers, models e `LimparDadosService` refatorados).
- [x] Cobertura dos controllers/models do grupo maior que 90% (todos >= 90%; maioria em 100%).
- [x] `bundle exec rspec` passando (111 exemplos, 0 falhas).
- [x] `bundle exec cucumber` passando (117 cenarios, 908 steps, 0 falhas).
- [x] Relatorio RubyCritic gerado (90.96 / 100).
- [x] RDoc gerado (`bundle exec rdoc app lib --output doc` — 9.41% documentado, publico).
- [x] Comentarios RDoc conferidos nos metodos criados/refatorados (controllers e models: ok).
- [x] Wiki atualizada com tabela antes/depois e cobertura final.
- [x] PR revisado para evitar alteracoes desnecessarias.

## Pendencias para fechar a Wiki

1. ~~Receber do João Victor Romero a lista final de controllers refatorados e integrar em sprint-3.~~ **Concluido.**
2. ~~Receber do João Felipe Stein a lista final de models refatorados.~~ **Concluido.**
3. ~~Receber do Artur os resultados finais de RSpec, Cucumber e SimpleCov.~~ **Concluido.** (111 RSpec + 117 Cucumber; todos os controllers/models do grupo >= 90%)
4. ~~Gerar `doc/`.~~ **Concluido** (9.41% documentado — metodos publicos refatorados cobertos).
5. ~~Abrir o PR da branch `sprint-3` para o repositorio principal e fazer a revisao final.~~ Feito
