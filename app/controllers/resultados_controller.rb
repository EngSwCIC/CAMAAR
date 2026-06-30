require "csv"

##
# Página de resultados de um formulário e download em CSV, identificado pelo slug do título (download_results_csv).
class ResultadosController < ApplicationController
  def show #:nodoc:
    @formulario = encontrar_formulario(params[:slug])
    @slug = params[:slug]
    render plain: "Formulário não encontrado", status: :not_found if @formulario.nil?
  end

  ##
  # a. Descrição: Permite o download das respostas de um formulário em formato CSV.
  # b. Argumentos: Recebe 'slug' (String) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Emite o arquivo CSV para download, com cabeçalho e linhas de dados, ou uma mensagem de erro caso não haja respostas.
  def download
    formulario = encontrar_formulario(params[:slug])

    if formulario.nil?
      render plain: "Formulário não encontrado", status: :not_found and return
    end

    if formulario.respostas.empty?
      render plain: "Não há respostas para exportar" and return
    end

    send_data gerar_csv(formulario),
      filename: "#{nome_arquivo(formulario.titulo)}.csv",
      type: "text/csv"
  end

  private

  ##
  # a. Descrição: Encontra o formulário correspondente ao slug fornecido.
  # b. Argumentos: Recebe 'slug' (String) como parâmetro.
  # c. Retorno: Retorna o formulário encontrado ou nil se não houver correspondência.
  # d. Efeitos colaterais: Nenhum.
  def encontrar_formulario(slug)
    Formulario.includes(:respostas).find { |formulario| slugify(formulario.titulo) == slug }
  end

  # Mesmo cálculo de slug usado nos cenários (acentos são removidos).
  def slugify(titulo)
    titulo.downcase.tr(" .", "__").gsub(/[^a-z0-9_]/, "")
  end

  ##
  # a. Descrição: Gera um nome de arquivo seguro a partir do título do formulário.
  # b. Argumentos: Recebe 'titulo' (String) como parâmetro.
  # c. Retorno: Retorna o nome de arquivo gerado (String).
  # d. Efeitos colaterais: Nenhum.
  def nome_arquivo(titulo)
    ActiveSupport::Inflector.transliterate(titulo).downcase.gsub(/[^a-z0-9]+/, "_").gsub(/\A_|_\z/, "")
  end

  ##
  # a. Descrição: Gera o conteúdo CSV com as respostas do formulário.
  # b. Argumentos: Recebe 'formulario' (Formulario) como parâmetro.
  # c. Retorno: Retorna o conteúdo CSV gerado (String).
  # d. Efeitos colaterais: Nenhum.
  def gerar_csv(formulario)
    CSV.generate do |csv|
      csv << [ "Pergunta", "Resposta" ]
      formulario.questions.each do |question|
        formulario.respostas_da(question).each do |resposta|
          csv << [ question.enunciado, resposta.valor ]
        end
      end
    end
  end
end
