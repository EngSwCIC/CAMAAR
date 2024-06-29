class AlunosController < ApplicationController
    before_action :authenticate_aluno!

    def dashboard
      @formularios = Formulario.all

        redirect_to reports_alunos_path

    end
  end