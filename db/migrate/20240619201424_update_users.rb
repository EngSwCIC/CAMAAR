class UpdateUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.string :nome
      t.string :usuario
      t.string :formacao
      t.string :ocupacao

      # departamento eh so pra professor, curso eh so pra aluno
      t.string :curso
      t.string :departamento
    end
  end
end
