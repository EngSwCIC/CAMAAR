# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

# Gerar relatório sobre as avaliações dos alunos
#6

- Eu como aluno
- Quero saber sobre as avaliações das minhas turmas
- A fim de avaliar o desempenho das turmas em que estou matriculado

## Escopo:
### Justificativa:
O sistema atual não possui relatórios para os alunos.

### Finalidade:
Implementar uma tela de relatórios e suas funcionalidades.

### Objetivo do projeto:
- Mostrar os relatórios dos alunos de cada turma
- Filtrar os realatórios por profesor, disciplina, semestre, professor, turma.
- Baixar relatório gerado

### Stackholders do projeto:
- Patrocinadora - Genaina
- Cliente - Marcus Vinícius Lamar
- Equipe do projeto - Mateus Luis Oliveira, Gabriel ligoski, Gustavo Rodrigues Gualberto, Thiago Elias dos Reis, Felipe Farias da Costa

### Entregas do projeto (Features):
- Manual do usuário da tela de geração de relatórios.
  - TimeComplexity: 2
- Filtrar por semestre, por professor, turma etc.
  - TimeComplexity: 3
- Tela de vizualização das avaliações de turmas.
  - TimeComplexity: 5
- Gerar relatório PDF de acordo com as informações pesquisadas.
  - TimeComplexity: 8

### Estimativas de Tempo e Custo:
Prazo estimado: 5 semanas
Custo estimado: 0


## Roles:
### Scrum Master:
- Mateus Luis Oliveira 180112490

### Product Owner:
- Gabriel ligoski 190087498

### Developer's:
- Gustavo Rodrigues Gualberto 190108266
- Thiago Elias dos Reis 190126892
- Felipe Farias da Costa 190027592

## Business Rules:
-  Manual do usuário da tela de geração de relatórios:
Caso os usuários tenham dúvidas sobre o funcionamento, ou todas as funcionalidades presentes na parte de geração de relatórios, o Manual do usuário     existe para sanar essas dúvidas, de forma simples e direta, nele é apresentado um guia passo a passo de como encontra as funcionalidades e como gerar seus possíveis resultados.
 
- Filtrar por semestre, por professor, turma etc:
Dado que o nosso trabalho está ligado a gerar relatório sobre as avaliações dos alunos e os possíveis desdobramentos dessa ideia principal, temos que possibilitar que o aluno filtre a pesquisa que ele deseje, dessa forma essa funcionalidade tem por objetivo facilitar tal ato, dijitando em um campo específico predeterminado e posteriormente clicando em "pesquisar" gerando e mostrando, de forma tabelar, os resultados.
  
- Tela de vizualização das avaliações de turmas:
Tal funcionalidade permite ao usuário vizualizar, na própria tela, os resultados e os dados das avaliações das turmas, de forma simples e intuitiva, para auxiliar o aluno em suas possíveis dúvidas e anseios. 
   
- Gerar relatório PDF de acordo com as informações pesquisadas:
Dado que os dados, após uma pesquisa e posterior visualização do aluno, estam disponiveis, pode-se ser desejo do usuário gerar um arquivo separado em diferentes formatos. Está funcionalidade promete atender a esse problema para dar ao usuário possíbilidades.

## Responsabilities:
- Tela de vizualização das avaliações de turmas. - Felipe
- Filtrar por semestre, por professor, turma etc. - Gabriel
- Manual do usuário da tela de geração de relatórios. - Gustavo
- Gerar relatório PDF de acordo com as informações pesquisadas. - Mateus

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
