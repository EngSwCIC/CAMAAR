class UpdatePerguntaTable < ActiveRecord::Migration[8.0]
  def change
    # Renomear coluna titulo para texto
    rename_column :pergunta, :titulo, :texto
    
    # Adicionar coluna obrigatoria
    add_column :pergunta, :obrigatoria, :boolean, default: true
    
    # Remover coluna ordem se não for necessária
    remove_column :pergunta, :ordem, :integer
  end
end
