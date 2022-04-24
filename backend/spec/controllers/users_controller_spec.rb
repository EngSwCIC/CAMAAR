require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  context "POST #create" do
    #cenario de sucesso => verificando se conseguimos inserir os elementos corretamente
    it "Should render Success" do
      member = Member.create(name: "testenome",registration: "testeregistro",
                             username:"testeusername",occupation: "testeoccupation",
                             degree: "testedegree",course: "testecourse",email:"acjpjvjp@gmail.com",
                             created_at: "",updated_at: "")
      post :create,params:{email_pessoa: "acjpjvjp@gmail.com",senha_pessoa: "1234567",
                           created_at: "",updated_at: ""}
      #não consegui fazer o expected mas podemos con
    end
    #cenario de fracasso => quando tenta criar no bd depois de alguem já ter se cadastrado
    #
end