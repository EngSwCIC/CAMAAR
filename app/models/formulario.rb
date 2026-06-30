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

  # Valida se a data limite é posterior à data de início.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna nil (adiciona erro internamente, se falhar).
  #
  # = Efeitos Colaterais:
  # * Adiciona erros na validação do model.
  def data_limite_after_data_inicio
    return if data_inicio.blank? || data_limite.blank?
    if data_limite <= data_inicio
      errors.add(:data_limite, "deve ser posterior à data de início")
    end
  end

  # Garante que o formulário utilize um template ativo.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erros na validação do model se o template for inativo.
  def template_must_be_active
    if template.present? && !template.ativo
      errors.add(:template_id, "Não é possível publicar formulários usando templates inativos")
    end
  end

  # Verifica se a turma possui discentes antes de publicar o formulário.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erros na validação se a turma não tiver alunos.
  def turma_has_students_for_discente_form
    if publico_alvo.to_s.downcase.include?("discente") && turma.present?
      # Check count of discentes in the class
      discentes_count = turma.matriculas.where(papel_na_turma: [ "aluno", "discente" ]).count
      if discentes_count == 0
        errors.add(:base, "Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação.")
      end
    end
  end

  # Evita que mais de um formulário ativo coexista para o mesmo público.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erros de validação se já existir formulário duplicado.
  def no_active_form_for_same_public
    return unless check_active_form_conditions

    if has_active_duplicate?
      errors.add(:base, "Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo.")
    end
  end

  # Checa as condições para verificar se o formulário atual tenta ser ativo validamente.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna boolean indicando se o status é "aberto" e se a turma/público existem.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def check_active_form_conditions
    status == "aberto" && turma.present? && publico_alvo.present?
  end

  # Avalia se há formulários duplicados ativos na mesma turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna boolean (true se houver duplicado, false caso contrário).
  #
  # = Efeitos Colaterais:
  # * Acessa banco de dados implicitamente pela query.
  def has_active_duplicate?
    target_norm = normalized_publico_alvo
    active_forms_in_class.any? do |form|
      form.publico_alvo.to_s.downcase.pluralize == target_norm
    end
  end

  # Busca outros formulários abertos na mesma turma.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um ActiveRecord::Relation com os formulários.
  #
  # = Efeitos Colaterais:
  # * Realiza consulta ao banco de dados.
  def active_forms_in_class
    Formulario.where(turma_id: turma_id, status: "aberto").where.not(id: id)
  end

  # Normaliza a string de público alvo.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna uma string contendo o público alvo em letras minúsculas e no plural.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def normalized_publico_alvo
    publico_alvo.to_s.downcase.pluralize
  end
end
