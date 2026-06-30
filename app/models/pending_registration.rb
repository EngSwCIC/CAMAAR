##
# Solicitação de cadastro criada na importação de participantes do SIGAA. O usuário só vira User efetivo após definir a senha pelo link recebido.
class PendingRegistration < ApplicationRecord
  validates :email, presence: true
  validates :token, presence: true, uniqueness: true
end
