require "json"

## Classe para controlar o dashboard para cada perfil
class DashboardsController < ApplicationController
  before_action :require_login

  layout "admin_layout", only: [ :admin, :admin_gerenciamento, :admin_avaliacao ]

  ##
  # === Descrição (a)
  # Renderiza a tela inicial do dashboard do administrador.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +nil+
  # === Efeitos Colaterais (d)
  # * Define o layout "admin_layout".
  def admin
  end

  # === Descrição (a)
  # Carrega dados gerais para a tela de gerenciamento.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +nil+
  # === Efeitos Colaterais (d)
  # * Aloca as variáveis +@turmas+, +@discentes+ e +@docentes+ buscando do banco.
  def admin_gerenciamento
    @turmas = Turma.all
    @discentes = Discente.all
    @docentes = Docente.all
  end

  # === Descrição (a)
  # Processa a importação de um arquivo JSON enviado.
  # === Argumentos (b)
  # * +params[:json]+ (File) - Arquivo JSON enviado no form.
  # === Retorno (c)
  # * Redirecionamento de rota.
  # === Efeitos Colaterais (d)
  # * Modifica o banco via Service e altera mensagens de +flash+.
  def importar_json
    return redirecionar_json_vazio if json_vazio?

    registrar_arquivo_recebido

    if importar_dados_json
      flash[:success] = "JSON importado com sucesso!"
    else
      flash[:alert] = "Ocorreu um problema ao importar o JSON."
    end

    redirect_to admin_gerenciamento_dashboard_path
  rescue StandardError => e
    tratar_erro_importacao(e)
  end

  # === Descrição (a)
  # Renderiza a tela de avaliações do administrador.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +nil+
  # === Efeitos Colaterais (d)
  # * Define o layout "admin_layout".
  def admin_avaliacao
  end

  # === Descrição (a)
  # Renderiza a tela inicial do dashboard do discente.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +nil+
  # === Efeitos Colaterais (d)
  # * Nenhum.
  def discente
  end

  private

  # === Descrição (a)
  # Valida se o parâmetro do arquivo JSON está em branco.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +Boolean+ - +true+ se estiver vazio, +false+ se contiver arquivo.
  # === Efeitos Colaterais (d)
  # * Nenhum.
  def json_vazio?
    params[:json].blank?
  end

  # === Descrição (a)
  # Redireciona informando que o arquivo enviado está vazio.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * Redirecionamento de rota.
  # === Efeitos Colaterais (d)
  # * Altera +flash[:error]+ e printa erro no console do servidor.
  def redirecionar_json_vazio
    puts "ERRO: O parâmetro 'json' veio vazio!"
    flash[:error] = "Por favor, selecione um arquivo JSON."
    redirect_to admin_gerenciamento_dashboard_path
  end

  # === Descrição (a)
  # Printa no console do servidor o nome do arquivo recebido.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +nil+
  # === Efeitos Colaterais (d)
  # * Gera output de texto no terminal.
  def registrar_arquivo_recebido
    puts "Arquivo recebido com sucesso: #{params[:json].original_filename}"
  end

  # === Descrição (a)
  # Executa a chamada do Service Object que salva os dados do JSON.
  # === Argumentos (b)
  # * Nenhum.
  # === Retorno (c)
  # * +Boolean+ - +true+ para sucesso na importação, +false+ para falhas.
  # === Efeitos Colaterais (d)
  # * Altera tabelas do banco de dados e printa logs no terminal.
  def importar_dados_json
    resultado = Importer::AcademicDataImporter.import!(params[:json])

    if resultado
      puts "SUCESSO: O Service Object terminou sem erros."
      true
    else
      puts "AVISO: O Service retornou falso."
      false
    end
  end

  # === Descrição (a)
  # Trata exceções disparadas durante a importação do JSON.
  # === Argumentos (b)
  # * +erro+ (StandardError) - Objeto da exceção capturada.
  # === Retorno (c)
  # * Redirecionamento de rota.
  # === Efeitos Colaterais (d)
  # * Altera +flash[:error]+ e gera logs de erro com backtrace no terminal.
  def tratar_erro_importacao(erro)
    puts "EXCEÇÃO CAPTURADA NO CONTROLLER: #{erro.message}"
    puts erro.backtrace.first(2)

    flash[:error] = "Ocorreu um erro na importação: #{erro.message}"
    redirect_to admin_gerenciamento_dashboard_path
  end
end
