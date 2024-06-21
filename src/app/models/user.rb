class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :users_turmas
  has_many :turmas_aluno, through: :users_turmas, class_name: 'Turma', source: :turma
  has_many :turmas_professor, class_name: 'Turma', foreign_key: 'id_professor'
  has_many :respostas
  has_many :templates

end
