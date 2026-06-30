require "csv"

##
# Atualização da base com os dados atuais do SIGAA (update_database). Faz upsert de turmas/usuários/matrículas preservando formulários e templates já existentes.
class SigaaUpdatesController < ApplicationController
  before_action :authenticate_user!

  ##
  # a. Descrição: Cria uma nova atualização de dados do SIGAA.
  # b. Argumentos: Nenhum.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Nenhum.
  def new
  end

  ##
  # a. Descrição: Processa o upload do arquivo CSV do SIGAA e atualiza a base de dados.
  # b. Argumentos: Recebe 'sigaa_file' (ActionDispatch::Http::UploadedFile) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atualiza a base de dados com turmas, usuários e matrículas, preservando formulários e templates existentes.
  def create
    file = params[:sigaa_file]
    rows = ler_linhas(file)

    if rows.nil? || rows.empty?
      redirect_to root_path, alert: "Arquivo SIGAA inválido" and return
    end

    rows.each { |row| importar_linha(row) }

    redirect_to root_path,
      notice: "Base de dados atualizada com sucesso. Dados atualizados conforme o SIGAA."
  end

  private

  ##
  # a. Descrição: Lê as linhas do arquivo CSV enviado e retorna um array de hashes representando cada linha.
  # b. Argumentos: Recebe 'file' (ActionDispatch::Http::UploadedFile) como parâmetro.
  # c. Retorno: Retorna um array de hashes representando as linhas do CSV, ou nil se o arquivo for inválido.
  # d. Efeitos colaterais: Nenhum.
  def ler_linhas(file)
    return nil unless file.respond_to?(:path)

    conteudo = File.read(file.path).strip
    return [] if conteudo.empty?

    CSV.parse(conteudo, headers: true)
  rescue CSV::MalformedCSVError
    nil
  end

  ##
  # a. Descrição: Importa uma linha do CSV, chamando as funções de upsert, e criando matrícula se ambos existirem.
  # b. Argumentos: Recebe 'row' (Hash) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria ou atualiza turmas, usuários e matrículas na base de dados.
  def importar_linha(row)
    turma = Turma.upsert_from_row(row)
    user  = User.find_or_invite_from_row(row)
    return unless user && turma

    Enrollment.ensure_role(user: user, turma: turma, perfil: row["perfil"])
  end
end
