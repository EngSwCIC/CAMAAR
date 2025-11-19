Feature: Responder formulário
Eu como Participante de uma turma
Quero responder o questionário sobre a turma em que estou matriculado
A fim de submeter minha avaliação da turma

Scenario: respostas enviadas
Given que o participante abriu o formulário pendente
When ele preenche todas as respostas obrigatórias 
Then e o sistema salva as respostas
And exibe mensagem de confirmação

Scenario: resposta incompleta
Given que o participante abriu o formulário 
When ele tenta enviar sem preencher os campos obrigatórios 
Then o sistema não salva a resposta 
And exibe uma mensagem de erro
