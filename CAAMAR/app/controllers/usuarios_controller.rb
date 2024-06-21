class UsuariosController < ApplicationController
  before_action :verify_authenticity_token, :set_usuario, only: %i[ show edit update destroy ]

  # GET /usuarios or /usuarios.json
  def index
    @usuarios = Usuario.all
  end

  # GET /usuarios/1 or /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios or /usuarios.json
  def create
    Rails.logger.info("esse aluno: #{usuario_params}")
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        UserMailer.with(user: @usuario).gen_password.deliver
        format.html { redirect_to(@usuario, notice: 'User was successfully created.') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def usuario_params
    params.require(:usuario).permit({:usuario =>[:matricula, :nome, :formacao, :email, :senha,:curso,:isAdmin,:isAluno,:isProf]})
  end

  def usuario_params2
    params.require(:usuario).permit({:usuario =>[:matricula, :nome, :formacao, :email, :senha,:senha_confirmation]})
  end

  # PATCH/PUT /usuarios/1 or /usuarios/1.json
  def update

    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to usuario_url(@usuario), notice: "Usuario was successfully updated." }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1 or /usuarios/1.json
  def destroy
    @usuario.destroy!

    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: "Usuario was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def getJson
    file = File.read('../class_members.json')
    data_hash = JSON.parse(file)
    alunos = data_hash[0]['dicente']

    alunos.each do |aluno|
      Rails.logger.info("esse aluno: #{aluno}")
      @usuario = Usuario.new(
        matricula: aluno["matricula"],
        nome: aluno["nome"],
        formacao: aluno["formacao"],
        curso: aluno["curso"],
        email: aluno["email"],  
        senha: aluno["senha"]
      )

      if @usuario.save
        Rails.logger.info("deu bom")
      else
        Rails.logger.info("deu ruim")
      end
      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      params.require(:usuario).permit(:matricula, :nome, :email, :formacao,:senha,:curso, :isAdmin,:isProf,:isAluno)
    end
end
