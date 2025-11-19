# language: pt
# features/gerar_relatorio.feature

Funcionalidade: Gerar Relatório de Respostas
  Eu como Administrador
  Quero baixar um arquivo csv contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

Contexto:
  Dado que eu sou um "admin" logado no sistema
  E existe um formulário "Avaliação EngSoft 2025.1"
  E o formulário "Avaliação EngSoft 2025.1" tem "15" respostas submetidas

@happy_path
Cenário: Admin baixa o relatório de um formulário com respostas
  Dado que eu estou na página de resultados do formulário "Avaliação EngSoft 2025.1"
  Quando eu clico no botão "Exportar para CSV"
  Então um download de um arquivo "relatorio_engsoft_2025.1.csv" deve ser iniciado
  # Testar o conteúdo do CSV é muito complexo para BDD,
  # então testamos apenas a ação de download.

@sad_path
Cenário: Admin tenta baixar relatório de um formulário sem respostas
  Dado que existe um formulário "Avaliação BD 2025.1"
  E o formulário "Avaliação BD 2025.1" tem "0" respostas submetidas
  E que eu estou na página de resultados do formulário "Avaliação BD 2025.1"
  Quando eu clico no botão "Exportar"
  Então eu devo ver a mensagem "Não é possível gerar um relatório, pois não há respostas."
  E nenhum download deve ser iniciado