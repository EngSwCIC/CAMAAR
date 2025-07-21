#language: pt

Funcionalidade: Criar templates para formulários
  Eu como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Contexto:
    Dado que eu estou logado como admin
    E que eu estou na página de gerenciamento de templates do CAMAAR

  Cenário: Criação do template com sucesso (HAPPY)
    E que existe(m) 0 template(s)
    Quando eu clicar no botão "+"
    E eu preencher o template
    E eu clicar no botão "Criar"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver 1 template(s)

  Cenário: Preenchimento incompleto de informações para criar template (SAD)
    Quando eu clicar no botão "+"
    E eu não preencher o template
    E eu clicar no botão "Criar"
    Então eu devo ver "Todas as perguntas devem ser definidas"