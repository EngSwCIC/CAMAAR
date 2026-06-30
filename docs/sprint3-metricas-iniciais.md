# Sprint 3 — Métricas iniciais (baseline antes da refatoração)

Responsável: Yuri Santana Lopes — Infraestrutura das ferramentas e métricas iniciais.
Branch: `sprint-3-infra-metricas-inciais-camaar`.

Este documento registra o estado do código **antes** da refatoração da Sprint 3,
para servir de comparação depois e alimentar a Wiki.

## Ferramentas instaladas (grupo `:metrics` no Gemfile)

| Gem | Versão | Uso |
|---|---|---|
| `simplecov` | 0.22.0 | Cobertura de testes (RSpec + Cucumber, mesclada) |
| `rubycritic` | 5.0.0 | Relatório agregado de qualidade (Reek + Flay + Flog), nota por arquivo |
| `rdoc` | 7.2.0 | Documentação a partir de comentários do código |
| RuboCop (já no projeto) | 1.86.2 | `Metrics/CyclomaticComplexity` e `Metrics/AbcSize` via config dedicada |

## Como reproduzir estes resultados

```bash
# Cobertura (gera coverage/index.html mesclado RSpec+Cucumber)
bin/rails db:test:prepare
bundle exec rspec
bundle exec cucumber

# Relatório de qualidade por arquivo
bundle exec rubycritic app lib --no-browser -f console -f json

# Complexidade ciclomática e ABC score reais (config isolada, não afeta o lint de estilo)
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity \
  app lib --format simple

# Documentação
bundle exec rdoc app lib --output doc
```

## 1. Métodos com complexidade ciclomática (McCabe) >= 10

| Método | CC | Local |
|---|---:|---|
| `RespostasController#create` | 15 | `app/controllers/respostas_controller.rb:4` |
| `TurmaFormulariosController#create` | 11 | `app/controllers/turma_formularios_controller.rb:4` |

## 2. Métodos com ABC Score >= 20

| Método | ABC | Local |
|---|---:|---|
| `RespostasController#create` | 45.71 | `app/controllers/respostas_controller.rb:4` |
| `SenhaController#salvar` | 39.65 | `app/controllers/senha_controller.rb:51` |
| `SenhaController#atualizar` | 33.97 | `app/controllers/senha_controller.rb:8` |
| `Formulario#mensagem_criacao_personalizada` | 31.80 | `app/models/formulario.rb:32` |
| `LimparDadosService#call` | 29.44 | `app/services/limpar_dados_service.rb:2` |
| `GerenciamentoController#importar` | 28.11 | `app/controllers/gerenciamento_controller.rb:8` |
| `TurmaFormulariosController#create` | 23.17 | `app/controllers/turma_formularios_controller.rb:4` |

`RespostasController#create` e `TurmaFormulariosController#create` aparecem nas duas listas — são os
candidatos mais claros para extrair métodos/objetos auxiliares na refatoração.

## 3. Cobertura de testes atual

- **Geral (RSpec + Cucumber mesclado): 81.02%** (508 / 627 linhas relevantes)
- RSpec isolado: 45.71% (325 / 711) — Cucumber cobre boa parte dos controllers que o RSpec não cobre.
- Suítes hoje: 85 exemplos RSpec + 117 cenários / 908 steps Cucumber, **todos passando**.

### Arquivos com cobertura mais baixa (atenção)

| Arquivo | Cobertura | Linhas cobertas |
|---|---:|---|
| `app/controllers/sessions_controller.rb` | 0% | 0/27 |
| `app/services/limpar_dados_service.rb` | 0% | 0/30 |
| `app/models/resposta_pergunta.rb` | 0% | 0/4 |
| `app/controllers/template_formularios_controller.rb` | 44.4% | 24/54 |
| `app/services/email_logger.rb` | 52.9% | 27/51 |
| `app/services/importar_dados_service.rb` | 64.2% | 77/120 |
| `app/controllers/formularios_controller.rb` | 64.7% | 11/17 |
| `app/controllers/senha_controller.rb` | 76.8% | 43/56 |
| `app/controllers/turma_formularios_controller.rb` | 77.3% | 17/22 |
| `app/controllers/respostas_controller.rb` | 80.0% | 20/25 |

