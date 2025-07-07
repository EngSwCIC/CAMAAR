# language: pt

Funcionalidade: Gerenciamento de templates de formulários

  Como administrador
  Quero editar e/ou deletar um template que eu creiei sem afetar os formulários já criados
  Para organizar os templates existentes

  Cenário: Editar um template existente
    Dado que estou logado como administrador
    E estou na pagina de gerenciamento de templates
    E existe um template criado por mim
    Quando clico na opção 'Editar' do template
    Então devo modificar o nome, a descrição ou as perguntas do template
    E ao salvar, as mudanças não devem afetar formulários já criados com esse template

  Cenário: Deletar um template existente
    Dado que estou logado como administrador
    E estou na página de gerenciamento de templates
    E existe um template criado por mim
    Quando clico na opção "Deletar" do template
    Então o template deve ser removido da lista de templates disponíveis
    E os formulários que já foram criados com base nesse template devem permanecer inalterados
