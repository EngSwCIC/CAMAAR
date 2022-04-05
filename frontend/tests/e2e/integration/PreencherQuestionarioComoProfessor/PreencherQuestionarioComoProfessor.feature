#language: pt
Funcionalidade: Preencher questionário de avaliação como docente a fim de submeter dados de avaliação da minha turma

Contexto: Logado como EDNA DIAS CANEDO

Cenário: Preencher questionário de avaliação com dados válidos
Dado que acesso tela de questionário de avaliação
Quando eu selecionar a turma "BANCOS DE DADOS (GRADUAÇÃO) - Turma A - EDNA DIAS CANEDO"
E selecionar "5" em todas as perguntas em escala numérica
E marcar "Seminários" para metodologia de avaliacao
E marcar "Não estou aferindo" para metodologia de frequencia
E confirmar
Então o sistema deve confirmar o registro do questionário

Cenário: Preencher questionário de avaliação com dados inválidos
Dado que acesso tela de questionário de avaliação
Quando eu selecionar a turma "BANCOS DE DADOS (GRADUAÇÃO) - Turma A - EDNA DIAS CANEDO"
E selecionar "5" em todas as perguntas em escala numérica
E marcar "Outro" para metodologia de avaliacao
E confirmar
Então o sistema deve apresentar mensagem "Campos não preenchidos"

Cenario: Tentar avaliar mais de três turmas
Dado que eu avaliei três turmas
Quando acesso tela de questionário de avaliação
Então o sistema deve apresentar a mensagem "Número máximo de turmas avaliado"

