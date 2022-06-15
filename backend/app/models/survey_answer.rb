##
# Essa classe representa o model ActiveRecord que armazena respostas às perguntas de
# Survey para cada par de Member e Cclass

class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :member
  belongs_to :cclass
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  validate :is_grad_student

  ##
  # Método que sobrescreve funcionalidade padrão de +as_json+ do +ActiveRecord+
  # a fim de incluir atributos de +Answers+ e +LikertAnswers+ aninhados

  def as_json(options: {})
    super(include: [:answers => {include: :likert_answers}])
  end

  private

  ##
  # Valida se +occupation+ do membro que está respondendo o Survey é do tipo _"dicente"_
  #
  # É chamada durante a execução do método +SurveyAnswer:save+.
  #
  # Adiciona um erro ao model caso +member.occupation != 'dicente'+ 

  def is_grad_student
    errors.add(:member, 'membro deve ser dicente') unless member&.occupation == 'dicente'
  end
end
