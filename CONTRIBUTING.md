# Guia de Contribuição - Projeto CAMAAR (Grupo 4)

### Integrantes: 
- Guilherme Fornari
- João Magno
- Pedro Conti
- Rodrigo Rafik

Este documento define as regras e o fluxo de trabalho que todos os membros do grupo devem seguir para garantir a organização e a qualidade do nosso projeto.

## 1. Papéis (Scrum)

Teremos dois papéis rotativos:

* **Product Owner (PO):** Responsável por ser a "voz do cliente", priorizar as User Stories (Issues) no backlog e validar as entregas.
* **ScrumMaster (SM):** Responsável por remover impedimentos, garantir que o time siga o processo (incluindo este guia) e proteger a equipe de distrações.

## 2. Nomenclatura de Branches

Toda nova tarefa, seja ela um BDD, uma feature ou um bugfix, **deve** ser feita em sua própria branch. **Nunca faça commits diretamente na `master` ou em branches de sprint**.

**Padrão:** `tipo/nome-da-tarefa`

### Tipos de Branch

* **`bdd/`**: Usado para escrever arquivos de especificação (`.feature`) do Cucumber.
    * *Exemplo:* `bdd/login-de-usuario`
    * *Exemplo:* `bdd/gerar-relatorio`

* **`feature/`**: Usado para implementar novas funcionalidades (o código da aplicação).
    * *Exemplo:* `feature/login-de-usuario`

* **`fix/`**: Usado para corrigir bugs em funcionalidades existentes.
    * *Exemplo:* `fix/erro-no-login-com-email`

* **`docs/`**: Usado para alterações na documentação (Wiki, README, etc.).
    * *Exemplo:* `docs/atualiza-instrucoes-do-guia`

## 3. Nomenclatura de Commits

Para manter o histórico do Git limpo e legível, usaremos prefixos nos nossos commits.

**Padrão:** `prefixo: Mensagem clara do que foi feito.`

### Prefixos de Commit

* **`spec:`**: (Para Sprint 1) Adição ou modificação de arquivos de especificação BDD (`.feature`).
    * *Exemplo:* `spec: Adiciona cenários feliz e triste para login de usuário`

* **`feat:`**: (Sprints futuras) Adição de uma nova funcionalidade (código).
    * *Exemplo:* `feat: Implementa rota e controller para login`

* **`fix:`**: (Sprints futuras) Correção de um bug.
    * *Exemplo:* `fix: Corrige validação de senha no login`

* **`refac:`**: Alteração de código que não corrige bug nem adiciona feature.
    * *Exemplo:* `refact: Remove código duplicado do controller de usuário`

* **`docs:`**: Alterações na documentação.
    * *Exemplo:* `docs: Atualiza wiki com novo fluxo de PR`

* **`style:`**: Alterações de formatação, lint, etc. (sem mudança lógica).
    * *Exemplo:* `style: Aplica formatação do RuboCop`

## 4. Fluxo de Trabalho (Workflow)

Este é o processo-padrão para **todas** as contribuições.

### Passo 1: Início da Tarefa

1.  **Sincronize sua `master` local** com a `master` do fork do grupo:
    ```bash
    git checkout main
    git pull origin main
    ```
2.  **Crie sua nova branch** a partir da `master` usando a nomenclatura correta:
    ```bash
    git checkout -b bdd/nome-da-minha-tarefa
    ```

### Passo 2: Trabalho Local

1.  Faça seu trabalho.
2.  Faça seus commits usando a nomenclatura correta:
    ```bash
    git add .
    git commit -m "spec: Adiciona cenário feliz para minha tarefa"
    ```
3.  Envie sua branch para o repositório (fork do grupo):
    ```bash
    git push origin spec/nome-da-minha-tarefa
    ```

### Passo 3: Pull Request (PR)

1.  No GitHub, abra um **Pull Request**.
2.  Preencha o template do PR (veja seção 6).
3.  **Importante:** Atribua pelo menos **um colega** do grupo como "Reviewer".
4.  O PR **não deve** ser "mergeado" até que o Reviewer aprove.

## 5. Fluxo Específico: Sprint 1 (Entrega BDD)

Para a entrega da Sprint 1, o fluxo tem uma particularidade:

1.  O **ScrumMaster (SM)** criará uma branch chamada `sprint-1` a partir da `main` do fork do grupo.
2.  **Todos os membros** seguem o **Passo 1 e 2** da seção 4 (criando suas branches `bdd/` a partir da `main`).
3.  **Pull Request (Interno):** Ao abrir o Pull Request (Passo 3), a **base** (branch de destino) **NÃO** será a `main`, mas sim a branch `sprint-1`.
    * **De:** `bdd/login-de-usuario`
    * **Para:** `sprint-1`
4.  Após todos os PRs serem revisados e mergeados na `sprint-1`, um membro (ex: SM) fará o **Pull Request Final** para o professor:
    * **De:** `nosso-fork/sprint-1`
    * **Para:** `EngSwCIC/CAMAAR:main`

## 6. Fluxo Específico: Sprints Futuras (Implementação)

Após a Sprint 1, nosso fluxo voltará ao normal:

* **De:** `feature/nome-da-feature`
* **Para:** `main` (do fork do grupo)

A `main` do nosso fork será a nossa base de código estável.

## 7. Template de Pull Request

Ao criar um Pull Request, use este template na descrição.

```markdown
### O que foi feito?
(Descreva em poucas linhas o que este PR entrega. Ex: "Implementa os cenários BDD para a feature de Login de Usuário".)

### Como testar?
(Descreva os passos para o "Reviewer" validar seu trabalho. Ex: "1. Leia o arquivo `features/login.feature` e verifique se os cenários feliz e triste estão presentes.")

### Issue Relacionada
(Link para a User Story/Issue do GitHub que este PR resolve.)

- Resolve #[número_da_issue]