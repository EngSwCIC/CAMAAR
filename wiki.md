# 📚 Wiki — Sprint 3
## TrabalhoFinalEngSoft | CAMAAR — Sistema de Avaliação Acadêmica

---

## 👥 Integrantes do Grupo

| Nome | Matrícula |
|------|-----------|
| Jéssica Leal de Melo        | 21/1038253 |
| Júlia Paulo Amorim          | 24/1039270 |
| Matheus das Neves Fernandes | 23/1013672 |
| Vinicius Resplandes Caetano | 23/1025234 |
| Vitor Alencar Ribeiro       | 23/1036292 |

---

## 📌 Sobre o Projeto

**Nome do Projeto:** CAMAAR — Sistema de Controle e Avaliação de Atividades Acadêmicas

**Repositório:** [jessica8melo/TrabalhoFinalEngSoft](https://github.com/jessica8melo/TrabalhoFinalEngSoft)

**Disciplina:** Engenharia de Software — UnB 2026.1

### Escopo do Projeto

O CAMAAR é um sistema web desenvolvido em Ruby on Rails para a gestão de avaliações acadêmicas do Departamento de Ciência da Computação da UnB. O sistema permite que administradores importem dados de turmas, docentes e discentes, gerenciem templates de formulários de avaliação, e que usuários respondam e visualizem os resultados dessas avaliações.

---

## 🏅 Papéis do Time

| Papel | Responsável |
|-------|-------------|
| **Scrum Master** | Jéssica Leal de Melo |
| **Product Owner** | Matheus das Neves Fernandes  |

---

## ⚙️ Funcionalidades, Regras de Negócio e Responsáveis

### 🎲 #1 — Importar dados do SIGAA
**Responsável:** Matheus das Neves Fernandes
**Story Points:** 5

**História de Usuário:**
> Como um administrador, quero importar os dados de turmas, docentes e discentes a partir de um arquivo JSON do SIGAA, a fim de manter a base de dados do sistema atualizada.

**Regras de Negócio:**
- Apenas usuários com perfil **admin** podem realizar a importação
- O arquivo de importação deve estar no formato **JSON** seguindo a estrutura do SIGAA
- Em caso de erro no arquivo, o sistema deve exibir mensagem indicando o problema

---

### 🖊️ #2 — Responder Formulário
**Responsável:** Matheus das Neves Fernandes
**Story Points:** 5

**História de Usuário:**
> Como participante de uma turma, quero responder o questionário sobre a turma em que estou matriculado a fim de submeter minha avaliação da turma

**Regras de Negócio:**
- Participantes da turma podem tanto responder um formulário novo quanto visualizar um formulário já respondido
- Em caso de erro no processo, o sistema deve exibir mensagem indicando o problema
- As respostas do usuário devem ser preservada localmente

---

### 🖥️ #3 — Cadastrar usuários do sistema
**Responsável:** Matheus das Neves Fernandes
**Story Points:** 3

**História de Usuário:**
> Como um administrador, quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema a fim de que eles acessem o sistema CAMAAR

**Regras de Negócio:**
- Apenas usuários com perfil **admin** podem realizar o cadastro de participantes de turmas
- Em caso de erro no processo, o sistema deve exibir mensagem indicando o problema
- Para criar um usuário válido, deve-se colocar o email ou matrícula — a senha é definida pelo próprio usuário via link de convite enviado por e-mail
- A senha do usuário deve ter pelo menos 8 caracteres

---

### 📎 #4 — Gerar relatório do administrador
**Responsável:** Júlia Paulo Amorim
**Story Points:** 3

**História de Usuário:**
> Como um administrador, quero baixar um arquivo csv contendo os resultados de um formulário a fim de avaliar o desempenho das turmas

**Regras de Negócio:**
- Apenas usuários com perfil **admin** podem baixar o arquivo dos resultados das avaliações
- O arquivo de importação deve estar no formato **csv** seguindo a estrutura do SIGAA
- Em caso de erro no arquivo, o sistema deve exibir mensagem indicando o problema

---

### 📝 #5 — Gerar template de formulário
**Responsável:** Júlia Paulo Amorim
**Story Points:** 8

**História de Usuário:**
> Como um administrador, quero criar um template de formulário contendo as questões do formulário a fim de gerar formulários de avaliações para avaliar o desempenho das turmas

**Regras de Negócio:**
- Apenas usuários com perfil **admin** podem gerar template de formulário
- Em caso de erro no processo, o sistema deve exibir mensagem indicando o problema
- Um template deve ter pelo menos um campo/pergunta
- Os tipos de pergunta suportados são: texto livre, múltipla escolha e escala (1 a 5)
- Templates podem ser salvos como rascunho ou publicados

---

### 📋 #6 — Gerar formulário de avaliação
**Responsável:** Júlia Paulo Amorim
**Story Points:** 5

**História de Usuário:**
> Como um administrador, quero criar um formulário baseado em um template para as turmas que eu escolher a fim de avaliar o desempenho das turmas no semestre atual

**Regras de Negócio:**
- Apenas usuários com perfil **admin** podem gerar formulário de avaliação
- Usuários com perfil **discente** da respectiva turma podem visualizar e responder formulário enviado pelo administrador 
- Em caso de erro no processo, o sistema deve exibir mensagem indicando o problema
- O formulário deve ser feito a partir de um template e deve se referir a uma turma específica
- **(Sprint 3)** O administrador pode definir um prazo (deadline) customizado para o formulário no momento da criação, em vez de usar apenas um prazo padrão

---

### 🔐 #7 — Sistema de Login
**Responsável**: Jéssica Leal de Melo
**Story Points**: 3

**História de Usuário:**
> Como um usuário do sistema, quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada, a fim de responder formulários ou gerenciar o sistema.

**Regras de Negócio:**
- O usuário pode se autenticar com e-mail ou matrícula + senha
- Credenciais inválidas devem exibir mensagem de erro genérica (sem indicar qual campo está errado)
- Usuários com perfil admin visualizam a opção "Gerenciamento" no menu lateral
- Usuários com perfil discente/docente não visualizam o menu de gerenciamento

**Detalhes de implementação:**
- A página de Login é a primeira página que o usuário visualiza ao acessar o sistema
- Mensagens de sucesso (Login realizado com sucesso!) e de erro (Credenciais inválidas) são exibidas em um modal temporário para o usuário
- Ao ter login realizado com sucesso, o usuário é redirecionado para a página de Home, em que admins visualizam a opção "Gerenciamento" no menu lateral, mas usuários com perfil discente/docente não.

---

### 🔑 #8 — Sistema de Definição de Senha
**Responsável**: Jéssica Leal de Melo
**Story Points**: 3

**História de Usuário:**
> Como um usuário, quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro, a fim de acessar o sistema.

**Regras de Negócio:**

- O link de definição de senha é enviado por e-mail após o cadastro
- O link expira em 24 horas
- O link só pode ser utilizado uma única vez
- A senha deve ter no mínimo 8 caracteres
- Os campos "Nova Senha" e "Confirmar Senha" devem ser idênticos

**Detalhes de implementação:**
- O admin cadastra o usuário apenas com email, matrícula e role — sem senha
- O sistema gera um token de convite e envia o email automaticamente via Gmail SMTP
- O usuário acessa o link e define sua própria senha

---

### 🏛️ #9 — Sistema de Gerenciamento por Departamento
**Responsável:** Vitor Alencar Ribeiro
**Story Points:** 8

**História de Usuário:**
> Como um administrador, quero gerenciar usuários e turmas organizados por departamento, a fim de ter controle segmentado sobre as avaliações de cada área.

**Regras de Negócio:**

- Apenas usuários com perfil **admin** podem gerenciar por departamento
- Cada turma pertence a um departamento
- Admins podem ser restritos a gerenciar apenas seu próprio departamento
- Relatórios e formulários podem ser filtrados por departamento
- Informações de uma turma do departamento podem ser editadas
- Pode-se visualizar lista de discente ou docentes e estatísticas de respostas de uma turma
- Pode-se filtrar turmas por docente, por status ou por semestre

---

### 🔄 #10 — Redefinição de Senha
**Responsável**: Jéssica Leal de Melo
**Story Points**: 3

**História de Usuário:**
> Como um usuário cadastrado, quero redefinir minha senha caso a esqueça, a fim de recuperar o acesso ao sistema.

**Regras de Negócio:**

- O usuário solicita a redefinição clicando em "Esqueci minha senha" na tela de login
- O usuário informa seu e-mail ou matrícula
- Um link de redefinição é enviado para o e-mail cadastrado
- O link expira em 24 horas
- O link só pode ser utilizado uma única vez
- A senha deve ter no mínimo 8 caracteres
- Os campos "Nova Senha" e "Confirmar Senha" devem ser idênticos

**Detalhes de implementação:**
- Reutiliza o mesmo visual e lógica da tela de definição de senha (#8)
- O sistema não revela se o email/matrícula existe ou não (segurança)
- Token de redefinição independente do token de convite

---

### 🗄️ #11 — Atualizar Base de Dados com Dados do SIGAA
**Responsável**: Vinicius Resplandes Caetano
**Story Points**: 8

**História de Usuário:**
> Como um administrador, quero importar os dados de turmas, docentes e discentes a partir de um arquivo JSON do SIGAA, a fim de manter a base de dados do sistema atualizada.

**Regras de Negócio:**

- Apenas usuários com perfil admin podem realizar a importação
- O arquivo de importação deve estar no formato JSON seguindo a estrutura do SIGAA
- Em caso de erro no arquivo, o sistema deve exibir mensagem indicando o problema

---

### 📄 #12 — Visualização de Formulários para Responder
**Responsável:** Vitor Alencar Ribeiro
**Story Points:** 3

**História de Usuário:**
> Como um discente ou docente, quero visualizar os formulários de avaliação disponíveis para mim, a fim de respondê-los.

**Regras de Negócio:**

- O usuário só visualiza formulários vinculados às suas turmas
- Formulários já respondidos devem ser marcados como concluídos
- Formulários com prazo encerrado devem aparecer como expirados e não podem ser acessados
- Formulários podem ser filtrados por turma ou por data de término
- Formulários devem mostrar o prazo de vencimento e quanto tempo falta para esse prazo ser concluído
- Informações de formulário podem ser salvas e vistas posteriormente mesmo que não esteja concluído

---

### 📊 #13 — Visualização de Resultados dos Formulários
**Responsável:** Vitor Alencar Ribeiro
**Story Points:** 3

**História de Usuário:**
> Como um administrador ou docente, quero visualizar os resultados consolidados das avaliações respondidas, a fim de analisar o desempenho da turma.

Regras de Negócio:

- Admins visualizam resultados de todas as turmas
- Docentes visualizam apenas os resultados das suas próprias turmas
- Os resultados devem ser apresentados de forma anonimizada
- Só é possível visualizar resultados após o encerramento do formulário
- É possível filtrar formulários por tuma, por tipo de destinatário ou por período

---

### 👁️ #14 — Visualização dos Templates Criados
**Responsável:** Vinicius Resplandes Caetano
**Story Points:** 2

**História de Usuário:**
> Como um administrador, quero visualizar todos os templates de formulário criados, a fim de gerenciá-los.

**Regras de Negócio:**

- Apenas **admins** têm acesso à listagem de templates
- A listagem deve exibir: nome, status (rascunho/publicado) e data de criação
- Templates publicados podem ser visualizados, editados ou excluídos

---

### ✏️ #15 — Edição e Deleção de Templates
**Responsável:** Vinicius Resplandes Caetano
**Story Points:** 2

**História de Usuário:**
> Como um administrador, quero visualizar todos os templates de formulário criados, a fim de gerenciá-los.

**Regras de Negócio:**

- Apenas **admins** podem editar e/ou deletar templates
- A exclusão de um template não afeta formulários já gerados a partir dele
- O sistema deve solicitar confirmação antes de deletar

---

### 🆕 #16 — Criação de Formulário para Docentes ou Discentes
**Responsável:** Vitor Alencar Ribeiro
**Story Points:** 5

**História de Usuário:**
> Como um administrador, quero criar formulários direcionados especificamente a docentes ou discentes, a fim de obter avaliações distintas para cada perfil.

**Regras de Negócio:**

- O formulário deve ter um público-alvo definido: docentes, discentes ou ambos
- Discentes e docentes só visualizam formulários do seu perfil
- O formulário deve ser criado a partir de um template
- O formulário deve ser atríbuido a uma ou várias turmas de um mesmo departamento

---

## 🛠️ Sprint 3 — Consolidação, Refatoração e Qualidade

Diferente das sprints anteriores, a Sprint 3 concentrou boa parte do esforço em **fechar as funcionalidades que ficaram pendentes da Sprint 2** (#1, #2, #3, #4, #5, #6, #9, #11 a #16) e em um trabalho amplo de **qualidade de código e consolidação técnica**, feito em cima de todo o projeto. Os principais destaques:

### 🔗 Unificação dos sistemas de formulário
O projeto tinha evoluído com **dois sistemas paralelos** para representar formulários e respostas: um mais antigo (`Formulario` / `Pergunta` / `Resposta`) e outro mais novo (`Template` / `Form` / `Question` / `FormResponse`). Isso causava inconsistências e duplicidade de regras de negócio. Na Sprint 3:
- Os controllers e models legados (`formularios_controller`, `respostas_controller`, `formulario.rb`, `pergunta.rb`, `resposta.rb`) foram **removidos**
- Uma migração de consolidação (`ConsolidateFormSystems`) migra os dados existentes das tabelas antigas para o sistema novo e adiciona as colunas que faltavam para cobrir regras de negócio que só existiam no sistema legado: `questions.obrigatoria`, `templates.status` (rascunho/publicado — feature #5) e `forms.target_audience` (público-alvo — feature #16)
- O sistema `Template` / `Form` / `Question` / `FormResponse` passou a ser a única fonte de verdade para as funcionalidades de formulário

### 🧹 Refatoração e redução de complexidade
- Refatoração de `SigaaImporter` e `SigaaSyncService` para reduzir complexidade ciclomática e ABC Score (Issue #1)
- Refatoração geral dos controllers para a Entrega 3, com foco em reduzir ABC Score
- Remoção de código duplicado nos step definitions do Cucumber, centralizado em `features/step_definitions/shared_steps.rb`
- Correção de uma inconsistência no fluxo de login identificada durante a sprint

### 📖 Documentação de código
- Adição de comentários de classe (RDoc) em controllers e services (`Sessions`, `Sigaa`, `Templates`, entre outros) para eliminar alertas do **Reek**
- Objetivo: manter o código autoexplicativo e em conformidade com as ferramentas de análise estática adotadas pelo grupo

### 🧪 Ferramentas de qualidade adicionadas (Gemfile)
| Gem | Finalidade |
|-----|------------|
| `rubocop-rails-omakase` | Padronização de estilo de código Ruby/Rails |
| `reek` | Detecção de code smells |
| `saikuro` | Análise de complexidade ciclomática |
| `rubycritic` | Relatório consolidado de qualidade de código |
| `simplecov` | Cobertura de testes |
| `rdoc` | Geração de documentação a partir dos comentários RDoc |

### ✅ Testes
Testes RSpec e Cucumber foram criados/completados para todas as funcionalidades que ainda não tinham cobertura ao final da Sprint 2: importação/atualização via SIGAA (#1, #11), cadastro de usuários (#3), geração de relatório (#4), geração e visualização de templates (#5, #14, #15), geração de formulários e formulários customizados por público-alvo (#6, #16), visualização de formulários para responder (#12) e visualização de resultados (#13). Também foram adicionados testes para os controllers refatorados (`Admin::ImportsController`, `PasswordResetsController`, `PasswordSetsController`), cobrindo *happy* e *sad paths*.

---

## 📈 Velocity — Story Points da Sprint 3

Todas as histórias planejadas desde a Sprint 2 foram concluídas ao final da Sprint 3, incluindo suas respectivas suítes de teste (RSpec/Cucumber).

| Issue | Funcionalidade | Story Points | Status |
|-------|---------------|:------------:|--------|
| #1 | Importar dados do SIGAA | 5 | ✅ Feito |
| #2 | Responder Formulário | 5 | ✅ Feito |
| #3 | Cadastrar usuários do sistema | 3 | ✅ Feito |
| #4 | Gerar relatório do administrador | 3 | ✅ Feito |
| #5 | Gerar Template de Formulário | 8 | ✅ Feito |
| #6 | Gerar Formulário de Avaliação | 5 | ✅ Feito |
| #7 | Sistema de Login | 3 | ✅ Feito |
| #8 | Sistema de Definição de Senha | 3 | ✅ Feito |
| #9 | Gerenciamento por Departamento | 8 | ✅ Feito |
| #10 | Redefinição de Senha | 2 | ✅ Feito |
| #11 | Atualizar Base com SIGAA | 8 | ✅ Feito |
| #12 | Visualização de Formulários | 3 | ✅ Feito |
| #13 | Visualização de Resultados | 3 | ✅ Feito |
| #14 | Visualização dos Templates | 2 | ✅ Feito |
| #15 | Edição e Deleção de Templates | 3 | ✅ Feito |
| #16 | Criação de Formulário Docente/Discente | 5 | ✅ Feito |
| | **Total da Sprint** | **69** | |
| | **Velocity Sprint 2 (referência)** | **8** | #7 + #8 + #10 |
| | **Velocity Sprint 3 (concluídos)** | **69** | Todas as histórias |

> 💡 **O que é Velocity?** É a soma dos story points das histórias **concluídas** ao final da sprint. A Sprint 2 fechou com velocity 8 (apenas o módulo de autenticação). Na Sprint 3, o grupo concluiu as 13 histórias restantes, além de dedicar parte do esforço à consolidação técnica e à qualidade de código descritas acima.

---

## 🌿 Política de Branching

O grupo adota o seguinte fluxo de branches:

```
main
└── sprint-3
    ├── sprint-3-julia
    ├── sprint-3-matheus
    ├── fix/#7-sistema_de_login
    └── ...
```

### Regras

- **`main`** — branch de produção, recebe merges apenas via Pull Request revisada
- **`sprint-N`** — branch da sprint atual, base para todas as features da sprint
- **`sprint-N-nome`** / **`feature/#N-nome-curto`** / **`fix/#N-nome-curto`** — branches individuais de trabalho, criadas a partir de `sprint-N` (por integrante ou por issue, conforme a natureza da tarefa) e mescladas de volta em `sprint-N` via Pull Request

> Na Sprint 3, além das branches por issue, o grupo também utilizou branches por integrante (ex.: `sprint-3-julia`, `sprint-3-matheus`) para consolidar refatorações e correções que atravessavam múltiplas funcionalidades, como a unificação dos sistemas de formulário e as melhorias de qualidade de código.

### Nomenclatura de commits

Seguir o padrão com referência à issue:

```
git commit -m "Descrição da mudança #7"
```

Para fechar a issue automaticamente ao fazer merge na main:

```
git commit -m "Implementa sistema de login closes #7"
```

### Pull Requests

- PRs de `feature/*`, `fix/*` e branches individuais (ex.: `sprint-3-nome`) vão para `sprint-3`
- PRs de `sprint-3` vão para `main` ao fim da sprint

---

_Última atualização: Sprint 3 — 2026.1_