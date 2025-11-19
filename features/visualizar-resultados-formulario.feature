Feature: Visualização de resultados dos formulários
Eu como Administrador
Quero visualizar os formulários criados
Para poder gerar um relatório a partir das respostas

Scenario: Exibir formulários disponíveis
Given existem formulários criados
When o sistema carrega os formulários
Then exibe os resultados dos formulários
And permite ver os resultados

Scenario: O formulário carrega mas os resultados estão inacessíveis

Given existem formulários criados
When o sistema carrega os formulários 
Then os formulários são exibidos, porém sem a opção de visualizar os resultados
And o administrador não consegue gerar relatórios a partir dos dados
