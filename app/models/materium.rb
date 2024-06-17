class Materium < ApplicationRecord
  # class Materium::ConnectionTimeoutError < StardardError; end

  def self.get_sigaa_classes
    # begin
      return File.read('classes.json')
    # rescue ActiveRecord::ConnectionTimeoutError
    #   raise Materium::ConnectionTimeoutError, 'Connection timed out'
    # end
  end

  validates :codigo, presence: true
  validates :nome, presence: true
  validates :semestre, presence: true
  validates :horario, presence: true
  validates :departamento_id, presence: true

  belongs_to :departamento
  has_and_belongs_to_many :aluno
  has_and_belongs_to_many :professor
end
