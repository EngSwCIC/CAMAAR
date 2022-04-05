#language: pt
Funcionalidade: Preencher questionário de avaliação como docente a fim de submeter dados de avaliação da minha turma

Contexto: Logado como professor
Dado que o usuário possa acessar a tela de questionário de avaliação

Esquema do Cenário: Preencher questionário de avaliação com dados válidos
Dado que o usuário está na tela de preencher questionário de avaliação de turma
E que ele selecionou uma turma
Quando ele tiver terminado de selecionar todas as opções sobre o ensino da turma
Se tiver selecionado ao menos uma opção de metodologia avaliação
E tiver selecionado ao menos uma opção de metodologia de aferição de frequência
Quando ele clicar no botão "Finalizar Avaliação"
Então Devem ser enviados os dados do formulário
