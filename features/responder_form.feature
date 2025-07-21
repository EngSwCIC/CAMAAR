#language: pt
Funcionalidade: Responder Formulário
Eu como participante de uma turma
Quero responder o questionário sobre a turma em que estou matriculado
A fim de submeter minha avaliação de turma

  Contexto:

  Cenário: Resposta bem-sucedida do aluno (HAPPY)
    Dado que eu estou logado como aluno
    E que existem 1 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Quando eu clicar no formulário "formulario1"
    E eu preencher o formulário
    E eu clicar no botão "Enviar"
    Então eu devo estar na página de avaliação do CAMAAR
    E eu devo ver "Resposta enviada com sucesso"


  Cenário: Envio de formulário incompleto pelo aluno (SAD)
    Dado que eu estou logado como aluno
    E que existem 1 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Quando eu clicar no formulário "formulario1"
    E eu clicar no botão "Enviar"
    Então eu devo ver "Todos os campos precisam ser preenchidos"


  Cenário: Resposta bem-sucedida do professor (HAPPY)
    Dado que eu estou logado como professor
    E que existem 1 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Quando eu clicar no formulário "formulario1"
    E eu preencher o formulário
    E eu clicar no botão "Enviar"
    Então eu devo estar na página de avaliação do CAMAAR
    E eu devo ver "Resposta enviada com sucesso"


  Cenário: Envio de formulário incompleto pelo professor (SAD)
    Dado que eu estou logado como professor
    E que existem 1 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Quando eu clicar no formulário "formulario1"
    E eu clicar no botão "Enviar"
    Então eu devo ver "Todos os campos precisam ser preenchidos"