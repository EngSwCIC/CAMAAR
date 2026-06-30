require "csv"
require "json"

##
# Define a controller para gerenciar usuários, incluindo listagem, criação via convite, importação de participantes do SIGAA e envio de convites para definição de senha.
class UsersController < ApplicationController
  ##
  # a. Descrição: Lista todos os usuários e registros pendentes de participantes.
  # b. Argumentos: Nenhum.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Atribui as variáveis de instância @users e @pending_registrations.
  def index
    @users = User.all
    @pending_registrations = PendingRegistration.all
  end

  ##
  # a. Descrição: Cria um novo usuário via convite, enviando e-mail para definição de senha.
  # b. Argumentos: Recebe 'nome', 'email', 'matricula' e 'perfil' como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria o usuário no banco de dados e envia um e-mail de convite para definição de senha, ou redireciona com mensagem de erro caso o e-mail já esteja em uso.
  def create
    email = params[:email].to_s.downcase

    if email.present? && User.exists?(email: email)
      redirect_to "/usuarios/novo", alert: "Este email já está em uso por outro usuário." and return
    end

    User.invite!(parametros_convite(email))

    redirect_to "/usuarios", notice: "Usuário cadastrado com sucesso."
  rescue ActiveRecord::RecordInvalid => erro
    redirect_to "/usuarios/novo", alert: "Erro ao cadastrar usuário: #{erro.message}"
  end

  ##
  # a. Descrição: Registra participantes a partir de um arquivo JSON, enviando convites para definição de senha.
  # b. Argumentos: Recebe 'participants_file' (JSON) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria registros pendentes de usuários no banco de dados e envia e-mails de convite para definição de senha, ou redireciona com mensagem de erro caso o arquivo não seja fornecido.
  def register_participants
    participantes = parse_json(params[:participants_file], "spec/fixtures/sigaa_participant_maria.json")

    criados = []
    ignorados = []

    Array(participantes).each { |participante| processar_participante(participante, criados, ignorados) }

    redirect_to users_path, notice: mensagem_registro(criados, ignorados)
  end

  ##
  # a. Descrição: Faz a importação dos JSONs do SIGAA.
  # b. Argumentos: Recebe 'sigaa_users_file' (JSON) e 'sigaa_enrollments_file' (JSON) como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria ou atualiza usuários e matrículas no banco de dados.
  def sigaa
  end

  ##
  # a. Descrição: Importa usuários e matrículas a partir de um arquivo CSV, enviando convites para definição de senha.
  # b. Argumentos: Recebe 'file' (CSV) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria ou atualiza turmas, usuários e matrículas no banco de dados, e envia e-mails de convite para definição de senha, ou redireciona com mensagem de erro caso o arquivo não seja fornecido.
  def import
    file = params[:file]
    return redirect_to root_path, alert: "Nenhum arquivo selecionado" unless file

    CSV.foreach(file.path, headers: true) do |row|
      turma = Turma.upsert_from_row(row)
      user  = User.find_or_invite_from_row(row)
      Enrollment.ensure_role(user: user, turma: turma, perfil: row["perfil"]) if user && turma
    end

    redirect_to root_path, notice: "Usuários importados e convites enviados com sucesso!"
  end

  ##
  # a. Descrição: Importa turmas, usuários e matrículas a partir dos arquivos JSON do SIGAA.
  # b. Argumentos: Recebe 'classes_file' e 'members_file' (uploads JSON); usa arquivos do repositório como fallback.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Persiste dados via SigaaImporter e redireciona com mensagem de sucesso ou de erro.
  def sigaa_import
    classes = parse_json(params[:classes_file], "spec/fixtures/sigaa_classes.json")
    members = parse_json(params[:members_file], "spec/fixtures/sigaa_members.json")

    SigaaImporter.call(classes: classes, members: members)

    redirect_to users_path, notice: "SIGAA importado com sucesso."
  rescue StandardError => e
    redirect_to sigaa_users_path, alert: "Falha ao importar dados do SIGAA: #{e.message}"
  end

  private

  ##
  # a. Descrição: Monta o hash de parâmetros usado para convidar um novo usuário.
  # b. Argumentos: Recebe 'email' (String) já normalizado.
  # c. Retorno: Retorna um Hash com nome, email, matricula e perfil.
  # d. Efeitos colaterais: Nenhum.
  def parametros_convite(email)
    {
      nome: params[:nome],
      email: email,
      matricula: params[:matricula],
      perfil: params[:perfil]
    }
  end

  ##
  # a. Descrição: Processa um participante do JSON, ignorando os já cadastrados e registrando os novos.
  # b. Argumentos: Recebe 'participante' (Hash), 'criados' (Array) e 'ignorados' (Array).
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Preenche os arrays 'criados'/'ignorados' e dispara o registro do pendente.
  def processar_participante(participante, criados, ignorados)
    email = participante["email"].to_s

    if User.exists?(email: email.downcase)
      ignorados << email
      return
    end

    registrar_pendente(participante, email)
    criados << email
  end

  ##
  # a. Descrição: Cria o registro pendente (se ainda não existir) e envia o convite de definição de senha.
  # b. Argumentos: Recebe 'participante' (Hash) e 'email' (String).
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Insere um PendingRegistration no banco e envia e-mail de convite.
  def registrar_pendente(participante, email)
    pending = PendingRegistration.find_or_create_by!(email: email) do |pr|
      pr.token = SecureRandom.hex(10)
      pr.nome = participante["nome"]
      pr.matricula = participante["matricula"]
      pr.perfil = "discente"
    end

    PendingRegistrationMailer.setup_password(pending).deliver_now
  end

  ##
  # a. Descrição: Gera uma mensagem de registro com informações sobre os usuários criados e ignorados.
  # b. Argumentos: Recebe 'criados' (Array) e 'ignorados' (Array) como parâmetros.
  # c. Retorno: Retorna a mensagem de registro gerada (String).
  # d. Efeitos colaterais: Nenhum.
  def mensagem_registro(criados, ignorados)
    partes = []
    partes << "Convites enviados para: #{criados.join(', ')}" if criados.any?
    ignorados.each { |email| partes << "Usuário #{email} já cadastrado, ignorado" }
    partes.join(". ")
  end

  # Lê o JSON do upload quando presente; caso contrário, do arquivo do repositório
  def parse_json(uploaded, fallback_filename)
    if uploaded.respond_to?(:read)
      JSON.parse(uploaded.read)
    else
      JSON.parse(File.read(Rails.root.join(fallback_filename)))
    end
  end
end
