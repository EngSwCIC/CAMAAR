Funcionalidade: Editar e deletar templates de formulário
  Como administrador do sistema
  Quero organizar e restringir o gerenciamento de formulários/templates por departamento
  Para garantir que cada coordenador visualize e edite apenas os dados do seu curso ou setor

   @feliz
  Cenário: Coordenador visualiza apenas formulários do seu departamento
  Dado que estou logado como coordenador do Departamento de Engenharia
  Quando acesso a área de gerenciamento de formulários
  Então vejo apenas os formulários e templates criados pelo meu departamento
  E não tenho acesso aos dados de outros cursos

  @feliz
  Cenário: Administrador visualiza formulários de todos os departamentos
  Dado que estou logado como administrador
  Quando acesso a aba de "Formulários" ou "Templates"
  Então posso visualizar, editar ou excluir formulários de todos os departamentos

@feliz
  Cenário: Filtro por departamento na listagem de formulários
  Dado que estou na tela de listagem de formulários
  Quando seleciono o filtro "Departamento: Direito"
  Então vejo apenas os formulários relacionados ao Departamento de Direito

  @triste
  Cenário: Coordenador tenta formulário de outro departamento via link direto
  Dado que estou logado como coordenador do Departamento de Letras
  E que recebi o link li direto para um formulário do Departamento de Medicina
  Quando tento acessá-lo
  Então recebo a mensagem "Acesso não autorizado - este formulário pertence a outro departamento"


 