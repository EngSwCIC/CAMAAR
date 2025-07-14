Funcionalidade: Gerar relatório do administrador
  Como administrador
  Quero gerar relatórios com os dados das respostas aos formulários
  Para analisar os resultados das avaliações aplicadas a discentes e docentes

  @feliz
  Cenário: Gerar relatório filtrando por departamentoeperíodo
  Dado que estou na área de relatórios
  Quando seleciono o Departamento de Engenharia e o período "2025/1"
  Então o sistema me mostra todos os formulários aplicados nesse recorte
  E gera um relatório consolidado com os dados agrupados

  @feliz
  Cenário: Gerar relatório por formulário
  Dado que estou logado como administrador
  E que o formulário "Avaliação Docente 2025/1" já foi respondido
  Quando clico em "Gerar relatório" na aba de resultados desse formulário
  Então vejo um resumo com o total de respostas

  @triste
  Cenário: Tentativa de gerar relatório sem respostas
  Dado que estou acessando um formulário recém-criado
  E que ainda não possui nenhuma resposta registrada
  Quando tento gerar um relatório
  Então vejo a mensagem "Este formulário ainda não possui respostas para gerar relatório"
  E o botão de exportação permanece desabilitado
