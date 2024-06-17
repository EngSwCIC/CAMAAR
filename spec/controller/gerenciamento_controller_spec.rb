require 'rails_helper'

RSpec.describe GerenciamentoController, type: :controller do
  describe 'import data' do
    it 'renders the gerenciamento page' do
      put :import
      expect(response).to render_template('index')
    end

    describe 'invalid JSON' do
      it "warns because it's missing fields (classes.json)" do
        # fazendo um mock da leitura do arquivo pra eu conseguir testar com jsons especificos
        json_text = <<-EOF
          [ {"code": "CIC0000", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
        EOF
        filepath = "classes.json"
        allow(File).to receive(:read).with(filepath).and_return(json_text)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the class" do
        # fazendo um mock da leitura do arquivo pra eu conseguir testar com jsons especificos
        json_text = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath = "classes.json"
        allow(File).to receive(:read).with(filepath).and_return(json_text)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the student" do
        # fazendo um mock da leitura do arquivo pra eu conseguir testar com jsons especificos
        json_text = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": [{
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente",
              }],
              "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath = "classes.json"
        allow(File).to receive(:read).with(filepath).and_return(json_text)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end
    end
  end
end