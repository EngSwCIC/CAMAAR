class CreateAdministradors < ActiveRecord::Migration[7.1]
  def change
    create_table :administradors do |t|
      t.references :users, null: false, foreign_key: true
      # comentário para caso haja um erro com a tabela no futuro, users está no plural

      t.timestamps
    end
  end
end
