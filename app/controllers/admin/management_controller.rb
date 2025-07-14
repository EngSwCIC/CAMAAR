# frozen_string_literal: true

module Admin
  # Controller para gerenciamento administrativo do sistema
  class ManagementController < ApplicationController
    before_action :authorize_management

    def index
      @has_imported_data = check_imported_data
    end

    def import_modal
      render partial: 'import_modal'
    end

    def import_users
      authorize_import_users

      if params[:file].present?
        begin
          file_content = File.read(params[:file].path)
          data = JSON.parse(file_content)

          result = ImportService.import_users(data)

          if result[:success]
            render json: {
              success: true,
              message: "#{result[:imported]} usuários importados com sucesso!",
              imported_count: result[:imported],
              skipped_count: result[:skipped]
            }
          else
            render json: { success: false, message: result[:error] }
          end
        rescue JSON::ParserError
          render json: { success: false, message: 'Arquivo JSON inválido' }
        rescue StandardError => e
          render json: { success: false, message: "Erro: #{e.message}" }
        end
      else
        render json: { success: false, message: 'Nenhum arquivo foi enviado' }
      end
    end

    def import_disciplines
      authorize_import_disciplines

      if params[:file].present?
        begin
          file_content = File.read(params[:file].path)
          data = JSON.parse(file_content)

          result = ImportService.import_disciplines(data)

          if result[:success]
            render json: {
              success: true,
              message: "#{result[:imported]} disciplinas importadas com sucesso!",
              imported_count: result[:imported],
              skipped_count: result[:skipped]
            }
          else
            render json: { success: false, message: result[:error] }
          end
        rescue JSON::ParserError
          render json: { success: false, message: 'Arquivo JSON inválido' }
        rescue StandardError => e
          render json: { success: false, message: "Erro: #{e.message}" }
        end
      else
        render json: { success: false, message: 'Nenhum arquivo foi enviado' }
      end
    end

    private

    def authorize_management
      authorize %i[admin management], :index?
    end

    def authorize_import_users
      authorize %i[admin management], :import_users?
    end

    def authorize_import_disciplines
      authorize %i[admin management], :import_disciplines?
    end

    def check_imported_data
      # Verifica se já existem dados importados (excluindo usuários seed)
      seed_emails = ['admin@camaar.com', 'coordenador@camaar.com', 'professor@camaar.com', 'aluno@camaar.com']
      users_count = User.where.not(email: seed_emails).count
      disciplinas_count = Disciplina.count

      Rails.logger.info "Checking imported data: users=#{users_count}, disciplines=#{disciplinas_count}"

      users_count.positive? && disciplinas_count.positive?
    end
  end
end
