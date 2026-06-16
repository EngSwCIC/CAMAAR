require 'csv'
require 'json'

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  # GET /users/sigaa - formulário de importação dos JSONs do SIGAA (issue #4)
  def sigaa
  end

  # POST /users/sigaa_import - importa turmas/usuários/matrículas a partir
  # dos JSONs enviados ou, na ausência deles, dos arquivos do repositório.
  def sigaa_import
    classes = parse_json(params[:classes_file], "classes.json")
    members = parse_json(params[:members_file], "class_members.json")

    counts = SigaaImporter.call(classes: classes, members: members)

    redirect_to users_path,
      notice: "SIGAA importado: #{counts[:turmas]} turmas, #{counts[:users]} usuários e #{counts[:enrollments]} matrículas."
  rescue => e
    redirect_to sigaa_users_path, alert: "Falha ao importar dados do SIGAA: #{e.message}"
  end

  def import
    file = params[:file]
    return redirect_to users_path, alert: "Nenhum arquivo selecionado" unless file

    CSV.foreach(file.path, headers: true) do |row|
      # Cria o registro e envia o token por e-mail automaticamente
      User.invite!(
        nome: row['nome'],
        email: row['email'],
        matricula: row['matricula'],
        perfil: row['perfil']
      )
    end

    redirect_to users_path, notice: "Usuários importados e convites enviados com sucesso!"
  end

  private

  # Lê o JSON do upload quando presente; caso contrário, do arquivo do repositório
  def parse_json(uploaded, fallback_filename)
    if uploaded.respond_to?(:read)
      JSON.parse(uploaded.read)
    else
      JSON.parse(File.read(Rails.root.join(fallback_filename)))
    end
  end
end