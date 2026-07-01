# frozen_string_literal: true

# Imports docentes and discentes from SIGAA turma data into the system
# as +User+ records (Issue #100 - Cadastrar usuários do sistema).
# Restricted to admins via +require_admin!+.
class Admin::UsersController < ApplicationController
  before_action :require_admin!

  # Imports users from the turmas array sent in +params[:data]+.
  #
  # Receives no explicit arguments; reads +params[:data]+, an array of
  # turma hashes each with a +docente+ and a list of +dicente+.
  # Returns no value; always renders a JSON summary.
  # Side effect: creates +User+ records and sends password-setup e-mails
  # for every newly created user.
  def import
    data = params[:data]

    unless data.is_a?(Array)
      return render json: { message: 'Formato inválido. Esperado um array de turmas.' }, status: :unprocessable_entity
    end

    results = { created: [], skipped: [], errors: [] }
    data.each { |turma| process_turma(turma, results) }

    render json: import_summary(results), status: :ok
  end

  private

  # Imports the docente and all dicentes of a single turma hash.
  def process_turma(turma, results)
    code = turma[:code] || turma['code'] || ''
    department = code.gsub(/[0-9]/, '').strip

    process_docente(turma[:docente] || turma['docente'], results, department)

    dicentes = turma[:dicente] || turma['dicente'] || []
    dicentes.each { |dicente| process_dicente(dicente, results) }
  end

  # Builds the JSON summary returned after an import run.
  def import_summary(results)
    {
      message: 'Importação concluída.',
      criados: results[:created].count,
      ignorados: results[:skipped].count,
      erros: results[:errors]
    }
  end

  # Registers a docente as an admin +User+, scoped to +department+.
  def process_docente(docente, results, department = nil)
    return unless docente

    attrs = {
      name: docente['nome'] || docente[:nome],
      email: docente['email'] || docente[:email],
      matricula: docente['usuario'] || docente[:usuario],
      role: 'admin',
      department: department
    }
    register_user(attrs, results)
  end

  # Registers a dicente as a regular +User+, deriving the department
  # from the "curso" field (e.g. "Graduação/CIC" -> "CIC").
  def process_dicente(dicente, results)
    curso = dicente['curso'] || dicente[:curso] || ''

    attrs = {
      name: dicente['nome'] || dicente[:nome],
      email: dicente['email'] || dicente[:email],
      matricula: dicente['matricula'] || dicente[:matricula],
      role: 'user',
      department: curso.split('/').last
    }
    register_user(attrs, results)
  end

  # Creates a +User+ from +attrs+ unless one already exists with the same
  # e-mail, recording the outcome (created/skipped/errors) into +results+.
  def register_user(attrs, results)
    email = attrs[:email]
    if User.exists?(email: email)
      results[:skipped] << email
      return
    end

    user = User.new(attrs.merge(password: SecureRandom.hex(16)))
    if user.save
      user.send_reset_password_instructions
      results[:created] << email
    else
      results[:errors] << { email: email, erros: user.errors.full_messages }
    end
  end
end
