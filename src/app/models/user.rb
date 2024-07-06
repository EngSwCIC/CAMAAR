# Inclui módulos padrão do Devise para autenticação e gerenciamento de usuários.
#
# == Associações
# - +has_many :users_turmas+ - Define uma associação de um-para-muitos com o modelo UserTurma. Um usuário pode estar associado a muitas turmas.
# - +has_many :turmas_aluno, through: :users_turmas, class_name: 'Turma', source: :turma+ - Define uma associação indireta de muitos-para-muitos com o modelo Turma através da tabela de junção UserTurma, onde o usuário é um aluno.
# - +has_many :turmas_professor, class_name: 'Turma', foreign_key: 'id_professor'+ - Define uma associação de um-para-muitos com o modelo Turma, onde o usuário é um professor.
# - +has_many :respostas+ - Define uma associação de um-para-muitos com o modelo Resposta. Um usuário pode ter muitas respostas.
# - +has_many :templates+ - Define uma associação de um-para-muitos com o modelo Template. Um usuário pode criar muitos templates.
#
# +effect_side+ Permite a autenticação e gerenciamento de usuários na aplicação, incluindo associações com turmas e respostas.
class User < ApplicationRecord

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  has_many :users_turmas
  has_many :turmas_aluno, through: :users_turmas, class_name: 'Turma', source: :turma
  has_many :turmas_professor, class_name: 'Turma', foreign_key: 'id_professor'
  has_many :respostas
  has_many :templates

end
