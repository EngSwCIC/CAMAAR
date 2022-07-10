##
# Essa classe representa o model ActiveRecord que armazena o questionário que será 
# respondido pelos membros do corpo dicente para cada Cclass em que estão matriculados

class Survey < ApplicationRecord
  belongs_to :role
  has_many :survey_questions, dependent: :destroy
  has_many :survey_answers, dependent: :destroy
  accepts_nested_attributes_for :survey_questions

  ##
  # Método que verifica se a um +Survey+ está fora da validade.
  #
  # Retorna +true+ caso +expiration_date+ seja _menor_ que a data atual e
  # retorna +false+ caso +expiration_date+ seja _maior_ que a data atual.
  def is_expired?
    self.expiration_date <= DateTime.now
  end

  def as_json(options: {})
    super(
      only: [
        :name, 
        :description, 
        :expiration_date, 
        :semester,
        :role_id
      ],
      include: [
        :survey_questions => {
          only: [:question_number, :question, :optional, :question_type_id],
          include:[
            :question_options => {
              only: [:option, :content]
            },
            :likert_scale_questions => {
              only: [:question_number, :question, :scale_points]
            }
          ]
        }
      ],
    )
  end

end
