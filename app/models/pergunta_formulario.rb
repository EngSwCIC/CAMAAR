class PerguntaFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta, optional: true

  enum :tipo_pergunta, { radio: 1, discursiva: 2 }
  enum :gabarito_radio, { 
    sem_gabarito: 0, opcao_a: 1, opcao_b: 2, opcao_c: 3, opcao_d: 4, opcao_e: 5,
    opcao_f: 6, opcao_g: 7, opcao_h: 8, opcao_i: 9, opcao_j: 10
  }
end
