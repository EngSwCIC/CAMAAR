# 📚 Wiki — Sprint 1
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
- Para criar um usuário válido, deve-se colocar o email ou matrícula e uma senha
- A senha do usuário deve ter pelo menos 6 caracteres

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
- A senha deve ter no mínimo 6 caracteres
- Os campos "Nova Senha" e "Confirmar Senha" devem ser idênticos

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

- O usuário solicita a redefinição informando seu e-mail ou matrícula
- Um link de redefinição é enviado para o e-mail cadastrado
- O link expira em 24 horas
- A nova senha não pode ser igual à senha anterior

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



## 📈 Velocity — Story Points da Sprint 1

| Issue | Funcionalidade | Story Points | Status |
|-------|---------------|:------------:|--------|
| #1 | Importar dados do SIGAA | 5 | 🔲 A fazer |
| #2 | Responder Formulário | 5 | 🔲 A fazer |
| #3 | Cadastrar usuários do sistema | 3 | 🔲 A fazer |
| #4 | Gerar relatório do administrador | 3 | 🔲 A fazer |
| #5 | Gerar Template de Formulário | 8 | 🔲 A fazer |
| #6 | Gerar Formulário de Avaliação | 5 | 🔲 A fazer |
| #7 | Sistema de Login | 3 | 🔲 A fazer |
| #8 | Sistema de Definição de Senha | 3 | 🔲 A fazer |
| #9 | Gerenciamento por Departamento | 8 | 🔲 A fazer |
| #10 | Redefinição de Senha | 2 | 🔲 A fazer |
| #11 | Atualizar Base com SIGAA | 8 | 🔲 A fazer |
| #12 | Visualização de Formulários | 3 | 🔲 A fazer |
| #13 | Visualização de Resultados | 3 | 🔲 A fazer |
| #14 | Visualização dos Templates | 2 | 🔲 A fazer |
| #15 | Edição e Deleção de Templates | 3 | 🔲 A fazer |
| #16 | Criação de Formulário Docente/Discente | 5 | 🔲 A fazer |
| | **Total da Sprint** | **69** | |
| | **Velocity (concluídos)** | **0** | _atualizar ao fim da sprint_ |

> 💡 **O que é Velocity?** É a soma dos story points das histórias **concluídas** ao final da sprint. Ao fim da Sprint 2, atualize a coluna "Status" e some apenas os pontos das histórias entregues. Esse número será a velocity de referência para planejar a Sprint 3.

---

## 🌿 Política de Branching

O grupo adota o seguinte fluxo de branches:

```
main
└── sprint-1
    ├── feature/#7-login
    ├── feature/#8-definicao-senha
    ├── feature/#10-redefinicao-senha
    └── ...
```

### Regras

- **`main`** — branch de produção, recebe merges apenas via Pull Request revisada
- **`sprint-N`** — branch da sprint atual, base para todas as features da sprint
- **`feature/#N-nome-curto`** — uma branch por issue, criada a partir de `sprint-N`

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

- PRs de `feature/*` vão para `sprint-1`
- PRs de `sprint-1` vão para `main` ao fim da sprint
- Toda PR precisa de pelo menos **1 aprovação** de outro integrante antes do merge

---

_Última atualização: Sprint 1 — 2026.1_