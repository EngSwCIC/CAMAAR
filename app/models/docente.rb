class Docente < Usuario
  validates :formacao, presence: true
  has_and_belongs_to_many :turmas, join_table: "docentes_turmas"
end
