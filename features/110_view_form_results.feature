# language: pt
# features/visualizacao_resultados_formularios.feature

Funcionalidade: Visualização de resultados dos formulários (#110)
  Como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Contexto:
    Dado que estou logado como um administrador válido

  @happy
  Cenário: Exibir a lista de formulários disponíveis
    Dado que existem formulários para o semestre atual:
      | título                        |
      | Avaliação Docente             |
      | Avaliação da Infraestrutura   |
    Quando eu acesso a página "resultados"
    Então devo visualizar os cards dos formulários "Avaliação Docente" e "Avaliação da Infraestrutura"
    E cada card exibe semestre, professor e total de respostas

  @happy
  Cenário: Acessar o detalhamento de um formulário com respostas
    Dado que existe o formulário "Avaliação Docente" com respostas enviadas
    Quando eu abro o card "Avaliação Docente"
    Então vejo o resumo consolidado com gráficos e estatísticas
    E devo ver a mensagem "Total de respostas: xx"
    E o botão "Exportar resultados" deve estar habilitado

  @happy
  Cenário: Buscar por professor ou título
    Dado que existem formulários com professor "Maria Silva"
    Quando eu pesquiso por "Maria"
    Então apenas os formulários relacionados a "Maria Silva" são exibidos

  @sad
  Cenário: Formulário sem respostas
    Dado que existe o formulário "Avaliação da Infraestrutura" sem nenhuma resposta
    Quando eu abro o card "Avaliação da Infraestrutura"
    Então vejo a mensagem "Ainda não há respostas disponíveis"
    E o botão "Exportar resultados" deve estar desabilitado

  @sad
  Cenário: Nenhum formulário cadastrado
    Dado que não existem formulários cadastrados
    Quando eu acesso a página "resultados"
    Então vejo a mensagem "Nenhum formulário disponível no momento"
    E não há cards exibidos

  @sad
  Cenário: Tentar acessar um formulário inexistente
    Quando eu acesso diretamente o endereço "resultados/FormularioInexistente"
    Então vejo a mensagem "O formulário solicitado não foi encontrado"
    E permaneço na página de resultados

  @sad
  Cenário: Busca sem correspondências
    Dado que existem formulários cadastrados
    Quando eu pesquiso por "termo-inexistente"
    Então vejo a mensagem "Nenhum resultado para a busca"
    E a lista de cards fica vazia

  @sad
  Cenário: Falha ao exportar resultados
    Dado que existe o formulário "Avaliação Docente" com respostas enviadas
    E o serviço de exportação está indisponível
    Quando tento exportar os resultados
    Então vejo a mensagem "Não foi possível gerar o arquivo. Tente novamente mais tarde."
    E nenhum arquivo é baixado
