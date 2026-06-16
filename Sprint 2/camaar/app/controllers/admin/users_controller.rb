# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :require_admin!

  # POST /admin/users/import
  def import
    data = params[:data]

    unless data.is_a?(Array)
      return render json: { message: 'Formato inválido. Esperado um array de turmas.' }, status: :unprocessable_entity
    end

    results = { created: [], skipped: [], errors: [] }

    data.each do |turma|
      code = turma[:code] || turma['code'] || ''
      department = code.gsub(/[0-9]/, '').strip
      process_docente(turma[:docente] || turma['docente'], results, department)

      dicentes = turma[:dicente] || turma['dicente'] || []
      dicentes.each { |dicente| process_dicente(dicente, results) }
    end

    render json: {
      message: 'Importação concluída.',
      criados: results[:created].count,
      ignorados: results[:skipped].count,
      erros: results[:errors]
    }, status: :ok
  end

  private

  def process_docente(docente, results, department = nil)
    return unless docente

    email = docente['email'] || docente[:email]
    if User.exists?(email: email)
      results[:skipped] << email
      return
    end

    user = User.new(
      name: docente['nome'] || docente[:nome],
      email: email,
      matricula: docente['usuario'] || docente[:usuario],
      role: 'admin',
      department: department,
      password: SecureRandom.hex(16)
    )

    if user.save
      user.send_reset_password_instructions
      results[:created] << email
    else
      results[:errors] << { email: email, erros: user.errors.full_messages }
    end
  end

  def process_dicente(dicente, results)
    email = dicente['email'] || dicente[:email]
    if User.exists?(email: email)
      results[:skipped] << email
      return
    end

    curso = dicente['curso'] || dicente[:curso] || ''
    department = curso.split('/').last

    user = User.new(
      name: dicente['nome'] || dicente[:nome],
      email: email,
      matricula: dicente['matricula'] || dicente[:matricula],
      role: 'user',
      department: department,
      password: SecureRandom.hex(16)
    )

    if user.save
      user.send_reset_password_instructions
      results[:created] << email
    else
      results[:errors] << { email: email, erros: user.errors.full_messages }
    end
  end

end