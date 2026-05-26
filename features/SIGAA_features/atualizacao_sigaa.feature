# language: pt

Funcionalidade: Atualização da base de dados existente via SIGAA
  Como Administrador
  Para que eu possa corrigir a base de dados do sistema
  Eu quero atualizar a base de dados já existente com os dados atuais do SIGAA

  Contexto:
    Dado que estou autenticado no sistema com o perfil de administrador
    E a base de dados do CAMAAR já possui turmas cadastradas

  @cenario_feliz
  Cenário: Sincronização de alterações nas matrículas
    Quando eu solicito a atualização dos dados do SIGAA
    E um usuário alterou seu vínculo (trancamento ou nova matrícula) no sistema origem
    Então o sistema deve atualizar a tabela de matrículas correspondente para refletir o status atual
    E exibir a mensagem "Base de dados atualizada com sucesso"

  @cenario_triste
  Cenário: Conflito de atualização em formulário já respondido
    Dado que um discente já enviou uma resposta para um formulário de avaliação
    Quando eu solicito a atualização da base do SIGAA
    E o SIGAA informa que este aluno não está mais matriculado na turma
    Então o sistema deve manter o registro histórico da resposta intacto por segurança
    E apenas inativar o vínculo na turma pertinente, informando a ressalva no log de atualização

  @cenario_triste
  Cenário: Divergência severa de formato de dados
    Quando o SIGAA envia dados estruturais corrompidos durante a execução da rotina
    Então o sistema deve abortar a transação para manter a integridade da base
    E exibir a mensagem "Erro de compatibilidade de dados. Atualização cancelada."

  @cenario_triste
  Cenário: Tentativa de atualização concorrente
    Dado que o sistema está processando uma atualização de grande volume do SIGAA
    Quando outro administrador tenta iniciar o mesmo processo de atualização simultaneamente
    Então o sistema deve bloquear a segunda requisição
    E exibir a mensagem "Uma atualização já está em andamento. Aguarde a conclusão."