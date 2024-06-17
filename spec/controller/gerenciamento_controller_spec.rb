require 'rails_helper'

RSpec.describe GerenciamentoController, type: :controller do
  describe 'import data' do
    it 'renders the gerenciamento page' do
      put :import
      expect(response).to render_template('gerenciamento/index')
    end

    describe 'invalid JSON' do
      it "warns because it's missing fields (classes.json)" do
        # fazendo um mock da leitura do arquivo pra eu conseguir testar com jsons especificos
        json_classes = <<-EOF
          [ {"code": "CIC0000", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": [{
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "silva@email.com"
              }],
              "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the class (class_member.json)" do
        json_classes = <<-EOF
          [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the student (class_members.json)" do
        json_classes = <<-EOF
          [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": [{
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente"
              }],
              "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end
    end

    it 'should warn that the data was imported successfully without errors in the JSON' do
      json_classes = <<-EOF
        [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
      EOF
      filepath_classes = "classes.json"
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members = <<-EOF
        [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
            "dicente": [{
              "nome": "Silva",
              "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
              "matricula": "54321",
              "usuario": "54321",
              "formacao": "graduando",
              "ocupacao": "dicente",
              "email": "silva@email.com"
            }],
            "docente": { 
              "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
            } ]
      EOF
      filepath_members = "class_members.json"
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      expect(flash[:notice]).to be_present
    end
  end
end