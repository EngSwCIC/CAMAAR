require "json"

class DashboardsController < ApplicationController
  before_action :require_login


  layout "admin_layout", only: [ :admin, :admin_gerenciamento, :admin_avaliacao ]

  # tela de admin
  def admin
  end

  # tela de gerenciamento
  def admin_gerenciamento
    @turmas    = Turma.all
    @discentes = Discente.all
    @docentes  = Docente.all
  end

  # importação do json
  def importar_json
    # codigo de auxilio
      if params["json"].blank?
        puts "ERRO: O parâmetro 'json' veio vazio!"
        flash[:error] = "Por favor, selecione um arquivo JSON."
        redirect_to admin_gerenciamento_dashboard_path and return
      end

   puts "Arquivo recebido com sucesso: #{params["json"].original_filename}"

    # Chama o service
    resultado = Importer::AcademicDataImporter.import!(params["json"])

    if resultado
      puts "SUCESSO: O Service Object terminou sem erros."
      flash[:success] = "JSON importado com sucesso!"
    else
      puts "AVISO: O Service retornou falso."
    end

  redirect_to admin_gerenciamento_dashboard_path

  rescue => e
    puts "EXCEÇÃO CAPTURADA NO CONTROLLER: #{e.message}"
    puts e.backtrace.first(2)
    flash[:error] = "Ocorreu um erro na importação: #{e.message}"
    redirect_to admin_gerenciamento_dashboard_path
  end

  



  # tela de avaliações
  def admin_avaliacao
  end

  def discente
  end
end
