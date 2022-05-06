require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  context "POST #create" do
    #cenario de sucesso => verificando se conseguimos inserir os elementos corretamente no banco de dados.
    it "Should render Success" do
      member = Member.create(name: "testenome",registration: "testeregistro",
                             username:"testeusername",occupation: "testeoccupation",
                             degree: "testedegree",course: "testecourse",email:"acjpjvjp@gmail.com",
                             created_at: "",updated_at: "")
      post :create,params:{email_pessoa: "acjpjvjp@gmail.com",senha_pessoa: "1234567",
                           created_at: "",updated_at: ""}

      expect(response.body).to include('acjpjvjp@gmail.com')
      expect(response.body).to include('1')

    end
    #cenario de fracasso => quando tenta criar no bd depois de alguem já ter se cadastrado
    # utilizaremos o mesmo membro criado no teste anterior para tentar criar outro usuario para esse membro.
    it "Should render Sucess" do
      post :create,params:{email_pessoa: "acjpjvjp@gmail.com",senha_pessoa: "1234567",
                           created_at: "",updated_at: ""}

      expect(response.body).to include('null')

    end
    #cenario de fracasso => quando tenta criar no bd um usuario que não existe membros cadastrados
    # utilizaremos o mesmo membro criado no teste anterior para tentar criar um usuario sem membro de
    # igual email cadastrado.
    it "Should render Sucess" do
      post :create,params:{email_pessoa: "lalajvjp@gmail.com",senha_pessoa: "1234567",
                           created_at: "",updated_at: ""}

      expect(response.body).to include('null')

    end
  end
end