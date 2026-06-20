class Pergunta < ApplicationRecord
  belongs_to :template_formulario

  has_many :resposta_perguntas
  has_many :pergunta_formularios
  has_many :formularios, through: :pergunta_formularios

  enum :tipo_pergunta, { radio: 1, discursiva: 2 }
  enum :gabarito_radio, { 
    sem_gabarito: 0, opcao_a: 1, opcao_b: 2, opcao_c: 3, opcao_d: 4, opcao_e: 5,
    opcao_f: 6, opcao_g: 7, opcao_h: 8, opcao_i: 9, opcao_j: 10
  }

  validates :tipo_pergunta, presence: { message: "Qual o tipo da pergunta?" }
  validates :enunciado, presence: { message: "Favor preencher campo do Enunciado."}

  validates :numero_opcoes, presence: { message: "Quantas opções de resposta?" }, if: :radio?
  validates :gabarito_radio, presence: { message: "Selecione uma opção para o gabarito." }, if: :radio?
  validates :opcoes_radio, presence: { message: "Opção(ões) sem descrição, favor preencher todos os campos."}, if: :radio?
end
