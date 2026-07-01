# frozen_string_literal: true

module SIGAA
  class SendPendingInvitations
    include BrevoEmailable

    Result = Struct.new(:status, :successes, :errors, keyword_init: true) do
      def missing_department?
        status == :missing_department
      end

      def empty?
        status == :empty
      end

      def success?
        status == :sent
      end
    end

    def self.call(current_user:)
      new(current_user: current_user).call
    end

    def initialize(current_user:)
      @current_user = current_user
    end

    def call
      return result(:missing_department) if departamento_id.blank?

      users = pending_users
      return result(:empty) if users.empty?

      send_result = send_invitations(users)
      result(send_result[:errors].empty? ? :sent : :partial, send_result)
    end

    private

    attr_reader :current_user

    def departamento_id
      @departamento_id ||= current_user.perfil_adm&.departamento_id
    end

    def pending_users
      (pending_discentes + pending_docentes).uniq
    end

    def pending_discentes
      Usuario
        .joins(:participacoes_turma)
        .where(status: 0, participacoes_turma: { turma_id: turmas_do_departamento_ids })
    end

    def pending_docentes
      Usuario
        .joins(:perfil_docente)
        .where(status: 0, perfis_docentes: { departamento_id: departamento_id })
    end

    def turmas_do_departamento_ids
      @turmas_do_departamento_ids ||= Turma.joins(:materia).where(materias: { departamento_id: departamento_id }).ids
    end

    def send_invitations(users)
      users.each_with_object({ successes: 0, errors: [] }) do |usuario, memo|
        memo[:successes] += 1 if send_invitation(usuario, memo[:errors])
      end
    end

    def send_invitation(usuario, errors)
      sent = false

      ActiveRecord::Base.transaction do
        token = create_registration_token!(usuario)

        if enviar_email_convite_admin(usuario.email, token, current_user.nome)
          sent = true
        else
          raise "Falha de comunicação com a Brevo."
        end
      rescue StandardError => error
        errors << "#{usuario.nome} (Matrícula: #{usuario.matricula}): #{error.message}"
        raise ActiveRecord::Rollback
      end

      sent
    end

    def create_registration_token!(usuario)
      SecureRandom.hex(16).tap do |token|
        usuario.tokens.create!(
          value: token,
          tipo: "cadastro",
          expires_at: 10.minutes.from_now
        )
      end
    end

    def result(status, values = {})
      Result.new(
        status: status,
        successes: values.fetch(:successes, 0),
        errors: values.fetch(:errors, [])
      )
    end
  end
end
