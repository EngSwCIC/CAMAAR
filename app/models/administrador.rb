# Representa um usuário com perfil de administrador do sistema.
#
# Herda de +Usuario+ e adiciona a obrigatoriedade de estar vinculado a um
# +Departamento+. Possui acesso exclusivo às funcionalidades de gerenciamento,
# envio de formulários e sincronização com o SIGAA, além de poder criar e
# gerenciar +Template+s de avaliação.
class Administrador < Usuario
  has_many :templates, foreign_key: "usuario_id", dependent: :destroy
  validates :departamento_id, presence: true
end
