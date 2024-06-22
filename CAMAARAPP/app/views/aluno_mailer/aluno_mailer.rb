class AlunoMailer < ApplicationMailer
  def email_cadastro(aluno)
      @aluno = aluno
      mail(to: @aluno.email, subject: 'Welcome to My Awesome Site')
    end
end