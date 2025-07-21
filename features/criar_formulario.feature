#language: pt
Funcionalidade: Criar formulário de avaliação
  Eu como Administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que eu estou logado como admin
    E que existe um template chamado "template_teste"
    E que existe uma matéria chamada "materia_teste"
    E que eu estou na página de envio do CAMAAR

  Cenário: Criação de um formulário de avaliação bem-sucedida (HAPPY)
    Quando eu escolher o template "template_teste"
    E eu selecionar a matéria "materia_teste"
    E eu clicar no botão “Enviar”
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Formulário enviado com sucesso"

  Cenário: Tentativa de criar um formulário sem selecionar um template (SAD)
    Quando eu selecionar a matéria "materia_teste"
    E eu clicar no botão “Enviar”
    Então eu devo ver "Nenhum template selecionado"

  Cenário: Tentativa de criar um formulário sem selecionar uma matéria (SAD)
    Quando eu escolher o template "template_teste"
    E eu clicar no botão “Enviar”
    Então eu devo ver "Nenhuma matéria foi selecionada"
