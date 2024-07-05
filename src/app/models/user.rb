# Descreve a model do usuário.
# Apresenta o devise como gema principal para validação e criação do usuário.
# Possui os templates, quando admin;
# Possui turmas, tanto como professor, quanto como aluno 
class User < ApplicationRecord

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  has_many :users_turmas
  has_many :turmas_aluno, through: :users_turmas, class_name: 'Turma', source: :turma
  has_many :turmas_professor, class_name: 'Turma', foreign_key: 'id_professor'
  has_many :respostas
  has_many :templates

end
