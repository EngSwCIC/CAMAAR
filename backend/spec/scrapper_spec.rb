require 'rails_helper'


RSpec.describe ScrapperController, :type => :controller do

    describe 'show' do

        before {get 'show'}

        it 'returns status code 200' do
            expect(response.status).to eq(200)
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