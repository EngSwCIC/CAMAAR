# Turma associada a uma disciplina
class Turma < ApplicationRecord
  belongs_to :disciplina
  has_many :docente_records, class_name: "Docente", dependent: :destroy
  has_many :discente_records, class_name: "Discente", dependent: :destroy
  has_and_belongs_to_many :forms

  has_many :turma_memberships, dependent: :destroy
  has_many :member_users, through: :turma_memberships, source: :user

  # Users com role 'docente' vinculados via TurmaMembership
  has_many :docentes,
    -> { where(role: "docente") },
    through: :turma_memberships,
    source: :user

  # Users com role 'discente' vinculados via TurmaMembership
  has_many :discente_users,
    -> { where(role: "discente") },
    through: :turma_memberships,
    source: :user
end
