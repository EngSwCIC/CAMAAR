# Gerar relatório sobre as avaliações dos alunos
#6

- Eu como aluno
- Quero saber sobre as avaliações das minhas turmas
- A fim de avaliar o desempenho das turmas em que estou matriculado

## Roles:
### Scrum Master:
- Mateus Luis Olivera

### Product Owner:
- Gabriel Ligoski

### Developer's:
- Gustavo
- Thiago
- Felipe

## Features:
- Filtrar por semestre, por professor etc.
- Pesquisar por turma.
- Manual do usuário da tela de geração de relatórios.
- Mostrar dados do aluno (frequência, menção…) na turma.
- Gerar relatório PDF de acordo com as informações pesquisadas.

## Business Rules:
- rule

## Responsabilities:
- rule

## Branching policy:
### *Git Flow*
> [https://medium.com/@patrickporto/4-branching-workflows-for-git-30d0aaee7bf#:~:text=own%20development%20cycle.-,Git%20Flow,-The%20Git%20Flow](url)

#### Branches:
- **master** — this branch contains production code. All development code is merged into master in sometime.
- **develop** — this branch contains pre-production code. When the features are finished then they are merged into develop.

#### Sub-Branches: 
- **feature-descricao-curta** — (escreve 'feature-' depois a descrição) feature branches are used to develop new features for the upcoming releases. May branch off from develop and must merge into develop.
- **hotfix-descricao-curta** — (escreve 'hotfix-' depois a descrição) hotfix branches are necessary to act immediately upon an undesired status of master. May branch off from master and must merge into master anddevelop.
- **release-descricao-curta** — (escreve 'release-' depois a descrição) release branches support preparation of a new production release. They allow many minor bug to be fixed and preparation of meta-data for a release. May branch off from develop and must merge into master anddevelop.
