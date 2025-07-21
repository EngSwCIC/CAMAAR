class Cargo < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'email'
end

# Função:
# 0 - admin
# 1 - aluno
# 2 - professor