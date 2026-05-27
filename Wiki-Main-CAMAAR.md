# Wiki - Introdução Projeto

## 1. Identificação do Grupo

 [Projeto]: CAMAAR  
 [Sprint]: Sprint 1  
 [Repositório do fork]: (https://github.com/EngSwCIC/CAMAAR)
 [Kanban do projeto]: (https://github.com/users/yuri-sl/projects/7)  
 [Wiki do projeto]:(https://github.com/yuri-sl/CAMAAR/wiki)  
 [Protótipo no Figma](https://www.figma.com/design/5GVzfaJSBbcXmGvuvAi7WF/Camaar-2024.1?node-id=0-1&p=f)

### Integrantes

| Nome | Matrícula | Papel |
|---|---:|---|
| Arthur Souza Chagas | 221037385 | Dev |
| João Felipe Stein | 241039331 |Product Owner / Dev |
| Luidgi Varela Carneiro | 231011669 | Dev |
| Yuri Santana Lopes | 222009750 | Scrum Master Dev |
| João Vitor das Neves Romero | 221028546 | Dev |
---

## 2. Escopo do Projeto

O projeto **CAMAAR** tem como objetivo principal implementar um sistema de controle de turmas e alunos, com suporte à criação de formulários para serem respondidos por alunos ou professores e suporte para a importação de dados do SIGAA.


---

## 3. Organização da Equipe

### Scrum Master

O papel de **Scrum Master** foi exercido por:

**Nome:** Yuri Santana Lopes
**Matrícula:** 222009750

Responsabilidades:

- Organizar a comunicação do grupo;
- Acompanhar o andamento das tarefas;
- Auxiliar na remoção de impedimentos;
- Garantir que as entregas da Sprint fossem realizadas dentro do prazo;
- Verificar se a branch da Sprint continha apenas as alterações previstas para a entrega.

### Product Owner

O papel de **Product Owner** foi exercido por:

**Nome:** João Felipe Stein  
**Matrícula:** 241039331

Responsabilidades:

- Entender as necessidades do projeto;
- Priorizar as funcionalidades da Sprint;
- Validar se as histórias de usuário estavam alinhadas ao escopo;
- Auxiliar na definição das regras de negócio;
- Garantir que as funcionalidades especificadas estivessem relacionadas às necessidades dos usuários.

---

## Política de Branching

A política de branching adotada pelo grupo foi definida para organizar o desenvolvimento da Sprint e facilitar a abertura do Pull Request para o repositório principal.

### Branch principal (main)

A main contém a versão mais estável do projeto implementado.

A branch utilizada para a entrega da sprint 1 é a `sprint-1`. Paralelamente, a branch `main` foi mantida como branch principal do fork do grupo, contendo o estado base do projeto.

### Branch sprints

Cada sprint tem sua branch principal de trabalho. Todos os commits que forem necessários para o desenvolvimento de uma sprint são salvos na branch com o nome da referente sprint.

### Branches de funcionalidades

Cada feature implementada tem sua própria branch para permitir melhor versionamento e separação de atividades.
Cada integrante pode criar branches específicas para suas funcionalidades, seguindo o padrão:

```bash
feature/nome-da-funcionalidade
```

Exemplos:

```bash
feature/cadastro-usuario
feature/criacao-formulario
feature/resposta-questionarios
```