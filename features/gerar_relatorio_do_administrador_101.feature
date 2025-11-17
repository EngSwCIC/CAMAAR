# language: pt

Funcionalidade: Gerar Relatório do Administrador
  Como Administrador do sistema
  Eu quero baixar um arquivo CSV contendo os resultados de um formulário
  Para que eu possa avaliar o desempenho das turmas

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E existe um formulário "Avaliação Semestral" para a turma "CIC0097"
    E o formulário possui 10 respostas de alunos

  # CENÁRIOS FELIZES

  Cenário: Baixar relatório em CSV com sucesso
    Dado que estou na página de gerenciamento de resultados
    Quando eu clico no formulário "Avaliação Semestral"
    Então o download do arquivo "avaliacao-semestral-cic0097.csv" deve iniciar
    E o arquivo deve conter os cabeçalhos das colunas
    E o arquivo deve conter as 10 respostas dos alunos
    E eu devo permanecer na página de gerenciamento de resultados

 # CENÁRIOS TRISTES

  Cenário: Tentar baixar relatório de formulário sem respostas
    Dado que estou na página de gerenciamento de resultados
    E existe um formulário "Avaliação Nova" sem respostas
    Quando eu clico nesse formulário
    Então eu devo ver a mensagem de aviso "Este formulário ainda não possui respostas"
    E o download do arquivo "avaliacao-nova-CIC0097.csv" deve iniciar
    E o arquivo deve conter os cabeçalhos das colunas
    E eu devo permanecer na página de gerenciamento de resultados