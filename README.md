# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

[Link desse repositorio](https://github.com/majuhdl/CAMAAR/)

## Implementações do grupo 1 - Issues 38 e 39

As implementações foram feitas por Maria Júlia Dias Lima - 170151140, sendo elas as páginas de menu de aluno, de coordenador e de professor. O Péricles Junior de Carvalho - 180129520 forneceu ajuda como PO nas implementações.

As implementações foram feitas de acordo com o modelo [Figma](https://www.figma.com/file/4cnolfAnxiO6uXLYkSMARt/Untitled) feito pelo Caio (monitor).

A página de aluno se encontra no endpoint /aluno. A página .vue se encontra na pasta /frontend/src/pages/menuAluno. No arquivo HomePageAluno.vue temos o menu geral do aluno, que possui a funcionalidade de exibir um menu lateral com o botão "Questionários" e uma página de abertura identificando o Aluno como Aluno. Na página de "Questionários", SurveysPageAlunos, temos um redirecionamento para a página de surveys, para mostrar os questionários do aluno e foi acrescentado no menu lateral um botão de "Voltar", que retorna ao menu principal.

A página de professor se encontra no endpoint /prof. A página .vue se encontra na pasta /frontend/src/pages/menuProfessor. No arquivo HomePageProfessor.vue temos o menu geral do professor, que possui a funcionalidade de exibir um menu lateral com o botão "Questionários" e o botão "Relatórios" e uma página de abertura identificando o Professor como Professor. Na página de "Questionários", SurveysPageProfessor, temos um redirecionamento para a página de surveys, para mostrar os questionários do professor e foi acrescentado no menu lateral um botão de "Voltar", que retorna ao menu principal. Na página de Relatórios, temos um redirecionamento para os relatórios do professor, no endpoint /student-subjects/. Não consegui integrar essa página na minha solução, então ele apenas redireciona para o endpoint já existente.

A página de coordenador se encontra no endpoint /. A página .vue se encontra na pasta /frontend/src/pages/menuCoordenador. No arquivo HomePageCoordenador.vue temos o menu geral do coordenador, que possui a funcionalidade de exibir um menu lateral com o botão "Questionários", o botão "Relatórios" e o botão de "Importar do SIGAA" e uma página de abertura identificando o Coordenador como Coordenador. Na página de "Questionários", SurveysPageCoordenador, temos um redirecionamento para a página de surveys, para mostrar os questionários do coordenador e foi acrescentado no menu lateral um botão de "Voltar", que retorna ao menu principal. Na página de Relatórios, temos um redirecionamento para os relatórios do coordenador, no endpoint /student-subjects/. Não consegui integrar essa página na minha solução, então ele apenas redireciona para o endpoint já existente. O botão de "Importar do SIGAA" tem funcionalidade similar e redireciona ao endpoint /import.

Foram feitos testes de e2e e unitários no frontend. Os testes e2e estão em /frontend/tests/e2e/integration, nas pastas menuAluno, menuCoordenador e menuProfessor. Todos eles fazem basicamente a mesma coisa, que é abrir a págin e ter certeza que os botões estão lá e o surveys redireciona para surveys e o voltar volta para a página principal. Os testes unitários estão em /frontend/unit/__tests__, sob nome meuAluno.spec.js, meuCoordenador.spec.js e meuProfessor.spec.js. Aqui testamos se estamos na página correta, se a página possui título, segundo título identificando o role do usuário respectivamente e se todos os botões que queremos estão lá. 

No backend, foi feita uma tentativa de criar um teste utilizando o factory bot para mockar o survey e a sua criação, mas não está 100% funcional. Ela se encontra em /backend/spec/controllers/surveys_controller_sprec.rb e os factories estão em /backend/spec/factory.
