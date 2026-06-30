class AjustarEsquemaDePergunta < ActiveRecord::Migration[8.1]
  def up
    add_column :pergunta, :enunciado, :text unless column_exists?(:pergunta, :enunciado)
    add_column :pergunta, :numero_opcoes, :integer unless column_exists?(:pergunta, :numero_opcoes)

    if column_exists?(:pergunta, :gabarito_radio)
      col = connection.columns(:pergunta).find { |c| c.name == "gabarito_radio" }
      if col && col.sql_type !~ /int/i
        remove_column :pergunta, :gabarito_radio
        add_column :pergunta, :gabarito_radio, :integer
      end
    else
      add_column :pergunta, :gabarito_radio, :integer
    end

    if column_exists?(:pergunta, :opcoes_radio)
      col = connection.columns(:pergunta).find { |c| c.name == "opcoes_radio" }
      if col && col.sql_type !~ /json/i && col.sql_type !~ /text/i
        remove_column :pergunta, :opcoes_radio
        add_column :pergunta, :opcoes_radio, :json
      elsif col && col.sql_type =~ /^text$/i
        remove_column :pergunta, :opcoes_radio
        add_column :pergunta, :opcoes_radio, :json
      end
    else
      add_column :pergunta, :opcoes_radio, :json
    end
  end

  def down
    remove_column :pergunta, :enunciado if column_exists?(:pergunta, :enunciado)
    remove_column :pergunta, :numero_opcoes if column_exists?(:pergunta, :numero_opcoes)
    remove_column :pergunta, :gabarito_radio if column_exists?(:pergunta, :gabarito_radio)
    add_column :pergunta, :gabarito_radio, :string
    remove_column :pergunta, :opcoes_radio if column_exists?(:pergunta, :opcoes_radio)
    add_column :pergunta, :opcoes_radio, :text
  end
end
