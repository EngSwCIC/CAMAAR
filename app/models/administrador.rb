class Administrador < Usuario
  has_many :templates, foreign_key: "usuario_id", dependent: :destroy
  validates :departamento_id, presence: true
end
