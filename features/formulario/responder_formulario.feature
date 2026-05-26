# language: pt
Funcionalidade: (#99) Responder formulário
  Como um Participante de uma turma (usuario com matricula e matriculas ativa)
  Quero responder o questionário (formulario) sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Cenário: Submissão de formulário preenchido completamente (Caminho Feliz - Padrão)
    Dado que existe um "usuarios" com "perfil" "discente" e "matricula" "221037634"
    E esse usuário possui uma "matriculas" com "papel_na_turma" "discente" na "turmas" de "codigo_turma" "TA"
    E existe um "formularios" com "status" "aberto" e "publico_alvo" "discente" para esta turma
    E esse formulário possui uma "questoes_template" onde "obrigatoria" é verdadeiro e "tipo" é "texto"
    Quando o usuário acessa a página de resposta do formulário
    E preenche o campo correspondente com o "valor_texto" "Excelente metodologia de ensino."
    E clico em "Submeter Avaliação"
    Então o sistema deve criar um registro em "respostas" salvando o "enviado_em" com o timestamp atual
    E deve criar um registro em "resposta_itens" vinculado à questão

  Cenário: Submissão ignorando campo não obrigatório (Caminho Feliz - Opcional)
    Dado que existe um "usuarios" com "perfil" "discente" logado no sistema
    E existe um "formularios" ativo contendo uma "questoes_template" onde "obrigatoria" é falso e "tipo" é "texto"
    Quando o usuário acessa a página de resposta do formulário
    E deixa o "valor_texto" desta questão em branco
    E clico em "Submeter Avaliação"
    Então o sistema deve processar a resposta com sucesso descartando o registro em "resposta_itens" para esta questão em branco

  Cenário: Tentativa de envio deixando questão obrigatória vazia (Caminho Triste - Campo Ausente)
    Dado que existe um "usuarios" com "perfil" "discente" logado no sistema
    E existe um "formularios" ativo contendo uma "questoes_template" onde "obrigatoria" é verdadeiro
    Quando o usuário limpa ou deixa o campo de resposta vazio
    E clico em "Submeter Avaliação"
    Então o sistema não deve salvar registros nas tabelas "respostas" e "resposta_itens"
    E deve exibir o erro de validação "Preencha todos os campos obrigatórios"

  Cenário: Tentativa de responder o mesmo formulário duas vezes (Caminho Triste - Restrição de Unicidade)
    Dado que existe uma "respostas" salva contendo o "formulario_id" e o "usuario_id" do discente logado
    Quando o usuário tenta realizar uma nova requisição POST para submeter dados para o mesmo "formulario_id"
    Então o sistema deve bloquear a operação respeitando o índice único composto de "index_respostas_on_formulario_id_and_usuario_id"
    E deve exibir a mensagem de erro "Você já respondeu a este formulário"