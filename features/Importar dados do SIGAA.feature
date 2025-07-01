Funcionalidade: Importar dados do SIGAA
  Como administrador
  Quero importar dados acadêmicos (usuários, turmas, disciplinas) do SIGAА
  Para agilizar o cadastro e atualização das informações no sistema

  @feliz
  Cenário: Importar dados com sucesso via JSON
  Dado que estou logado como administrador
  E que tenho um arquivo JSON simulado com os dados da turma "Turma А - Engenharia 2025/1"
  Quando clico em "Importar dados do SIGAA" e seleciono o arquivo
  Então o sistema importa os usuários (discentes e docentes) com sucesso

  @feliz
  Cenário: Importar arquivo JSON com usuários já cadastrados
  Dado que o JSON contém alguns usuários já existentes no sistema
  Quando executo a importação
  Então o sistema ignora os duplicados com base no e-mail
  E adiciona apenas os novos usuários

  @triste
  Cenário: Importar JSON mal formatado
  Dado que estou tentando importar um arquivo JSON
  E que o arquivo está mal formatado (ex: falta de colchetes ou campos obrigatórios)
  Quando tento realizar a importação
  Então vejo a mensagem "Erro na importação: JSON inválido ou estrutura incorreta" 
  E nenhum dado é salvo no sistema
