# language: pt
Funcionalidade: Gerenciar opções de questões objetivas
  Como Administrador
  Quero criar, remover e reordenar opções de uma questão objetiva
  A fim de definir a ordem das alternativas exibidas no formulário

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador

  Cenário: Criar opções em questão objetiva
    Dado que existe o template "Avaliação com Opções" com a questão objetiva "Como você avalia a disciplina?" e as opções:
      | texto   |
      | Ruim    |
      | Regular |
    Quando adiciono as opções à questão "Como você avalia a disciplina?" do template "Avaliação com Opções":
      | texto     |
      | Boa       |
      | Excelente |
    Então a questão "Como você avalia a disciplina?" do template "Avaliação com Opções" deve conter as opções na ordem:
      | texto     |
      | Ruim      |
      | Regular   |
      | Boa       |
      | Excelente |

  Cenário: Remover opção de questão objetiva
    Dado que existe o template "Avaliação para Remoção de Opção" com a questão objetiva "Como você avalia a didática?" e as opções:
      | texto   |
      | Ruim    |
      | Regular |
      | Boa     |
    Quando removo a opção "Regular" da questão "Como você avalia a didática?" do template "Avaliação para Remoção de Opção"
    Então a questão "Como você avalia a didática?" do template "Avaliação para Remoção de Opção" deve conter as opções na ordem:
      | texto |
      | Ruim  |
      | Boa   |

  Cenário: Reordenar opções de questão objetiva
    Dado que existe o template "Avaliação para Reordenar Opções" com a questão objetiva "Como você avalia o professor?" e as opções:
      | texto     |
      | Ruim      |
      | Regular   |
      | Boa       |
      | Excelente |
    Quando reordeno as opções da questão "Como você avalia o professor?" do template "Avaliação para Reordenar Opções" para:
      | texto     |
      | Excelente |
      | Boa       |
      | Regular   |
      | Ruim      |
    Então a questão "Como você avalia o professor?" do template "Avaliação para Reordenar Opções" deve conter as opções na ordem:
      | texto     |
      | Excelente |
      | Boa       |
      | Regular   |
      | Ruim      |
