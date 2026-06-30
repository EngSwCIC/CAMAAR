##
# Registra tokens de redefinição de senha já utilizados, para impedir o reuso de um mesmo link de redefinição.
class PasswordResetUsage < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
