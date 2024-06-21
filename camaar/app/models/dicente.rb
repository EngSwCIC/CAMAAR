class Dicente < ApplicationRecord
  has_and_belongs_to_many :turmas, join_table: 'turmas_dicentes'

  validates :matricula, presence: true
  validates :curso, presence: true
end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
