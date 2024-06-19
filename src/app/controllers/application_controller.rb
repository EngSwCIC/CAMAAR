class ApplicationController < ActionController::Base
    def load_examples
      json_data = [
        {
          nome: "Ana Clara Jordao Perna",
          curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",
          matricula: "190084006",
          usuario: "190084006",
          formacao: "graduando",
          ocupacao: "dicente",
          email: "acjpjvjp@gmail.com"
        },
        {
          nome: "João Pedro Silva",
          curso: "ENGENHARIA DE SOFTWARE/ES",
          matricula: "190084007",
          usuario: "190084007",
          formacao: "graduando",
          ocupacao: "aluno",
          email: "joao.pedro.silva@email.com"
        },
        {
          nome: "Maria Luiza",
          curso: "ENGENHARIA DE COMPUTAÇÃO/EC",
          matricula: "190084008",
          usuario: "190084008",
          formacao: "graduando",
          ocupacao: "aluno",
          email: "maria.luiza@email.com"
        }
      ]
  
      json_data.each do |dicente|
        password = 'senha_arbitraria'
        user_pesquisa = User.find_by_email(dicente[:email])
        if user_pesquisa.nil? && !(dicente[:email].nil?)
          @user = User.new(nome: dicente[:nome], email: dicente[:email], 
                curso: dicente[:curso], matricula: dicente[:matricula], 
                usuario: dicente[:usuario], formacao: dicente[:formacao], 
                ocupacao: dicente[:ocupacao], password: password, password_confirmation: password)
          @user.skip_confirmation_notification! 
          @user.save
          @user.send_reset_password_instructions
        end
      end
    end
end