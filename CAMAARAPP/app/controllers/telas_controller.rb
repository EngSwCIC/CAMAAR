class TelasController < ApplicationController
  def gerenciamento
    
  end

  def tela_alunos
    @alunos = Aluno.all
  end

  def importar

    Aluno.all.each do |aluno|
      aluno.destroy
    end 

    lista_turmas = JSON.parse(File.read('class_members_teste.json'))
    lista_turmas.each do |turma|
      lista_alunos = turma["dicente"]

      lista_alunos.each do |aluno|
        cria_aluno = Aluno.new(nome:aluno["nome"], curso:aluno["curso"], matricula:aluno["matricula"], usuario:aluno["usuario"], formacao:aluno["formacao"], ocupacao:aluno["ocupacao"], email:aluno["email"], senha:"none")
        cria_aluno.save
      end
    end
  end

  def mail
    Aluno.all.each do |aluno|
      AlunoMailer.email_cadastro(aluno).deliver_now

    end

  end

  def cadastro_aluno
    @senha = params["senha"]["senha"]
    @id = params["senha"]["id"]
    puts @senha
    puts @id

    usuario = User.new(matricula:Aluno.find(@id).matricula, email:Aluno.find(@id).email, password:@senha, password_confirmation:@senha)
    usuario.save!
  end
end
