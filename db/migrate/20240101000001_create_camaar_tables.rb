# db/migrate/20240101000001_create_camaar_tables.rb
#
# CORREÇÃO: coluna renomeada de `senha_hash` para `password_digest`
# para compatibilidade com has_secure_password do Rails.
#
class CreateCamaarTables < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |t|
      t.string  :login,           null: false
      t.string  :password_digest, null: false   # ← era senha_hash (incompatível)
      t.string  :email,           null: false
      t.string  :nome,            null: false
      t.integer :perfil,          null: false, default: 0  # enum: 0=discente 1=docente 2=admin
      t.boolean :primeiro_acesso, null: false, default: true
      t.timestamps
    end
    add_index :usuarios, :login, unique: true
    add_index :usuarios, :email, unique: true

    create_table :departamentos do |t|
      t.string :nome, null: false
      t.timestamps
    end
    add_index :departamentos, :nome, unique: true

    create_table :docentes do |t|
      t.references :usuario,      null: false, foreign_key: true
      t.references :departamento, null: false, foreign_key: true
      t.timestamps
    end

    create_table :discentes do |t|
      t.references :usuario,   null: false, foreign_key: true
      t.string     :matricula, null: false
      t.string     :curso,     null: false
      t.timestamps
    end
    add_index :discentes, :matricula, unique: true

    create_table :disciplinas do |t|
      t.string :codigo, null: false
      t.string :nome,   null: false
      t.timestamps
    end
    add_index :disciplinas, :codigo, unique: true

    create_table :turmas do |t|
      t.string     :codigo,   null: false
      t.string     :semestre, null: false
      t.string     :horario
      t.references :disciplina, null: false, foreign_key: true
      t.references :docente,    null: false, foreign_key: true
      t.timestamps
    end

    create_table :matriculas do |t|
      t.references :discente, null: false, foreign_key: true
      t.references :turma,    null: false, foreign_key: true
      t.timestamps
    end
    add_index :matriculas, [ :discente_id, :turma_id ], unique: true

    create_table :templates do |t|
      t.string     :titulo,   null: false
      t.text       :descricao
      t.references :docente,  null: false, foreign_key: true
      t.timestamps
    end

    create_table :questao_templates do |t|
      t.text       :enunciado, null: false
      t.integer    :tipo,      null: false, default: 0  # 0=aberta 1=multipla
      t.references :template,  null: false, foreign_key: true
      t.timestamps
    end

    create_table :opcao_questoes do |t|
      t.string     :texto,            null: false
      t.references :questao_template, null: false, foreign_key: true
      t.timestamps
    end

    create_table :formularios do |t|
      t.string     :titulo,   null: false
      t.datetime   :prazo
      t.references :turma,    null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.timestamps
    end

    create_table :questoes do |t|
      t.text       :enunciado,        null: false
      t.integer    :tipo,             null: false, default: 0
      t.references :formulario,       null: false, foreign_key: true
      t.references :questao_template, null: false, foreign_key: true
      t.timestamps
    end

    create_table :envio_formularios do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :discente,   null: false, foreign_key: true
      t.datetime   :enviado_em
      t.timestamps
    end
    add_index :envio_formularios, [ :formulario_id, :discente_id ], unique: true

    create_table :respostas do |t|
      t.text       :conteudo,         null: false
      t.references :envio_formulario, null: false, foreign_key: true
      t.references :questao,          null: false, foreign_key: true
      t.timestamps
    end
  end
end
