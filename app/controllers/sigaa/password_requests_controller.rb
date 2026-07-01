# frozen_string_literal: true

module SIGAA
  class PasswordRequestsController < ApplicationController
    before_action :require_administrador!

    def create
      result = PasswordRequestService.new.call

      if result.success?
        redirect_to gerenciamento_path, notice: result.message
      else
        redirect_to gerenciamento_path, alert: result.message
      end
    end
  end
end
