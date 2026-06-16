class Enrollment < ApplicationRecord
  ROLES = %w[docente discente].freeze

  belongs_to :user
  belongs_to :turma

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :turma_id }

  scope :discentes, -> { where(role: "discente") }
  scope :docentes,  -> { where(role: "docente") }
end
