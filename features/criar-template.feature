Feature: Criar um template de formulário contendo as questões do formulário
Eu como Administrador
Quero criar um template de formulário contendo as questões do formulário
A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

Scenario: Criar template de formulário com sucesso
Given O administrador está logado na página de formulários
When O administrador preenche/estiliza o nome do template e as questões
Then O sistema salva o novo template de formulário
And Exibe uma mensagem de confirmação que o template foi criado

Scenario: Falha ao criar o template por campos obrigatórios vazios
Given O administrador está logado na página de formulários
When O administrador tenta criar um template sem preencher todos os campos obrigatórios
Then O sistema impede a criação do template do formulário
And O sistema exibe uma mensagem informando que é necessário preencher todos os campos obrigatórios