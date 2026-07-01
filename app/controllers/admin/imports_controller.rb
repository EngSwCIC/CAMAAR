# Controller responsável por gerenciar a importação de turmas e discentes do SIGAA.
class Admin::ImportsController < ApplicationController
  layout 'dashboard'
  before_action :require_admin
  
  # Exibe a página de importação de dados.
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Renderiza a view associada.
  def index
  end

  # Recebe e processa o arquivo JSON para importar turmas ou membros do SIGAA.
  #
  # Argumentos: Espera receber params[:file] e params[:import_type].
  # Retorno: Nenhum
  # Efeitos Colaterais: Cria usuários/turmas no banco de dados e redireciona a página.
  def create
    return se_arquivo_invalido if arquivo_invalido?
    
    result = processar_importacao(params[:file].read, params[:import_type])
    
    if result[:success]
      flash[:notice] = result[:message]
    else
      flash[:alert] = result[:message]
    end

    redirect_to admin_imports_path
  end

  private

  # Verifica se o arquivo enviado não é um JSON válido ou se não existe.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def arquivo_invalido?
    params[:file].nil? || (params[:file].content_type != 'application/json' && !params[:file].original_filename.end_with?('.json'))
  end

  # Trata a resposta quando o arquivo é inválido.
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Configura flash alert e redireciona.
  def se_arquivo_invalido
    if params[:file].nil?
      flash[:alert] = "Por favor, selecione um arquivo para importar"
    else
      flash[:alert] = "Formato de arquivo inválido. Por favor, envie um arquivo .json"
    end
    redirect_to admin_imports_path
  end

  # Direciona para o importador correto com base no tipo.
  #
  # Argumentos:
  #   - file_content: string com o conteúdo do json
  #   - import_type: tipo de importação (classes ou members)
  # Retorno: Hash com o resultado da importação.
  # Efeitos Colaterais: Realiza operações de banco de dados via SigaaImporter.
  def processar_importacao(file_content, import_type)
    if import_type == 'classes'
      SigaaImporter.import_classes(file_content)
    else
      SigaaImporter.import_members(file_content)
    end
  end
end
