##
# Define a model para representar a matrícula de um usuário em uma turma, incluindo o papel (docente ou discente) do usuário na turma.
# == Schema:
#  * id: integer, primary key
#  * user_id: integer, foreign key para o usuário
#  * turma_id: integer, foreign key para a turma
#  * role: string, papel do usuário na turma (docente ou discente)
class Enrollment < ApplicationRecord
  # Define os papéis possíveis para a matrícula, que são "docente" e "discente".
  ROLES = %w[docente discente].freeze

  belongs_to :user
  belongs_to :turma

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :turma_id }

  scope :discentes, -> { where(role: "discente") }
  scope :docentes,  -> { where(role: "docente") }

  ##
  # a. Descrição: Garante a matrícula de um usuário em uma turma com o papel correspondente ao perfil.
  # b. Argumentos: Recebe 'user' (User), 'turma' (Turma) e 'perfil' (String); perfis diferentes de "docente" viram "discente".
  # c. Retorno: Retorna a Enrollment encontrada ou criada.
  # d. Efeitos colaterais: Insere uma Enrollment no banco caso ainda não exista.
  def self.ensure_role(user:, turma:, perfil:)
    role = (perfil == "docente") ? "docente" : "discente"
    find_or_create_by!(user: user, turma: turma) { |e| e.role = role }
  end
end
