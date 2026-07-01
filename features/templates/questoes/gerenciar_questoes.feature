# language: pt
Funcionalidade: Gerenciar questões do template
  Como Administrador
  Quero criar, remover e reordenar questões de um template
  A fim de definir a estrutura do formulário antes de publicá-lo

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema
    E que estou autenticado como administrador

  Cenário: Criar questões no template
    Quando envio o formulário do template "Avaliação com Questões" com as questões:
      | enunciado                      | tipo       |
      | Descreva os pontos positivos   | discursiva |
      | Descreva os pontos de melhoria | discursiva |
    Então o template "Avaliação com Questões" deve conter as questões na ordem:
      | enunciado                      |
      | Descreva os pontos positivos   |
      | Descreva os pontos de melhoria |

  Cenário: Remover questão do template
    Dado que existe o template "Avaliação para Remoção de Questão" com as questões:
      | enunciado             | tipo       |
      | Questão que permanece | discursiva |
      | Questão removida      | discursiva |
    Quando removo a questão "Questão removida" do template "Avaliação para Remoção de Questão"
    Então o template "Avaliação para Remoção de Questão" deve conter as questões na ordem:
      | enunciado             |
      | Questão que permanece |

  Cenário: Reordenar questões do template
    Dado que existe o template "Avaliação para Reordenar Questões" com as questões:
      | enunciado        | tipo       |
      | Primeira questão | discursiva |
      | Segunda questão  | discursiva |
      | Terceira questão | discursiva |
    Quando reordeno as questões do template "Avaliação para Reordenar Questões" para:
      | enunciado        |
      | Terceira questão |
      | Primeira questão |
      | Segunda questão  |
    Então o template "Avaliação para Reordenar Questões" deve conter as questões na ordem:
      | enunciado        |
      | Terceira questão |
      | Primeira questão |
      | Segunda questão  |
