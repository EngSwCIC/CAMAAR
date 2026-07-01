# frozen_string_literal: true

class Departamento < ApplicationRecord
  has_many :perfil_adms,
    class_name: "PerfilAdm",
    foreign_key: :departamento_id,
    inverse_of: :departamento,
    dependent: :restrict_with_error

  has_many :perfil_docentes,
    class_name: "PerfilDocente",
    foreign_key: :departamento_id,
    inverse_of: :departamento,
    dependent: :restrict_with_error

  has_many :administradores,
    through: :perfil_adms,
    source: :usuario

  has_many :docentes,
    through: :perfil_docentes,
    source: :usuario

  has_many :materias,
    class_name: "Materia",
    foreign_key: :departamento_id,
    inverse_of: :departamento,
    dependent: :restrict_with_error

  validates :nome,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 }

  before_validation :normalizar_nome

  private

  def normalizar_nome
    self.nome = nome.to_s.strip
  end
end