(`application_job.rb` e `application_mailer.rb` também aparecem em 0%, mas são boilerplate do Rails
sem lógica própria — baixa prioridade.)

## 4. RubyCritic — nota geral e piores arquivos

**Nota geral do projeto: 91.39 / 100.**

| Arquivo | Nota | Cost | Complexidade | Duplicação | Nº smells |
|---|---|---:|---:|---:|---:|
| `app/controllers/senha_controller.rb` | C | 6.92 | 122.99 | 72 | 19 |
| `app/services/importar_dados_service.rb` | C | 6.04 | 126.08 | 34 | 30 |
| `app/models/pergunta_formulario.rb` | B | 4.00 | 0.0 | 25 | 2 |
| `app/models/pergunta.rb` | B | 4.00 | 0.0 | 25 | 2 |
| `app/controllers/login_controller.rb` | B | 3.33 | 33.23 | 29 | 2 |
| `app/controllers/gerenciamento_controller.rb` | B | 3.33 | 83.22 | 0 | 8 |
| `app/controllers/sessions_controller.rb` | B | 3.18 | 29.58 | 29 | 2 |
| `app/models/formulario.rb` | B | 2.69 | 67.15 | 0 | 8 |
| `app/controllers/relatorios_controller.rb` | B | 2.55 | 63.78 | 0 | 5 |
| `app/controllers/respostas_controller.rb` | B | 2.07 | 51.80 | 0 | 8 |
| `app/controllers/turma_formularios_controller.rb` | B | 2.07 | 51.71 | 0 | 6 |

Todos os demais arquivos (a maioria dos models, helpers e o restante dos controllers) receberam nota **A**.

Métodos com smell `HighComplexity` (flog score do Reek/Flog):

- `RespostasController#create` — flog 52
- `SenhaController#atualizar` — flog 45
- `SenhaController#salvar` — flog 45
- `LimparDadosService#call` — flog 42
- `Formulario#mensagem_criacao_personalizada` — flog 40
- `GerenciamentoController#importar` — flog 38
- `TurmaFormulariosController#create` — flog 28

`ImportarDadosService` é o arquivo com mais smells (30), mas sem nenhum método isolado acima do
limiar — o problema é distribuído: duplicação de código, `FeatureEnvy` em 5 métodos,
`TooManyStatements` em 6 métodos, `RepeatedConditional` e `TooManyInstanceVariables`. É um forte
candidato a ser dividido em objetos menores (ex.: extrair a lógica de upsert de usuário/turma/matéria).

## 5. Documentação (RDoc)

**7,06% documentado** (79 de 85 itens sem documentação): 34 classes, 4 módulos e 40 métodos sem
comentário. Nenhuma classe em `app/models` ou `app/services` tem comentário descritivo — RubyCritic
também aponta o smell `IrresponsibleModule` para `ImportarDadosService` e `SenhaController`.

## 6. Resumo — arquivos/métodos prioritários para a refatoração

1. **`app/services/importar_dados_service.rb`** — pior nota RubyCritic (C), mais smells (30),
   64.2% de cobertura, 0% documentado.
2. **`app/controllers/senha_controller.rb`** — nota C, 2 métodos com ABC alto, maior duplicação (72).
3. **`app/controllers/respostas_controller.rb#create`** — maior CC (15) e maior ABC (45.71) do projeto.
4. **`app/controllers/turma_formularios_controller.rb#create`** — único outro método com CC >= 10.
5. **`app/services/limpar_dados_service.rb`** — 0% de cobertura, ABC 29.44.
6. **`app/controllers/sessions_controller.rb`** — 0% de cobertura (27 linhas relevantes).

### Observação à parte (fora do escopo desta tarefa)

O job `test` do CI (`.github/workflows/ci.yml`) roda `bin/rails test`, que executa os arquivos em
`test/` (stubs do Minitest gerados pelo `rails generate`, aparentemente não mantidos). RSpec e
Cucumber — a suíte real do projeto — não são executados automaticamente no CI.