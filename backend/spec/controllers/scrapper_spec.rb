require 'rails_helper'


RSpec.describe ScrapperController, :type => :controller do

    context 'method show' do

      it 'should render all the classes' do

          get :show
          expect(response).to have_http_status(200)
          
          turmasSigaa = JSON.parse(response.body)['classes']
          expect(turmasSigaa).to be_an(Array)
          expect(turmasSigaa.first).to have_key('name')
          expect(turmasSigaa.first).to have_key('code')
          expect(turmasSigaa.first).to have_key('class')
          expect(turmasSigaa.first['class']).to have_key('classCode')
          expect(turmasSigaa.first['class']).to have_key('semester')
          expect(turmasSigaa.first['class']).to have_key('time')

      end

      it 'should not return a empty response' do
        get :show
        expect(response).to have_http_status(200)
        expect(response.body).not_to be nil
      end

    end

    context "method index" do

      it "shoud import all members" do

          membros = [
                          {
                          code: "CIC0105",
                          classCode: "TA",
                          
                          dicente: 
                          [{
                          nome: "Ana Clara Jordao Perna",
                          curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",
                          matricula: "190084006",
                          usuario: "190084006",
                          formacao: "graduando",
                          ocupacao: "dicente",
                          email: "acjpjvjp@gmail.com"
                          },
                          {
                          nome: "Ana Paula Oliveira da Nobrega Costa",
                          curso: "ENGENHARIA DE COMPUTAÇÃO/CIC",
                          matricula: "190142120",
                          usuario: "190142120",
                          formacao: "graduando",
                          ocupacao: "dicente",
                          email: "anapaulaoncosta@gmail.com"
                          }],

                          docente: {
                          nome: "GENAINA NUNES RODRIGUES",
                          departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                          formacao: "DOUTORADO",
                          usuario: "78334926120",
                          email: "genaina@unb.br",
                          ocupacao: "docente"
                              }
                          }
                      ]
          
          corpo =  {
                      classes:
                      [
                      {:codigo => "CIC0105", :turma => "TA", :nome => "ENGENHARIA DE SOFTWARE", :semestre => "2021.2", :horario => "35M12"}
                      ]
                   }
        
            
          # Stub 
          allow(Api::ImportData).to receive(:call) do
              membros.to_json
          end
          
          #post '/import/turmas', params: corpo
          #headers = {​​​ 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }​​​
          post :index, params:corpo, body:corpo.to_json, as: :json
          expect(Member.first).to_not be_nil
          expect(response).to have_http_status(200)
          expect(response.body).to eq("{\"message\":\"Participantes importados com sucesso\"}")
      
      end
  end

end