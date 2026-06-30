class PerguntaFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta, optional: true

  # == Tipo da Pergunta
  # Define o tipo da Pergunta, de modo que as variáveis e views corretas sejam utilizadas:
  # * +radio+   :: Questão do tipo múltipla escolha. Utiliza as variáveis: enunciado, numero_opcoes, opcoes_radio e gabarito_radio 
  # * +discursiva+ :: Questão do tipo discursiva. Utiliza as variáveis: enunciado e gabarito_discursiva
  enum :tipo_pergunta, { radio: 1, discursiva: 2 }

  # == Gabaritos de Pergunta Radio
  # Enum para delimitar as opções de gabarito para perguntas do tipo Radio (Múltipla Escolha).
  # O valor +sem_gabarito+ (0) é usada caso o criador do formulário decidir que não exista um gabarito específico para questão.
  enum :gabarito_radio, { 
    sem_gabarito: 0, opcao_a: 1, opcao_b: 2, opcao_c: 3, opcao_d: 4, opcao_e: 5,
    opcao_f: 6, opcao_g: 7, opcao_h: 8, opcao_i: 9, opcao_j: 10
  }
end
