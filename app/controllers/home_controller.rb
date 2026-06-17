class HomeController < ApplicationController
  before_action :require_login

  def index
    @workspace = workspace
    if admin_signed_in?
      redirect_to admin_avaliacoes_path
    else
      @forms = @workspace.forms.select { |f| f["active"] }
    end
  end
end
