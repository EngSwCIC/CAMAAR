#language: pt

Funcionalidade: Questões do tipo Likert

# Como um avaliador
# Eu quero escolher uma resposta na escala 
# Para poder expressar as minhas opniões em uma escala de 1 a 5 

@happy_path
Cenario: Todos os itens informados
Dado que eu estou na página de avaliação
Quando eu seleciono todos os campos obrigatórios
E clico no botão "submitAnswer"
Então eu devo ver a mensagem "Resposta enviada com sucesso!"

@sad_path
Cenario: Todos os itens informados
Dado que eu estou na página de avaliação
Quando eu seleciono todos os campos obrigatórios
E clico no botão "submitAnswer"
Então eu devo ver a mensagem "Falha ao enviar resposta."

@happy_path
Cenario: Itens obrigatórios faltantes
Dado que eu estou na página de avaliação
Quando eu não seleciono todos os itens obrigatórios
E clico no botão "submitAnswer"
Então eu devo ver a mensagem "Falha ao enviar resposta. Responda todas as perguntas obrigatórias."

@sad_path
Cenario: Itens obrigatórios faltantes
Dado que eu estou na página de avaliação
Quando eu não seleciono todos os itens obrigatórios
E clico no botão "submitAnswer"
Então eu devo ver a mensagem "Falha ao enviar resposta."