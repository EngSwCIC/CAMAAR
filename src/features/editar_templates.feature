# language: pt

# features/editar_templates.feature

Funcionalidade: Edição e exclusão de questões em templates
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

Contexto:
  Dado que estou na página de gerenciamento
  E seleciono o template com o campo nome "Template1" e o campo semestre "2025.2"
  E o template contém duas questões, sendo:
    | número | tipo  | texto                      | opções                     |
    | 1      | texto | texto para a questão 1     |                            |
    | 2      | radio | texto para a questão 2     | Opção 1, Opção 2, Opção 3  |
  E visualizo a página do template escolhido

#############################################################################
# EXCLUSÃO DE QUESTÕES
#############################################################################

@happy_path
Cenário: Excluir a questão 2 do template
  Quando eu clico no botão de exclusão ao lado da questão 2
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Excluir a questão 1 e renumerar as questões
  Quando eu clico no botão de exclusão ao lado da questão 1
  Então devo ver que a questão 2 migrou para a posição da questão 1
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@sad_path
Cenário: Tentar excluir todas as questões de um template
  Quando eu clico no botão de exclusão ao lado da questão 1
  E clico no botão de exclusão ao lado da (nova) questão 1
  E clico em salvar
  Então devo ver a mensagem "não é possível salvar template sem questões"
  E devo permanecer na página de edição do template

#############################################################################
# ALTERAÇÃO DO TIPO DA QUESTÃO
#############################################################################

@happy_path
Cenário: Alterar o tipo da questão 2 de radio para texto
  Dado que a questão 2 é do tipo "radio" com opções "Opção 1, Opção 2, Opção 3"
  Quando eu altero o tipo da questão 2 para "texto"
  E preencho o campo texto com "novo texto para questão 2"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Alterar o tipo da questão 1 de texto para texto (sem mudança real)
  Dado que a questão 1 é do tipo "texto"
  Quando eu altero o tipo da questão 1 para "texto"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Alterar o tipo da questão 1 de texto para radio
  Dado que a questão 1 é do tipo "texto"
  Quando eu altero o tipo da questão 1 para "radio"
  E preencho o campo texto com "novo texto para a questão 1"
  E preencho o campo Opções com "Opção A, Opção B, Opção C"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Alterar o tipo da questão 2 de radio para radio (sem mudança real)
  Dado que a questão 2 é do tipo "radio"
  Quando eu altero o tipo da questão 2 para "radio"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

#############################################################################
# ALTERAÇÃO DO CORPO DAS QUESTÕES
#############################################################################

@happy_path
Cenário: Alterar o texto da questão 1 (tipo texto) com valor válido
  Dado que a questão 1 é do tipo "texto"
  Quando eu altero o corpo para "novo corpo da questão 1"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Alterar o texto da questão 2 (tipo radio) com valor válido
  Dado que a questão 2 é do tipo "radio"
  Quando eu altero o texto da questão para "novo texto da questão 2"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@happy_path
Cenário: Alterar as Opções da questão 2 (tipo radio) com valor válido
  Dado que a questão 2 é do tipo "radio"
  Quando eu altero as opções da questão para "Opção 4, Opção 5, Opção 6"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"

@sad_path
Cenário: Alterar o texto da questão 1 (tipo texto) para valor nulo
  Dado que a questão 1 é do tipo "texto"
  Quando eu deixo o texto vazio
  E clico em salvar
  Então devo ver a mensagem "o texto da questão é obrigatório"

@sad_path
Cenário: Alterar o texto da questão 2 (tipo radio) para valor nulo
  Dado que a questão 2 é do tipo "radio"
  Quando eu deixo o campo texto vazio
  E clico em salvar
  Então devo ver a mensagem "o texto da questão é obrigatório"

@sad_path
Cenário: Alterar as Opções da questão 2 (tipo radio) para valor nulo
  Dado que a questão 2 é do tipo "radio"
  Quando eu deixo o campo Opções vazio
  E clico em salvar
  Então devo ver a mensagem "As opções da questão são obrigatórias"

#############################################################################
# ALTERAÇÃO DO TEXTO DA QUESTÃO
#############################################################################

@happy_path
Cenário: Alterar o texto da questão do tipo radio
  Dado que a questão 2 é do tipo "radio"
  Quando eu altero o texto da questão para "texto atualizado"
  E clico em salvar
  Então devo ver a mensagem "template alterado com sucesso"