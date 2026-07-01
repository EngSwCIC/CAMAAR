##
# Registra um dado inválido encontrado durante uma importação do SIGAA.
class ImportInconsistency < ApplicationRecord
  validates :source, :message, presence: true
end
