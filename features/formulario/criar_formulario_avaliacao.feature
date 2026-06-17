# language: pt
Funcionalidade: (#103) Criar formulário de avaliação
  Como um Administrador (usuario com perfil administrador)
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Cenário: Criação de formulário com parâmetros corretos (Caminho Feliz)
    Dado que eu estou logado como um "usuarios" cujo "perfil" é "administrador"
    E existe um "templates" ativo com "titulo" "Avaliação Semestral CIC"
    E existe uma "turmas" cadastrada com "codigo_turma" "TA" e "semestre" "2026.1"
    Quando preencho os campos do novo formulário selecionando o template e a turma
    E defino o "publico_alvo" como "discente"
    E defino a "data_inicio" para hoje e "data_limite" para daqui a 15 dias
    E defino o "status" como "aberto"
    E clico em "Criar Formulário"
    Então o sistema deve persistir um novo registro na tabela "formularios" vinculando o "criado_por_id" ao meu ID de usuário

  Cenário: Tentativa de agendamento com data limite inválida (Caminho Triste - Erro de Data)
    Dado que eu estou logado como um "usuarios" com "perfil" "administrador"
    Quando tento criar um "formularios" configurando a "data_limite" para um momento anterior à "data_inicio"
    E clico em "Criar Formulário"
    Então o model de "formularios" deve falhar nas validações de data
    E o registro não deve ser inserido no banco de dados

  Cenário: Tentativa de inserção com string estourando o limite de caracteres (Caminho Triste - Data Overflow)
    Dado que eu estou logado como um "usuarios" com "perfil" "administrador"
    Quando tento criar um "formularios" passando uma string de 50 caracteres para o campo "publico_alvo"
    Então o sistema deve barrar a requisição antes de violar o limite do banco de dados ("publico_alvo" limit: 20)
    E deve retornar um erro de comprimento de caracteres "Público alvo inválido ou muito longo"

  Cenário: Inserção associando a um template inexistente ou desativado (Caminho Triste - Regra de Negócio)
    Dado que existe um "templates" onde o atributo "ativo" é falso
    Quando o administrador tenta criar um "formularios" apontando para o "template_id" desse template desativado
    Então o sistema deve impedir a criação exibindo o alerta "Não é possível publicar formulários usando templates inativos"