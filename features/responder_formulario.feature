# language: pt
#2 pontos

Funcionalidade: Responder formulário #99
Eu como Participante de uma turma
Quero responder o questionário sobre a turma em que estou matriculado
A fim de submeter minha avaliação da turma

Contexto:
Dado que um Administrador está logado
E está na tela ‘formulário da turma’
E o participante possui um formulário disponível para responder

@99.1
Cenário: 99.1 – Quando um Participante preenche e envia corretamente o formulário, o sistema deve registrar as respostas no banco de dados e confirmar o envio.

Quando o participante preenche todas as perguntas obrigatórias do formulário
E envia o formulário
Então o sistema deve registrar as respostas no banco de dados
E exibir mensagem de confirmação de envio

@99.2
Cenário: 99.2 – Quando um Participante tenta enviar o formulário sem completar todas as perguntas obrigatórias, o sistema deve impedir o envio e informar sobre perguntas pendentes.

Quando o participante tenta enviar o formulário
E existem perguntas obrigatórias não preenchidas
Então o sistema deve impedir o envio
E exibir mensagem informando que existem perguntas obrigatórias não respondidas

@99.3
Cenário: 99.3 – Quando um Participante envia o formulário mas ocorre erro no banco de dados, o sistema deve exibir mensagem de erro e não registrar as respostas.

Quando o participante envia o formulário após preenchê-lo corretamente
Mas ocorre um erro ao tentar salvar as respostas no banco de dados
Então o sistema deve impedir o registro das respostas
E exibir mensagem de erro ‘falha_ao_salvar_respostas’
