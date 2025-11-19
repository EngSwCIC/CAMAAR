Feature: Gerar relatório como administrador
Como Administrador
Quero baixar um arquivo csv contendo os resultados de um formulário
A fim de avaliar o desempenho das turmas

Scenario: Gerar relatório de formulários com respostas
Given que existe um formulário com respostas
When o administrador seleciona o formulário para gerar o relatório
Then o sistema gera o arquivo csv
And o download é iniciado automaticamente

Scenario: Tentar gerar relatório com formulário vazio
Given que existe um formulário sem respostas
When o administrador tenta gerar o relatório em csv
Then O sistema gera um arquivo, porém o conteúdo aparece vazio ou corrompido
And O sistema gera uma mensagem informando que o arquivo está vazio/corrompido
