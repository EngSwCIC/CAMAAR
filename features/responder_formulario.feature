# language: pt

Funcionalidade: Responder formulário
  Com o perfil de discente
  Quero preencher e enviar os formulários de avaliação
  A fim de registrar meu feedback sobre as disciplinas e docentes

  Cenário: [Feliz] Responder um formulário com todos os dados válidos
    Dado que eu estou logado no sistema CAMAAR como "discente" e matriculado na turma "CIC0097 - BANCOS DE DADOS"
    E eu estou na página de resposta do formulário desta turma
    Quando eu preencho todas as perguntas com respostas válidas
    E eu envio o formulário
    Então o sistema deve exibir a mensagem "Avaliação enviada com sucesso"
    E o formulário deve deixar de aparecer na minha lista de pendentes

  Cenário: [Triste] Tentar enviar um formulário com campos obrigatórios vazios
    Dado que eu estou logado no sistema CAMAAR como "discente" e matriculado na turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    E eu estou na página de resposta do formulário desta turma
    Quando eu deixo a pergunta "Avaliação do Docente" em branco
    E eu tento enviar o formulário
    Então o sistema deve exibir a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos"
    E o formulário não deve ser computado como respondido

  Cenário: [Triste] Tentar preencher o formulário com notas fora do intervalo permitido
    Dado que eu estou logado no sistema CAMAAR como "discente" e matriculado na turma "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    E eu estou na página de resposta do formulário desta turma
    Quando eu insiro o valor "6" em uma das perguntas de nota
    E eu tento enviar o formulário
    Então o sistema deve exibir a mensagem de erro "Por favor, insira um valor válido entre 1 e 5"
    E o formulário não deve ser computado como respondido

  Cenário: [Triste] Tentar responder novamente um formulário já enviado
    Dado que eu estou logado no sistema CAMAAR como "discente" e matriculado na turma "CIC0097 - BANCOS DE DADOS"
    E eu já enviei o formulário de avaliação desta turma anteriormente
    Quando eu tento acessar diretamente à página de resposta deste formulário
    Então o sistema deve exibir a mensagem de erro "Este formulário já foi respondido"
    E por fim não deve permitir nova submissão
