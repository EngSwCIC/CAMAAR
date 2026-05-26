Feature: Importar dados do SIGAA
Como um Administrador
Quero importar dados de turmas, matérias e participantes do SIGAA
A fim de alimentar a base de dados do sistema

Background:
Dado que estou logado no sistema como Administrador
E estou na página "Importar Dados do SIGAA"

Cenário: Importar dados com sucesso (caminho feliz)
Dado que as turmas, matérias e participantes não existem na base de dados
Quando eu solicitar a importação dos dados do SIGAA
Então o sistema deve importar as turmas com sucesso
E o sistema deve importar as matérias com sucesso
E o sistema deve importar os participantes com sucesso
E eu devo ver "Dados importados com sucesso"

Cenário: Tentar importar dados já existentes (caminho triste)
Dado que as turmas, matérias e participantes já existem na base de dados
Quando eu solicitar a importação dos dados do SIGAA
Então o sistema não deve duplicar os registros existentes
E eu devo ver "Os dados já existem na base de dados"
