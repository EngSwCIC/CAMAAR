Funcionalidade: Visualização de formulários para responder
  Como docente ou discente
  Quero visualizar os formulários que foram atribuídos a mim
  Para saber quais avaliações estão disponíveis e respondê-las dentro do prazo

  @feliz
  Cenário: Nenhum formulário disponível para o usuário
    Dado que estou logado como discente
    E que nenhum formulário está atribuído a mim
    Quando acesso a aba "Formulários disponíveis"
    Então vejo a mensagem "Nenhum formulário disponível no momento"

  @feliz
  Cenário: Ver formulários disponíveis para resposta
    Dado que estou logado como discente
    Quando acesso a aba "Formulários disponíveis"
    Então vejo uma lista com os formulários direcionados a mim
    E cada item mostra título, prazo final e status (aberto ou encerrado)
    E consigo clicar em "Responder" se o formulário ainda estiver ativo

  @feliz
  Cenário: Ver apenas formulários do perfil do usuário
    Dado que estou logado como docente
    Quando acesso minha lista de formulários
    Então vejo apenas formulários configurados para docentes
    E não vejo formulários direcionadosa discentes


  @feliz
  Cenário: Formulário já respondido
    Dado que já respondi ao formulário "Avaliação da Disciplina 2025/1"
    Quando acesso a lista de formulários
    Então esse formulário aparece com o status "Respondido"
    E a opção "Responder" está desabilitada ou oculta