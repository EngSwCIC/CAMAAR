##
# Representa o vínculo de um usuário com uma turma como discente ou docente.
class ClassMembership < ApplicationRecord
  belongs_to :user
  belongs_to :course_class

  enum :role, { discente: 0, docente: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: [ :course_class_id, :role ] }
end
