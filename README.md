# CAMAAR

Sistema web para **gestão de avaliações institucionais** da UnB — permite criar formulários, distribuí-los a turmas importadas do SIGAA e gerar relatórios de respostas por disciplina.

> Trabalho final da disciplina de Engenharia de Software · Grupo 7 · 2025/1

---

## Início rápido

**Pré-requisitos:** Ruby 3.2.10, Bundler, SQLite3.

```bash
git clone https://github.com/yuri-sl/CAMAAR.git
cd CAMAAR
bundle install
bin/rails db:prepare       # cria o banco, executa migrations e o seed inicial
bin/rails server
```

Acesse em **http://localhost:3000**.

> **Windows:** substitua `bin/rails` por `ruby bin\rails` caso obtenha erro `No such file or directory`. Se o servidor travar na inicialização, comente `plugin :tmp_restart` em `config/puma.rb`.

---

## Acesso padrão

O seed cria automaticamente um administrador:

| Campo | Valor |
|---|---|
| E-mail | `admin@unb.br` |
| Senha | `Admin123` |

---

## Funcionalidades

| Papel | O que pode fazer |
|---|---|
| **Admin** | Importar dados do SIGAA (JSON), criar templates de formulário, enviar formulários às turmas do seu departamento, visualizar relatórios e exportar CSV |
| **Professor** | Visualizar relatórios das turmas onde leciona |
| **Estudante** | Responder os formulários abertos das suas turmas |

---

## Stack

- Ruby 3.2.10 · Rails 8.1.3 · SQLite3
- Testes: RSpec + Cucumber (BDD) + SimpleCov
- Qualidade: RuboCritic · RuboCop · RDoc

---

## Testes

```bash
bin/rails db:test:prepare

# Testes unitários e de requisição
bundle exec rspec

# Testes de comportamento (BDD)
bundle exec cucumber
```

---

## Métricas de qualidade (Sprint 3)

```bash
# Complexidade ciclomática e ABC Score por método
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize app lib --format simple

# Relatório agregado (smells, duplicação, nota por arquivo)
bundle exec rubycritic app lib --no-browser

# Documentação
bundle exec rdoc app lib --output doc
```

---

## Importação de dados do SIGAA

O sistema aceita dois arquivos JSON exportados do SIGAA:

- **classes.json** — metadados das disciplinas (código, turma, semestre, docente)
- **class\_members.json** — discentes por turma

Faça o upload em **Gerenciamento → Importar dados**.

---

## Estrutura relevante

```
app/
  controllers/   rotas e lógica HTTP
  models/        regras de negócio e validações
  services/      ImportarDadosService, LimparDadosService, EmailLogger
  views/         templates ERB
spec/            testes RSpec (request specs e model specs)
features/        cenários Cucumber (BDD)
docs/            wiki e métricas da Sprint 3
```
