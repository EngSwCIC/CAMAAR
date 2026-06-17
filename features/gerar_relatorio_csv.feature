# encoding : UTF-8
# language: pt

Funcionalidade: Download de resultados de formulário em CSV
        Eu, como Administrador
        Quero baixar um arquivo csv contendo os resultados de um formulário
        A fim de avaliar o desempenho das turmas

  Contexto:
    Dado que estou na página de Resultados
    E vejo os formulários enviados para todas as turmas do meu departamento
    E existe a "Turma A" de "Estruturas de Dados" que possui um formulário associado a ela
    E este formulário já possui respostas enviadas pelos alunos

  Cenário: Baixar resultados do formulário com sucesso (happy path)
    Quando eu sigo "Baixar Resultado"
    Então o download do arquivo "formulario da Turma A de Estruturas de Dados" é iniciado
    E o arquivo deve conter as colunas Usuário da Resposta, Data de Submissão e elementos do formulário
    E o arquivo deve conter como linhas as respostas de cada usuário

  Cenário: Tentar baixar CSV de um formulário que não possui respostas (sad path)
    Dado que a "Turma A" possui outro formulário
    E este formulário não recebeu nenhuma resposta até o momento
    Quando eu sigo "Baixar Resultado"
    Então vejo a mensagem de erro "Falha na exportação: Este formulário ainda não possui respostas registradas."
    E nenhum download de arquivo é iniciado