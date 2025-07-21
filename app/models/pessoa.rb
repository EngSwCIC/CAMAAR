class Pessoa < ApplicationRecord
  # validates :email, presence: true
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, authentication_keys: [:login]

  attr_writer :login

  def login
    @login || email || matricula
  end

  def self.find_for_database_authentication(warden_conditions)
    login = warden_conditions[:login].to_s.downcase
    where("lower(email) = :value OR lower(matricula) = :value", value: login).first
  end

  has_many :cargos, foreign_key: 'email', dependent: :destroy
  has_many :participantes, foreign_key: 'email', dependent: :destroy
  has_many :turmas, through: :participantes
  has_many :formulario_respondidos, foreign_key: 'email', dependent: :destroy

  def formularios_nao_respondidos
    Formulario
      .where(turma_id: turmas.select(:id)) 
      .where.not(id: formularios_ja_respondidos.select(:id)) 
      .includes(:ligacao_pergunta)
      .select(&:valido?) 
  end

  def admin?
    cargos.exists?(funcao: 0)
  end

  def usuario?
    cargos.exists?(funcao: 1)
  end
end
