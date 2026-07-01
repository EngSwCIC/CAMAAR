Feature: Exportar resultados de formulário em CSV
  Como um Administrador
  Quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Background:
    Dado que estou logado no sistema como Administrador
    E estou na página de resultados de formulários

  Cenário: Baixar arquivo CSV com sucesso (caminho feliz)
    Dado que o formulário "Avaliação Docente 2026" possui respostas registradas
    Quando eu solicitar o download do arquivo CSV
    Então o sistema deve gerar um arquivo CSV com os resultados do formulário
    E o download do arquivo deve ser iniciado com sucesso

  Cenário: Tentar baixar resultados de um formulário sem respostas (caminho triste)
    Dado que o formulário "Avaliação Docente 2026" não possui respostas registradas
    Quando eu solicitar o download do arquivo CSV
    Então o sistema não deve gerar o arquivo CSV
    E eu devo ver "Não existem respostas para exportar"
