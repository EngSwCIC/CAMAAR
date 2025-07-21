class Opcao < ApplicationRecord
    belongs_to :pergunta, foreign_key: 'pergunta_id'
end
