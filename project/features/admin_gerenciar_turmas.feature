# language: pt
Funcionalidade: Gerenciamento de Turmas por Departamento

  Como um Administrador
  Quero gerenciar somente as turmas do departamento o qual eu pertenço
  A fim de avaliar o desempenho das turmas no semestre atual

  Cenário: Listagem de turmas filtrada com sucesso pelo departamento do Administrador
    Dado que eu acesse a tela de "Gerenciamento de Turmas"
    Quando o sistema carregar a página para o semestre atual
    Então eu devo visualizar apenas as turmas pertencentes ao "Departamento de Ciências da Computação"
    E não devo visualizar turmas de outros departamentos (como "Matemática")
    E o sistema deve liberar as opções de avaliação de desempenho para as turmas listadas

  Cenário: Tentativa de acesso direto a uma turma de outro departamento via URL/ID
    Dado que eu tente acessar diretamente o painel da turma "Cálculo 1", que pertence ao "Departamento de Matemática"
    Quando o sistema validar minhas permissões de Administrador
    Então o sistema deve bloquear o meu acesso
    E deve redirecionar-me para a página inicial de gerenciamento
    E exibir a mensagem de erro: "Acesso negado. Você só pode gerenciar turmas do seu próprio departamento."

  Cenário: Administrador acessa o gerenciamento mas seu departamento não possui turmas no semestre atual
    Dado que o "Departamento de Ciências da Computação" não tenha nenhuma turma ofertada ou ativa no semestre atual
    Quando eu acessar a tela de "Gerenciamento de Turmas"
    Então o sistema deve carregar a página sem registros de turmas
    E deve exibir a mensagem informativa: "Nenhuma turma encontrada para o seu departamento no semestre atual."