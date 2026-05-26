# language: pt
Funcionalidade: Edição e Deleção de Templates
  Como Administrador
  Quero poder editar ou excluir templates de formulário criados
  A fim de corrigir informações ou remover modelos obsoletos do sistema

  Contexto:
    Dado que o administrador está autenticado e na página de listagem de templates
    E existe um template chamado "Avaliação Antiga" cadastrado

  Cenário: Edição bem-sucedida do título de um template (Caminho Feliz)
    Quando o administrador clica no botão "Editar" do template "Avaliação Antiga"
    E altera o campo de título para "Avaliação Atualizada"
    E clica em "Salvar Alterações"
    Então o sistema deve atualizar o registro
    E exibir a mensagem "Template atualizado com sucesso"

  Cenário: Tentativa de edição removendo todas as questões (Caminho Triste)
    Quando o administrador clica no botão "Editar" do template "Avaliação Antiga"
    E remove todas as questões associadas ao modelo
    E clica em "Salvar Alterações"
    Então o sistema deve bloquear a ação
    E exibir a mensagem de validação "O template não pode ficar sem questões"

  Cenário: Exclusão bem-sucedida de um template sem uso (Caminho Feliz)
    Dado que o template "Avaliação Antiga" não está vinculado a nenhuma avaliação ativa
    Quando o administrador clica no botão "Excluir" do template
    E confirma a exclusão no pop-up de aviso
    Então o sistema deve remover o template do banco de dados
    E exibir a mensagem "Template excluído com sucesso"

  Cenário: Tentativa de excluir um template já utilizado em uma avaliação (Caminho Triste)
    Dado que o template "Avaliação Antiga" já foi usado para gerar um formulário para a turma de "Bancos de Dados"
    Quando o administrador clica no botão "Excluir" do template
    Então o sistema deve impedir a exclusão
    E exibir a mensagem de erro "Não é possível excluir um template que já possui formulários respondidos ou em andamento"