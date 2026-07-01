# language: pt
Funcionalidade: Admin editar e deletar templates criados

  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Cenário: Edição de um template criado mantendo isolamento
    Dado que eu editei informações de um template existente
    Quando eu pressionar o botão "Confirmar edição" na tela de edição
    Então eu devo visualizar as alterações no template na tela de templates
    E os formulários criados usando a versão antiga não devem sofrer alterações nas suas questões

  Cenário: Deleção de um template criado
    Dado que eu escolhi um template na minha lista
    Quando eu pressionar o botão de "Deletar"
    E confirmar a deleção pressionando o botão "Confirmar"
    Então esse template não deve aparecer mais na tela de templates
    E os formulários gerados por ele devem permanecer intactos no sistema

  Cenário: Tentar adicionar questão com campo vazio durante edição
    Dado que estou na página de edição do template
    Quando eu clico no botão '+'
    E não preencho o campo 'Enunciado da questão:'
    E clico no botão 'Confirmar edição'
    Então deve aparecer uma mensagem 'A nova questão não possui enunciado'