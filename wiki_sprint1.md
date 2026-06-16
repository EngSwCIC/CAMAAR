# Projeto CAMAAR - Sprint 1

**Grupo 3**

**Integrantes:**
- Rebeca de Souza Coutinho, 222001430
- Rafael Lopes Cordeiro, 202033688

**Escopo do Projeto:** 
O projeto CAMAAR é um sistema desenvolvido em Ruby on Rails para auxiliar no gerenciamento acadêmico, organizando informações de disciplinas, turmas, docentes e discentes de forma estruturada e integrada.

---

## Papéis do Grupo
- **Scrum Master:** Rafael Lopes Cordeiro
- **Product Owner:** Rebeca de Souza Coutinho

## Funcionalidades e Regras de Negócio
Durante esta sprint, nosso foco foi a descrição BDD das seguintes funcionalidades principais do MVP (Produto Mínimo Viável):
- Gerenciamento de Templates (Criação, Edição, Deleção e Visualização)
- Formulários de Avaliação (Criação, Visualização e Resposta)
- Relatórios Gerenciais do Administrador
- Autenticação e Login

## Divisão de Responsabilidades
- **Rafael Lopes Cordeiro:** Responsável por elaborar e descrever os cenários BDD das seguintes funcionalidades:
  - Criar formulário de avaliação
  - Criar template de formulário
  - Gerar relatório do administrador
  - Responder formulário
- **Rebeca de Souza Coutinho:** Responsável por elaborar e descrever os cenários BDD das seguintes funcionalidades:
  - Edição e deleção de templates
  - Visualização dos templates criados
  - Visualização de formulários para responder
  - Sistema de Login

## Descrição das Features BDD (Cucumber)
As funcionalidades foram transcritas para a sintaxe Gherkin (Cucumber), abrangendo os caminhos principal e alternativo de todas as issues do MVP:
- **Sistema de Login (`login.feature`):** Valida a autenticação do usuário e tratamento de credenciais inválidas.
- **Criar Template (`criar_template.feature`):** Valida a criação de um novo template e rejeição caso o nome fique em branco.
- **Criar Formulário (`criar_formulario.feature`):** Valida a disponibilização de uma avaliação para a turma ou falha ao não vincular template.
- **Visualização de Templates (`visualizacao_templates.feature`):** Valida a listagem de templates para o administrador ou o aviso quando não houver.
- **Edição e Deleção de Templates (`edicao_delecao_templates.feature`):** Valida a atualização de um template e impede exclusão se houver formulários atrelados.
- **Visualização de Formulários (`visualizacao_formularios.feature`):** Valida a exibição de avaliações pendentes para o participante.
- **Responder Formulário (`responder_formulario.feature`):** Valida o envio com todas as respostas e bloqueia caso campos obrigatórios faltem.
- **Gerar Relatório (`gerar_relatorio.feature`):** Valida a consolidação de respostas em relatórios para turmas ou acusa a falta de dados suficientes.

## Política de Branching
A equipe adotou o **GitHub Flow** como estratégia de versionamento para o projeto.
- A branch `main` sempre contém o código em estado de produção/estável.
- Novas funcionalidades e testes são desenvolvidos em branches criadas a partir da `main` com nomes descritivos (ex: `sprint-1`, `feature-cadastro`).
- Uma vez que o trabalho na branch está concluído, é aberto um **Pull Request** para a branch principal (`main`).
- Após revisão e aprovação, a branch do Pull Request é integrada e feito o merge na `main`.
