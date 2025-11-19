# language: pt
# features/responder_formulario.feature

Funcionalidade: Responder Formulário de Avaliação
  Eu como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

Contexto:
  Dado que eu sou um "participante" logado como "aluno.joao"
  E eu estou matriculado na turma "Banco de Dados - TB"
  E existe um formulário "Avaliação BD 2025.1" para a turma "Banco de Dados - TB"
  E o formulário "Avaliação BD 2025.1" tem a pergunta "O professor domina o conteúdo?" do tipo "numérica (1-5)"

@happy_path
Cenário: Participante responde um formulário pendente
  Dado que eu não respondi o formulário "Avaliação BD 2025.1" ainda
  E eu estou na minha página inicial (dashboard)
  Quando eu vejo "Avaliação BD 2025.1" na minha lista de "Formulários Pendentes"
  E eu clico em "Responder"
  Então eu sou redirecionado para a página do formulário
  Quando eu seleciono "5" para a pergunta "O professor domina o conteúdo?"
  E eu clico no botão "Submeter Respostas"
  Então eu devo ser redirecionado para a minha página inicial
  E eu devo ver a mensagem "Avaliação enviada com sucesso. Obrigado!"
  E "Avaliação BD 2025.1" deve aparecer na minha lista de "Formulários Respondidos"

@sad_path
Cenário: Participante tenta responder um formulário que já respondeu
  Dado que eu já respondi o formulário "Avaliação BD 2025.1"
  E eu estou na minha página inicial (dashboard)
  Quando eu vejo "Avaliação BD 2025.1" na minha lista de "Formulários Respondidos"
  E eu tento acessar a página do formulário "Avaliação BD 2025.1" diretamente
  Então eu devo ser redirecionado para a minha página inicial
  E eu devo ver a mensagem "Você já respondeu este formulário."

@sad_path
Cenário: Participante tenta responder um formulário após a data de encerramento
  Dado que o formulário "Avaliação BD 2025.1" expirou em "01/12/2025"
  E eu não respondi o formulário "Avaliação BD 2025.1" ainda
  E eu estou na minha página inicial (dashboard)
  Quando eu tento acessar a página do formulário "Avaliação BD 2025.1"
  Então eu devo ser redirecionado para a minha página inicial
  E eu devo ver a mensagem "Este formulário não está mais aceitando respostas."