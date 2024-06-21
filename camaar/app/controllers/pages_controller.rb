class PagesController < ApplicationController
  def login
    # Renderiza a view de login
  end

  def home
    # Renderiza a view de home
  end

  def recuperar_senha
    @username = params[:username]
  end

  def importar_dados
    # Lógica para lidar com o arquivo importado
    if params[:file].present?  # Assumindo que você está enviando um arquivo com o nome 'file'
      uploaded_file = params[:file]
      # Aqui você pode fazer o que for necessário com o arquivo, como salvar no servidor, processar, etc.
      render plain: "Arquivo '#{uploaded_file.original_filename}' importado com sucesso!"
    else
      render plain: "Nenhum arquivo selecionado para importar."
    end
  end

  def update_password
    @user = User.find_by(usuario: params[:username])

    if @user.present? && params[:new_password] == params[:new_password_confirmation]
      if @user.update(senha: params[:new_password])
        redirect_to login_path, notice: 'Senha alterada com sucesso.'
      else
        flash.now[:alert] = 'Houve um problema ao alterar sua senha. Por favor, tente novamente.'
        render :recuperar_senha
      end
    else
      flash.now[:alert] = 'As senhas não coincidem ou usuário não encontrado.'
      render :recuperar_senha
    end
  end


  def criar_templete
    # Renderiza a view de criação de templete
  end
end
