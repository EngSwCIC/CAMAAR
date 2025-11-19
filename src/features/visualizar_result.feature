# language: pt
# features/visualizacao_resultados_formularios.feature

Funcionalidade: Visualização de resultados dos formulários
  Eu como Administrador
  Quero visualizar os formulários criados
  A fim de gerar um relatório a partir das respostas

Contexto:
  Dado que eu sou um "admin" logado no sistema

@happy_path
Cenário: Visualizar lista de formulários disponíveis
  Dado que estou na página "dashboard"
  E existem os formulários "Avaliação Docente" e "Avaliação da Infraestrutura"
  Quando eu acesso a página "formularios"
  Então eu devo ver "Avaliação Docente"
  E eu devo ver "Avaliação da Infraestrutura"

@happy_path
Cenário: Baixar o CSV a partir da página do formulário com respostas disponíveis
  Dado que existe o formulário "Avaliação Docente"
  E ele possui 30 respostas
  Quando eu acesso a página "formularios/Avaliação Docente"
  Então eu devo ver um botão "Baixar CSV"
  E eu devo ver a mensagem "Total de respostas: 30"
  Quando eu clico no botão "Baixar CSV"
  Então o download do arquivo "avaliacao_docente.csv" deve iniciar

@sad_path
Cenário: Formulário existente, porém sem respostas cadastradas
  Dado que existe o formulário "Avaliação da Infraestrutura"
  E ele possui 0 respostas
  Quando eu acesso a página "formularios/Avaliação da Infraestrutura"
  Então eu devo ver a mensagem "Nenhuma resposta registrada para este formulário"
  E eu não devo ver o botão "Baixar CSV"

@sad_path
Cenário: Admin tenta baixar o arquivo CSV com os resultados de formulário inexistente
  Quando eu acesso a página "formularios/FormularioInexistente"
  Então eu devo ver a mensagem "Formulário não encontrado"
  E devo permanecer na página "formularios"

@sad_path
Cenário: Não há formulários cadastrados
  Dado que não existe nenhum formulário cadastrado
  Quando eu acesso a página "formularios"
  Então eu devo ver a mensagem "Nenhum formulário cadastrado"

