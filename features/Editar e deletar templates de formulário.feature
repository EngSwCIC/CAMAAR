Funcionalidade: Editar e deletar templates de formulário
  Como administrador
  Quero  poder editar ou excluir templates criados anteriormente
  Para corrigir, atualizar ou remover modelos que não serão mais utilizados

  @feliz
  Cenário: Editar template com sucesso
    Dado que estou logado como administrador
    E que tenho um template chamado "Avaliação Docente 2025/1"
    Quando  clico em "+"
    E altero o título e adiciono uma nova pergunta
    Então o sistema salva as alterações
    E o template atualizado aparece na lista de templates

  @feliz
  Cenário:Excluir template não utilizado
    Dado que tenho um template que ainda não foi utilizado em nenhum formulário
    Quando clico em "Excluir"
    E confirmo a exclusão na janela de alerta
    Então o template é removido do sistema
    E não aparece mais na lista de templates disponíveis

  @triste
  Cenario: Tentar excluir template já utilizado em formulários
  Dado que o template "Avaliação Geral 2024" já foi usado em um ou mais formulários
  Quando tento exclui-lo
  Então recebo a mensagem "Este template já foi utilizado em formulários e não pode ser excluído"
  E o sistema bloqueia a ação de exclusão
