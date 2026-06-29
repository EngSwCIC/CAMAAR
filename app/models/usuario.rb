# app/models/usuario.rb
#
# CORREÇÕES APLICADAS (comentários do PR):
#   1. Classe renomeada de `User` para `Usuario` — evita quebra de autoload (Zeitwerk)
#   2. Coluna de senha migrada para `password_digest` — compatível com has_secure_password
#      (a migration anterior usava `senha_hash`, que causava autenticação incorreta)
#
class Usuario < ApplicationRecord
  has_secure_password

  enum :perfil, { discente: 0, docente: 1, admin: 2 }

  has_one :discente, dependent: :destroy
  has_one :docente,  dependent: :destroy

  validates :login, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nome,   presence: true
  validates :perfil, presence: true

  def primeiro_acesso?
    primeiro_acesso
  end
end
