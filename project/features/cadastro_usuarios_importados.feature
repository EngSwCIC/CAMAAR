# language: pt
@auth @issue-100
Funcionalidade: Cadastrar Usuarios do Sistema
  Como administrador
  Quero cadastrar usuarios a partir dos dados importados do SIGAA
  Para que novos participantes recebam o link de definicao de senha e possam acessar o CAMAAR

  Contexto:
    Dado que existe um administrador autenticado do departamento "CIC"
    E que o arquivo "class_members.json" contem participantes da turma "CIC0097" no semestre "2021.2"

  Cenario: Administrador importa participantes novos e dispara definicao de senha
    Quando o administrador importa os participantes do SIGAA
    Entao o sistema deve cadastrar o usuario "Ana Clara Jordao Perna" com email "acjpjvjp@gmail.com" e matricula "190084006"
    E deve associar o usuario a turma "CIC0097" como participante discente
    E deve marcar o usuario como pendente de definicao de senha
    E deve enviar email com link de definicao de senha para "acjpjvjp@gmail.com"

  Cenario: Importacao nao duplica usuario ja cadastrado
    Dado que ja existe um usuario cadastrado com email "acjpjvjp@gmail.com" e matricula "190084006"
    Quando o administrador importa novamente os participantes do SIGAA
    Entao o sistema nao deve criar outro usuario com a matricula "190084006"
    E deve manter uma unica conta para o email "acjpjvjp@gmail.com"
    E deve atualizar os vinculos de turma quando necessario

  Cenario: Registro importado sem dados obrigatorios nao cria conta
    Dado que o arquivo de importacao contem um participante sem email ou matricula
    Quando o administrador importa os participantes do SIGAA
    Entao o sistema nao deve criar conta para o participante invalido
    E deve registrar a inconsistencia encontrada na importacao
    E deve continuar processando os demais participantes validos
