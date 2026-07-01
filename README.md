# CAMAAR

**CAMAAR** (Sistema para Avaliação de Atividades Acadêmicas Remotas) é uma aplicação web desenvolvida para o **CIC (Departamento de Ciência da Computação)** que automatiza a criação, aplicação e análise de questionários de avaliação de disciplinas e turmas. O sistema substitui processos manuais de coleta de feedback acadêmico, integrando-se aos dados institucionais do **SIGAA** para gerenciar turmas, docentes e discentes.

Projeto desenvolvido como parte da disciplina de Engenharia de Software (forked de `EngSwCIC/CAMAAR`), ao longo de três sprints de desenvolvimento documentadas na [Wiki do repositório](https://github.com/GabLopes12/CAMAAR/wiki).

## Equipe

- Diego Guedes Gontijo
- Gabriel Lopes Soares Damasceno
- Luiz Felipe Ducat — *Product Owner*
- Rafael Dias Ghiorzi — *Scrum Master*

## Funcionalidades

### Importação e gestão de dados (SIGAA)
- Importação de turmas, departamentos, docentes e discentes a partir de arquivos do SIGAA
- Detecção e relatório de inconsistências durante a importação
- Provisionamento automático de contas de usuário, com notificação por e-mail
- Definição e recuperação de senha por token enviado por e-mail

### Templates e formulários
- Criação de templates de questionário reutilizáveis pelo administrador
- Geração de formulários de avaliação a partir de templates, distribuídos para turmas específicas
- Exclusão de templates sem afetar formulários já gerados a partir deles

### Respostas e submissões
- Listagem de formulários pendentes e respondidos para cada participante (docente/discente)
- Submissão de respostas a questionários pelos participantes das turmas
- Exportação dos resultados de um formulário em CSV para análise externa

### Autenticação e perfis
- Login por e-mail ou matrícula, com senha segura (`has_secure_password`)
- Controle de acesso por papel (administrador, docente, discente)
- Dashboard inicial com visão geral das atividades pendentes

## Tecnologias

| Categoria | Tecnologia |
|---|---|
| Linguagem / Framework | Ruby 3.4.9, Rails ~> 8.1 |
| Frontend | Hotwire (Turbo + Stimulus), Propshaft |
| Banco de dados | SQLite |
| Servidor de aplicação | Puma |
| Autenticação | bcrypt (`has_secure_password`) |
| Testes unitários/integração | RSpec, FactoryBot, SimpleCov |
| Testes BDD | Cucumber (Gherkin) |
| Qualidade de código | RuboCop, Brakeman, RubyCritic |
| Documentação | RDoc |
| Containerização | Docker |
| Deploy | Kamal |

## Como executar o projeto

A aplicação Rails está em [`project/`](project).

### Pré-requisitos
- Ruby 3.4.9
- Bundler

### Instalação local

```bash
cd project
bundle install
bin/rails db:setup
bin/rails server
```

A aplicação ficará disponível em `http://localhost:3000`.

### Via Docker

```bash
cd project
docker build -f Dockerfile.dev -t camaar-dev .
docker run -p 3000:3000 camaar-dev
```

### Executando os testes

```bash
cd project
bundle exec rspec        # testes unitários e de integração
bundle exec cucumber     # cenários BDD
```

## Histórico de desenvolvimento

O projeto foi construído em três sprints, documentadas na wiki:

- [Sprint 1](https://github.com/GabLopes12/CAMAAR/wiki/Documenta%C3%A7%C3%A3o-e-Implementa%C3%A7%C3%A3o:-Sprint-1) — definição do escopo, padrões de desenvolvimento e estrutura inicial do projeto (login, templates, formulários, importação SIGAA, exportação CSV).
- [Sprint 2](https://github.com/GabLopes12/CAMAAR/wiki/Documenta%C3%A7%C3%A3o-e-Implementa%C3%A7%C3%A3o:-Sprint-2) — implementação das funcionalidades principais: templates de formulário, submissão de respostas, exportação CSV, autenticação e sincronização com o SIGAA.
- [Sprint 3](https://github.com/GabLopes12/CAMAAR/wiki/Documenta%C3%A7%C3%A3o-e-Implementa%C3%A7%C3%A3o:-Sprint-3) — refino e qualidade: redução de complexidade ciclomática, eliminação de violações de ABC Score, ampliação da cobertura de testes (RSpec/SimpleCov) e documentação via RDoc.
