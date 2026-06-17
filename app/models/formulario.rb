class Formulario < ApplicationRecord
  self.table_name = "formularios"

  belongs_to :template
  belongs_to :turma
  belongs_to :criado_por, class_name: "Usuario", foreign_key: "criado_por_id"
  has_many :respostas, dependent: :destroy

  validates :publico_alvo, presence: { message: "Obrigatório: Selecione se o formulário é destinado a docentes ou discentes." }
  validates :publico_alvo, length: { maximum: 20, message: "Público alvo inválido ou muito longo" }

  validate :data_limite_after_data_inicio
  validate :template_must_be_active
  validate :turma_has_students_for_discente_form
  validate :no_active_form_for_same_public
  validates :data_inicio, presence: { message: "Data de início não pode ficar em branco" }
  validates :data_limite, presence: { message: "Data limite não pode ficar em branco" }

  private

  def data_limite_after_data_inicio
    return if data_inicio.blank? || data_limite.blank?
    if data_limite <= data_inicio
      errors.add(:data_limite, "deve ser posterior à data de início")
    end
  end

  def template_must_be_active
    if template.present? && !template.ativo
      errors.add(:template_id, "Não é possível publicar formulários usando templates inativos")
    end
  end

  def turma_has_students_for_discente_form
    if publico_alvo.to_s.downcase.include?("discente") && turma.present?
      # Check count of discentes in the class
      discentes_count = turma.matriculas.where(papel_na_turma: [ "aluno", "discente" ]).count
      if discentes_count == 0
        errors.add(:base, "Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação.")
      end
    end
  end

  def no_active_form_for_same_public
    if status == "aberto" && turma.present? && publico_alvo.present?
      # check if another active form exists for the same class and target
      # exclude self if persisted
      scope = Formulario.where(turma_id: turma_id, status: "aberto")
      # Match any target audience name (discente vs discentes, docente vs docentes)
      target_norm = publico_alvo.to_s.downcase.pluralize
      # Let's filter the ones that match
      active_duplicates = scope.select { |f| f.publico_alvo.to_s.downcase.pluralize == target_norm && f.id != id }
      if active_duplicates.any?
        errors.add(:base, "Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo.")
      end
    end
  end
end
