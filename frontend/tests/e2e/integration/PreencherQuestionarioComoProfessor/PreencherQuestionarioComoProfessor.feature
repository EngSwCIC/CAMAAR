#language: pt
Funcionalidade: Preencher questionário de avaliação como docente a fim de submeter dados de avaliação da minha turma

Contexto: Logado como professor

Esquema do Cenário: Preencher questionário de avaliação com dados válidos
Dado que o usuário está na tela de preencher questionário de avaliação de turma
E que ele selecionou uma turma
Quando ele tiver terminado de selecionar todas as opções sobre o ensino da turma
Se tiver selecionado ao menos uma opção de metodologia avaliação
E tiver selecionado ao menos uma opção de metodologia de aferição de frequência
Quando ele clicar no botão "Finalizar Avaliação"
Então Devem ser enviados os dados do formulário

Cenário: Preencher questionário de avaliação com dados inválidos
Dado que o usuário está na tela de questionário de avaliação de turma
E que ele selecionou uma turma
Quando ele tiver terminado de selecionar todas as opções sobre o ensino da turma
Se tiver selecionado ao menos uma opção para metodologia de avaliação
Mas não tiver selecionado nenhuma opção para metodologia de avaliação de frequência
Quando ele clicar no botão "Finalizar Avaliação"
Então o sistema deve apresentar mensagem "Campos não preenchidos"

Cenario: Tentar avaliar mais de três turmas
Dado que eu avaliei três turmas
Quando acesso tela de questionário de avaliação
Então o sistema deve apresentar a mensagem "Número máximo de turmas avaliado"
