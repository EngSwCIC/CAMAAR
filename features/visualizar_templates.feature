#language: pt

Funcionalidade: Visualização dos templates criados
  Eu como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que eu estou logado como admin
    E que foram importados dados do SIGAA
    E que eu estou na página de gerenciamento do CAMAAR

  Cenário: Visualizar e editar templates como admin
    E que existem 2 templates
    Quando eu clicar no botão "Editar Templates"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver 2 templates

  Cenário: Não visualizar templates inválidos como admin
    E que existem 1 templates inválido
    Quando eu clicar no botão "Editar Templates"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E nenhum template deve ser exibido na lista
    E eu devo ver "Um ou mais templates estão incompatíveis e não podem ser visualizados"