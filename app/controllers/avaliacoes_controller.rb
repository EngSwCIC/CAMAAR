class AvaliacoesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @forms = current_user.find_pending_forms

    render layout: "home"
  end
end
