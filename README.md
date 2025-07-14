# CAMAAR
**Sistema para avaliação de atividades acadêmicas remotas do CIC**

[![Rails Version](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.4.1-red.svg)](https://www.ruby-lang.org/)

---

## Membros do Grupo

1. **Victor Henrique da Silva Costa** - 212006450
2. **Denis S.G de Araújo** - 140136282  
3. **Luís Eduardo Dalle Molle** - 241034059
4. **Ryan Reis Fontenele** - 211036132
5. **Gabriel Henrique Barbosa de Oliveira** - 231029583

---

## Papéis do Scrum

### Product Owner
*A ser definido*

### Scrum Master  
 - **Victor Henrique da Silva Costa** - 212006450

### Development Team
 - **Denis S.G de Araújo** - 140136282  
 - **Luís Eduardo Dalle Molle** - 241034059
 - **Ryan Reis Fontenele** - 211036132
 - **Gabriel Henrique Barbosa de Oliveira** - 231029583

---



# Funcionalidades do Sistema CAMAAR

### 18. Visualizar resultados dos formulários

#### Funcionalidade: Visualizar resultados dos formulários

**Status:** Será implementada na terceira sprint

* **Cenário:** Visualizar resultados enquanto formulário ainda está aberto.
  - O sistema exibe resultados parciais das respostas já recebidas, informando que o formulário ainda está aberto para novas respostas.

* **Cenário:** Visualizar resultados com sucesso.
  - O usuário visualiza os resultados completos após o encerramento do prazo de respostas do formulário.

* **Cenário:** Dado que estou logado como coordenador do curso de Engenharia E que o formulário pertence ao curso de Direito Quando tento acessar a visualização dos resultados Então recebo uma mensagem de erro: "Acesso negado formulário não pertence ao seu curso".
  - O sistema bloqueia o acesso e exibe a mensagem de erro informando que o formulário não pertence ao curso do coordenador logado.

### 17. Responder formulário

#### Funcionalidade: Responder formulário

**Status:** Será implementada na terceira sprint

* **Cenário:** Formulário com respostas anônimas.
  - O sistema garante o anonimato das respostas quando o formulário exige anonimato, utilizando identificador anônimo.

* **Cenário:** Tentar enviar sem preencher perguntas obrigatórias.
  - O sistema bloqueia o envio e exibe uma mensagem informando que todas as perguntas obrigatórias devem ser respondidas.

* **Cenário:** Tentar responder fora do prazo.
  - O sistema bloqueia o envio e exibe uma mensagem informando que o prazo para resposta expirou.

* **Cenário:** Responder formulário com sucesso.
  - O usuário preenche e envia o formulário dentro do prazo, e as respostas são registradas com sucesso.

### 16. Criar template de formulário

#### Funcionalidade: Criar template de formulário

**Status:** Implementada

* **Cenário:** Criar template com sucesso.
  - O usuário preenche as informações obrigatórias e adiciona perguntas, criando um novo template de formulário com sucesso.

* **Cenário:** Criar template com pergunta de múltipla escolha e dissertativas.
  - O sistema permite adicionar perguntas de múltipla escolha e perguntas dissertativas ao template.

* **Cenário:** Tentar salvar template sem perguntas.
  - O sistema bloqueia o salvamento e exibe uma mensagem informando que é necessário adicionar pelo menos uma pergunta ao template.

### 15. Importar dados do SIGAA

#### Funcionalidade: Importar dados do SIGAA

**Status:** Implmentada

* **Cenário:** Importar dados com sucesso via JSON.
  - O sistema importa corretamente os dados do SIGAA a partir de um arquivo JSON válido, atualizando a base de dados.

* **Cenário:** Importar arquivo JSON com usuários já cadastrados.
  - O sistema reconhece usuários já existentes e evita duplicidade ao importar o arquivo JSON.

* **Cenário:** Importar JSON mal formatado.
  - O sistema bloqueia a importação e exibe uma mensagem de erro informando que o arquivo está mal formatado ou inválido.

### 14. Gerar relatório do administrador

#### Funcionalidade: Gerar relatório do administrador

**Status:** Implementada

* **Cenário:** Gerar relatório filtrando por departamento e período.
  - O administrador seleciona o departamento e o período desejado e o sistema gera um relatório com os dados filtrados.

* **Cenário:** Tentativa de gerar relatório sem respostas.
  - O sistema informa que não há respostas disponíveis e não gera o relatório.

* **Cenário:** Gerar relatório por formulário.
  - O administrador seleciona um formulário específico e o sistema gera um relatório detalhado com as respostas desse formulário.

### 13. Cadastrar usuários do sistema

#### Funcionalidade: Cadastrar usuários do sistema

**Status:** Implementada

* **Cenário:** Cadastro manual de usuário com sucesso.
  - O administrador ou coordenador preenche os dados do usuário e realiza o cadastro manualmente com sucesso.

* **Cenário:** Cadastro em lote por planilha.
  - O sistema permite importar uma planilha (CSV/XLSX) para cadastrar múltiplos usuários de uma só vez.

* **Cenário:** Cadastro com e-mail inválido.
  - O sistema bloqueia o cadastro e exibe uma mensagem informando que o e-mail informado é inválido.

### 12. Criar formulário de avaliação

#### Funcionalidade: Criar formulário de avaliação

**Status:** Implementada

* **Cenário:** Criar formulário a partir de um template.
  - O sistema permite ao usuário selecionar um template e criar um novo formulário de avaliação baseado nele.

* **Cenário:** Reutilização de template.
  - O usuário pode reutilizar um template já existente para criar múltiplos formulários de avaliação para diferentes turmas ou períodos.

* **Cenário:** Tentativa de criar formulário sem template selecionado.
  - O sistema bloqueia a criação e exibe uma mensagem solicitando a seleção de um template.

### 11. Sistema de Login

#### Funcionalidade: Sistema de Login

**Status:** Implementada

* **Cenário:** Login com sucesso.
  - O usuário informa e-mail e senha válidos e acessa o sistema normalmente.

* **Cenário:** Login com senha incorreta.
  - O sistema bloqueia o acesso e exibe uma mensagem de erro informando senha inválida.

* **Cenário:** Login com diferentes perfis.
  - O sistema direciona o usuário para a área correspondente ao seu perfil (administrador, coordenador, docente ou discente) após login bem-sucedido.

* **Cenário:** Tentativa de login com e-mail não cadastrado.
  - O sistema bloqueia o acesso e exibe uma mensagem informando que o e-mail não está cadastrado.

### 10. Sistema de gerenciamento por departamento

#### Funcionalidade: Sistema de gerenciamento por departamento

**Status:** Será implementada na terceira sprint

* **Cenário:** Administrador visualiza formulários de todos os departamentos.
  - O administrador acessa a listagem e visualiza formulários de todos os departamentos sem restrição.

* **Cenário:** Coordenador tenta acessar formulário de outro departamento via link direto.
  - O sistema bloqueia o acesso e exibe uma mensagem de permissão negada.

* **Cenário:** Coordenador visualiza apenas formulários do seu departamento.
  - O sistema filtra e exibe apenas os formulários do departamento ao qual o coordenador pertence.

* **Cenário:** Filtro por departamento na listagem de formulários.
  - O sistema permite filtrar a listagem de formulários por departamento, facilitando a navegação e gestão.

### 9. Sistema de definição de senha

#### Funcionalidade: Sistema de definição de senha

**Status:** Implementada

* **Cenário:** Definir senha com critérios inválidos.
  - O sistema bloqueia a definição e exibe uma mensagem informando os critérios mínimos para a senha.

* **Cenário:** Link de definição de senha expirado.
  - O sistema informa que o link não é mais válido e orienta o usuário a solicitar um novo link de definição.

* **Cenário:** Definir senha com sucesso no primeiro acesso.
  - O usuário acessa o link de definição, informa uma senha válida e tem seu acesso liberado ao sistema.

### 8. Redefinição de senha

#### Funcionalidade: Redefinição de senha

**Status:** Será implementada na terceira sprint

* **Cenário:** Redefinir senha com sucesso.
  - O usuário acessa o link de redefinição, informa uma nova senha válida e tem sua senha atualizada com sucesso.

* **Cenário:** Nova senha não atende aos critérios.
  - O sistema bloqueia a redefinição e exibe uma mensagem informando os critérios mínimos para a senha.

* **Cenário:** Link de redefinição expirado ou inválido.
  - O sistema informa que o link não é mais válido e orienta o usuário a solicitar um novo link de redefinição.

### 7. Visualização de formulários para responder

#### Funcionalidade: Visualização de formulários para responder

**Status:** Será implementada na terceira sprint

* **Cenário:** Nenhum formulário disponível para o usuário.
  - O sistema exibe uma mensagem informando que não há formulários disponíveis para resposta.

* **Cenário:** Ver formulários disponíveis para resposta.
  - O usuário visualiza uma lista de formulários que pode responder, de acordo com seu perfil e turma.

* **Cenário:** Ver apenas formulários do perfil do usuário.
  - O sistema filtra e exibe apenas os formulários destinados ao perfil do usuário logado (docente ou discente).

* **Cenário:** Formulário já respondido.
  - O sistema indica que o formulário já foi respondido e impede nova submissão.

### 6. Atualizar base de dados com dados do SIGAA

#### Funcionalidade: Atualizar base de dados com dados do SIGAA

**Status:** Será implementada na terceira sprint

* **Cenário:** Importar dados atualizando e mantendo os existentes.
  - O sistema importa um arquivo JSON do SIGAA, atualizando registros existentes e mantendo os dados já presentes na base.

* **Cenário:** Importação sem alterações (JSON idêntico à base).
  - O sistema reconhece que não há alterações e mantém a base de dados inalterada.

* **Cenário:** JSON com estrutura inválida ou corrompida.
  - O sistema bloqueia a importação e exibe uma mensagem de erro informando o problema com o arquivo.

## Funcionalidades Principais

### 1. Autenticação de Usuários

* **Descrição**: Permite o acesso ao sistema por meio de login e senha, com papéis distintos para administradores, coordenadores, docentes e discentes. O sistema valida credenciais, mantém sessões seguras e controla permissões de acordo com o papel do usuário.
* **Entidades Envolvidas**: `usuarios` (id, email, senha\_hash, nome, papel, matrícula, curso\_id)
* **BDD**:

  * **Cenário**: Login bem-sucedido para cada tipo de usuário.
  * **Cenário**: Acesso negado a áreas restritas sem autenticação.


### 2. Gerenciamento, Edição e Deleção de Templates de Formulários

#### Funcionalidade: Visualizar templates criados

**Status:** Será implementada na terceira sprint

* **Cenário:** Visualizar lista de templates com informações básicas.
  - O sistema exibe uma lista de templates cadastrados, mostrando título, público-alvo e status de uso.

* **Cenário:** Buscar template por título.
  - O usuário pode buscar templates pelo título e visualizar apenas os resultados correspondentes.

* **Cenário:** Visualizar perguntas de um template.
  - Ao selecionar um template, o sistema exibe as perguntas associadas a ele.

* **Cenário:** Nenhum template encontrado na busca.
  - O sistema exibe uma mensagem informando que nenhum template foi encontrado para o termo pesquisado.

* **Descrição**: Permite o CRUD completo de templates de formulários, incluindo criação, edição e deleção. Templates são definidos por administradores ou coordenadores e servem de base para a criação de formulários instanciados. A edição e deleção seguem regras de integridade para não afetar formulários já utilizados.
* **Entidades Envolvidas**: `templates` (id, título, público_alvo, criado_por), `perguntas` (id, template_id, título, tipo, ordem), `opcoes_pergunta` (id, pergunta_id, texto)

#### Criação de Templates
* Administradores ou coordenadores podem criar novos templates, definindo título, público-alvo e perguntas.

#### Edição de Templates
* Templates podem ser editados enquanto não foram utilizados para gerar formulários instanciados.
* Caso o template já tenha sido utilizado, apenas campos não críticos podem ser editados (ex: título ou público-alvo), mantendo a integridade dos formulários existentes.
* Alterações em perguntas ou opções de perguntas em templates já utilizados são bloqueadas, exibindo mensagem de erro ao usuário.

#### Deleção de Templates
* Templates só podem ser deletados se nunca foram utilizados para criar formulários instanciados.
* Ao tentar deletar um template em uso, o sistema bloqueia a ação e exibe uma mensagem informando que a exclusão não é permitida.

* **Regras de Negócio**:
  - Não permitir edição de perguntas/opções em templates já utilizados.
  - Permitir edição de campos descritivos (título, público-alvo) mesmo após uso.
  - Não permitir deleção de templates em uso.


#### Funcionalidade: Editar e deletar templates de formulário

**Status:** Implementada

* **Cenário:** Editar template com sucesso.
  - O sistema permite editar campos descritivos (título, público-alvo) de um template, mesmo após uso.
  - Edição de perguntas/opções só é permitida se o template nunca foi utilizado.

* **Cenário:** Excluir template não utilizado.
  - O sistema permite a exclusão de templates que nunca foram utilizados para criar formulários instanciados.

* **Cenário:** Tentar excluir template já utilizado em formulários.
  - O sistema bloqueia a exclusão e exibe uma mensagem de erro informando que o template está em uso.

### 3. Criação de Formulários Instanciados

* **Descrição**: Instancia um formulário a partir de um template, direcionando-o a uma turma específica. Define prazos (`data_envio`, `data_fim`) e garante envio apenas a alunos matriculados.
* **Entidades Envolvidas**: `formularios` (id, template\_id, turma\_id, coordenador\_id, data\_envio, data\_fim), `turmas`, `matriculas`
* **BDD**:

#### Funcionalidade: Criar formulário para docentes ou discentes

**Status:** Implementada

* **Cenário:** Criar formulário direcionado a discentes.
  - O sistema permite ao coordenador criar um formulário e selecionar o público-alvo "discentes".
  - O formulário é associado corretamente à turma e ao template escolhido.

* **Cenário:** Tentar criar formulário sem selecionar o público-alvo.
  - O sistema bloqueia a criação do formulário e exibe uma mensagem de erro solicitando a seleção do público-alvo.

*Obs: Cenários e funcionalidades não listados aqui serão documentados conforme enviados.*

### 4. Submissão de Respostas

* **Descrição**: Interface para alunos responderem questões abertas, de múltipla escolha ou verdadeiro/falso. Suporta anonimato via `uuid_anonimo` e registra timestamp de envio.
* **Entidades Envolvidas**: `respostas` (id, formulario\_id, pergunta\_id, opcao\_id, resposta\_texto, turma\_id, uuid\_anonimo, created\_at)
* **BDD**:

  * **Cenário**: Responder formulário com sucesso dentro do prazo.
  * **Cenário**: Bloqueio de respostas fora do prazo.
  * **Cenário**: Erro ao enviar sem preencher perguntas obrigatórias.
  * **Cenário**: Registro de resposta anônima via `uuid_anonimo`.

### 5. Visualização de Resultados

* **Descrição**: Administradores e coordenadores podem visualizar estatísticas e respostas coletadas. Oferece filtros por curso, disciplina, turma e período, e permite exportação dos dados em CSV ou PDF.
* **Entidades Envolvidas**: junção de `respostas`, `formularios`, `perguntas`, `usuarios`, `turmas`
* **BDD**:

  * **Funcionalidade**: Visualizar resultados dos formulários.
  * **Cenário**: Exibição de resultados completos.
  * **Cenário**: Visualização parcial enquanto o formulário permanece aberto.
  * **Funcionalidade**: Exportação dos resultados via botão no dashboard.

## Funcionalidades Secundárias

* **Notificações**: Alertas por e-mail ou notificações no dashboard sobre novos formulários, prazos de entrega e resultados publicados.
* **Relatórios**: Geração de relatórios de desempenho em PDF ou planilha, com gráficos de participação e taxa de resposta.
* **Backup de Dados**: Agendamento automático de backups do banco de dados e arquivos de formulários.
* **Integração com Moodle**: Sincronização de turmas, usuários e notas via API do Moodle para manter uma única fonte de dados.

## Regras de Negócio

1. **Usuários só podem acessar áreas permitidas de acordo com seu papel** (administrador, coordenador, docente ou discente).
2. **Templates de formulários não podem ser excluídos** se já foram utilizados para gerar formulários instanciados.
3. **Formulários devem ser respondidos dentro do intervalo de tempo definido** (`data_envio` até `data_fim`).
4. **Somente alunos matriculados em uma turma associada ao formulário podem respondê-lo.**
5. **Formulários direcionados a discentes não devem permitir identificação pessoal nas respostas** (uso obrigatório de `uuid_anonimo`).
6. **Todas as respostas devem estar vinculadas a uma turma e a uma pergunta específica**.
7. **Respostas incompletas ou fora do prazo não são salvas no sistema.**
8. **Visualizações de resultados devem respeitar o papel do usuário logado**, ocultando informações sensíveis a quem não tem permissão.
9. **O sistema não deve permitir edição de formulários já enviados por alunos.**
10. **Backups devem ocorrer em horários agendados e manter as últimas X versões disponíveis para restauração.**
11. **A integração com o Moodle deve sincronizar automaticamente os dados das turmas e alunos semanalmente.**
12. **As perguntas em um formulário devem seguir a ordem definida no template.**


---

## CI/CD e Qualidade de Código

### GitHub Actions

O projeto utiliza GitHub Actions para integração contínua e entrega contínua (CI/CD). Os workflows executam automaticamente a cada push e pull request.

#### Workflows Configurados

1. **CI (Continuous Integration)**
   - **Trigger**: Push/PR para `main` e `develop`
   - **Jobs**:
     - **test**: Executa toda a suíte de testes RSpec
     - **lint**: Executa RuboCop para verificação de estilo
     - **security**: Executa Brakeman para análise de segurança

2. **Status Badges**
   - **Trigger**: Push para `main`
   - **Propósito**: Gera badges de status para o README

#### Artefatos Gerados

- **Relatórios de Teste**: Formato JUnit XML para integração com ferramentas de CI
- **Relatórios RuboCop**: Formato JSON com violações de estilo
- **Relatórios Brakeman**: Formato JSON com vulnerabilidades de segurança

### Qualidade de Código

#### RuboCop
- **Configuração**: `.rubocop.yml` com regras específicas para Rails
- **Plugins**: rubocop-rails, rubocop-rspec, rubocop-performance
- **Execução**: `bundle exec rubocop`

#### RSpec
- **Cobertura**: 267 testes, 0 falhas
- **Tipos**: Models, Controllers, Views, Helpers, Routing
- **Configuração**: Relatórios em formato JUnit para CI

#### Brakeman
- **Análise de Segurança**: Verifica vulnerabilidades conhecidas
- **Configuração**: `.brakeman.yml` com checks específicos
- **Execução**: `bundle exec brakeman`

### Executar CI Localmente

Para executar os mesmos checks que rodam no CI:

```bash
# Executar script completo de CI
./scripts/ci_local.sh

# Ou executar individualmente:
bundle exec rubocop                # Verificação de estilo
bundle exec rspec                  # Testes
bundle exec brakeman               # Análise de segurança
```

### Status do Build

- ✅ **Testes**: 267 exemplos, 0 falhas
- ✅ **Cobertura**: Models, Controllers, Views, Helpers
- ✅ **Segurança**: Configuração Brakeman ativa
- ✅ **Estilo**: RuboCop configurado

---

## Responsabilidades de Cada Membro

### Victor Henrique da Silva Costa

* **Frontend com ERB**: Desenvolvimento das views utilizando HTML, CSS e JavaScript puro.
* **Experiência do Usuário (UX)**: Estruturação de páginas intuitivas e acessíveis.
* **Validações no Lado do Cliente**: Garante consistência dos dados antes do envio.

### Denis S.G de Araújo

* **Lógica de Controllers**: Criação de controllers responsáveis por gerenciar os fluxos principais da aplicação.
* **Regras de Negócio**: Implementação direta no backend com foco nas ações dos usuários e estados das entidades.
* **Helpers e Partials**: Organização de componentes reutilizáveis.

### Luís Eduardo Dalle Molle

* **Organização dos Models**: Criação e manutenção das entidades ActiveRecord com validações e associações.
* **Escopos e Query Optimization**: Desenvolvimento de escopos reutilizáveis e consultas performáticas.
* **Seeds e Migrations**: Gerenciamento do schema e população do banco de dados.

### Ryan Reis Fontenele

* **Testes Automatizados com RSpec**: Criação de testes unitários, de request e de integração para todas as telas e módulos.
* **Cobertura Total**: Garantia de testes para todas as funcionalidades críticas do sistema.
* **Documentação Técnica e Funcional**: Registro completo da aplicação e seu funcionamento.

### Gabriel Henrique Barbosa de Oliveira

* **Módulos de Integração**: Desenvolvimento de módulos específicos para integração com sistemas externos como o Moodle.
* **Camada de Serviços**: Separação de responsabilidades através de service objects.
* **Manutenção da Performance**: Refino de métodos e uso eficiente de callbacks, background jobs e consultas complexas.

## Política de Branching

### Estrutura de Branches

\`\`\`
main
├── develop
├── feature/nome-da-funcionalidade
├── hotfix/nome-do-hotfix
└── release/versao
\`\`\`

### Regras de Branching

#### Branch `main`
- **Propósito**: Código em produção
- **Proteção**: Apenas merge via Pull Request
- **Testes**: Todos os testes devem passar
- **Review**: Obrigatório review de pelo menos 2 membros

#### Branch `develop`  
- **Propósito**: Integração de funcionalidades
- **Origem**: Base para feature branches
- **Merge**: Apenas de feature branches testadas

#### Feature Branches
- **Nomenclatura**: `feature/CAMAAR-123-nome-descritivo`
- **Origem**: Criada a partir de `develop`
- **Ciclo de Vida**: 
  1. Criar branch
  2. Desenvolver funcionalidade
  3. Testes locais
  4. Pull Request para `develop`
  5. Code Review
  6. Merge e exclusão da branch

#### Hotfix Branches
- **Nomenclatura**: `hotfix/CAMAAR-456-correcao-critica`
- **Origem**: Criada a partir de `main`
- **Urgência**: Para correções críticas em produção
- **Merge**: Tanto em `main` quanto em `develop`

#### Release Branches
- **Nomenclatura**: `release/v1.2.0`
- **Propósito**: Preparação para nova versão
- **Atividades**: Testes finais, ajustes de versão, documentação

### Commits

#### Padrão de Commit Messages
\`\`\`
tipo(escopo): descrição breve

Descrição mais detalhada se necessário

Closes #123
\`\`\`

#### Tipos de Commit
- `feat`: Nova funcionalidade
- `fix`: Correção de bug  
- `docs`: Documentação
- `style`: Formatação de código
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Tarefas de manutenção

#### Exemplo de Commit
\`\`\`bash
git commit -m "feat(auth): implementa sistema de login com JWT

- Adiciona middleware de autenticação
- Implementa geração e validação de tokens
- Adiciona testes unitários para auth service

Closes #45"
\`\`\`
