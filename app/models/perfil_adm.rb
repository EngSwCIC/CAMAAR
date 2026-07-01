# frozen_string_literal: true

class PerfilAdm < ApplicationRecord
  self.primary_key = :id

  belongs_to :usuario,
    class_name: "Usuario",
    foreign_key: :id,
    inverse_of: :perfil_adm

  belongs_to :departamento,
    class_name: "Departamento",
    foreign_key: :departamento_id,
    inverse_of: :perfil_adms

  has_many :templates,
    class_name: "Template",
    foreign_key: :adm_id,
    inverse_of: :adm,
    dependent: :restrict_with_error

  has_many :formularios,
    class_name: "Formulario",
    foreign_key: :adm_id,
    inverse_of: :adm,
    dependent: :restrict_with_error

  validates :id, presence: true, uniqueness: true

  validates :departamento, presence: true

  def nome
    usuario.nome
  end

  def email
    usuario.email
  end

  def criou_template?(template)
    template.present? && template.adm_id == id
  end
end
