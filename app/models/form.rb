# Formulário de avaliação baseado em um Template, enviado para turmas
class Form < ApplicationRecord
  belongs_to :template
  has_and_belongs_to_many :turmas

  validates :template, presence: true
  validates :destinatario, inclusion: { in: %w[discente docente] }
  validates :start_date, presence: { message: "As datas de vigência são obrigatórias" }
  validates :end_date, presence: { message: "As datas de vigência são obrigatórias" }
  validate  :end_date_apos_start_date

  # Retorna true se o formulário ainda está disponível para resposta
  #
  # Argumentos: Nenhum
  # Retorno: Boolean
  # Efeitos colaterais: Nenhum
  def active?
    end_date.nil? || end_date > Time.current
  end

  # Verifica se o formulário é destinado ao papel (role) do usuário informado
  #
  # Argumentos: user (User)
  # Retorno: Boolean
  def destinado_a?(user)
    return false if user.nil?

    destinatario == user.role
  end

  private

  # Garante que a data de término não seja anterior à data de início
  #
  # Argumentos: Nenhum (usa start_date e end_date)
  # Retorno: Nenhum
  # Efeitos colaterais: Adiciona erro em :end_date se inválido
  def end_date_apos_start_date
    return if start_date.blank? || end_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, "não pode ser anterior à data de início")
  end
end
